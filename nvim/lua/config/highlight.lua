-- Native symbol-under-cursor document highlighting.
-- 2-tier resolution strategy:
--   Tier 1: LSP (textDocument/documentHighlight) if supported by an active server for this buffer
--   Tier 2: Tree-sitter scope-aware locals query (highlights definition & usages within enclosing lexical scope)
-- If neither is supported, no highlighting is performed.
local M = {}

local ns = vim.api.nvim_create_namespace("symbol_highlight")

local ignored_filetypes = {
  dirvish = true,
  fugitive = true,
  TelescopePrompt = true,
  qf = true,
  help = true,
  netrw = true,
  gitcommit = true,
}

-- Default highlight groups if not configured by colorscheme
vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true, bg = "#3b4261", default = true })
vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true, bg = "#3b4261", default = true })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true, bold = true, bg = "#3b4261", default = true })

--- Clear all symbol highlights in the buffer.
---@param bufnr? integer Buffer number (defaults to current buffer)
function M.clear(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    pcall(vim.lsp.buf.clear_references)
  end
end

-- Helper: Check if a Tree-sitter node represents an identifier/symbol token
local function is_identifier_node(node)
  if not node then return false end
  if node:child_count() > 0 then return false end
  local t = node:type()
  if t:find("comment") or t:find("string") then return false end
  return t:find("identifier") ~= nil
    or t:find("name") ~= nil
    or t:find("variable") ~= nil
    or t:find("type") ~= nil
    or t == "constant"
    or t == "field"
end

-- Tier 1: LSP document highlight
local function try_lsp(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentHighlight" })
  if #clients > 0 then
    vim.lsp.buf.document_highlight()
    return true
  end
  return false
end

-- Tier 2: Tree-sitter scope-aware locals highlight
local function try_treesitter(bufnr, winid)
  local ft = vim.bo[bufnr].filetype
  local lang = vim.treesitter.language.get_lang(ft) or ft
  local ok_q, query = pcall(vim.treesitter.query.get, lang, "locals")
  if not ok_q or not query then
    return false
  end

  local ok_p, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  if not ok_p or not parser then
    return false
  end

  local cursor = vim.api.nvim_win_get_cursor(winid)
  local row, col = cursor[1] - 1, cursor[2]

  local trees = parser:parse()
  if not trees or not trees[1] then return false end
  local root = trees[1]:root()

  local node = vim.treesitter.get_node({ bufnr = bufnr, pos = { row, col } })
  if not node or not is_identifier_node(node) then
    return false
  end

  local symbol_text = vim.treesitter.get_node_text(node, bufnr)
  if not symbol_text or symbol_text == "" then return false end

  -- Find all scopes enclosing the cursor node
  local scopes = {}
  local curr = node:parent()
  while curr do
    local srow, _, erow, _ = curr:range()
    for id, captured in query:iter_captures(curr, bufnr, srow, erow + 1) do
      if captured:id() == curr:id() and query.captures[id] == "local.scope" then
        table.insert(scopes, curr)
        break
      end
    end
    curr = curr:parent()
  end
  table.insert(scopes, root)

  -- Find the innermost scope that defines this symbol
  local def_scope = nil
  for _, sc in ipairs(scopes) do
    local srow, _, erow, _ = sc:range()
    for id, captured in query:iter_captures(sc, bufnr, srow, erow + 1) do
      local cap = query.captures[id]
      if cap:find("definition") and vim.treesitter.get_node_text(captured, bufnr) == symbol_text then
        def_scope = sc
        break
      end
    end
    if def_scope then break end
  end

  -- Target scope is the definition scope, or the immediate enclosing scope
  local target_scope = def_scope or scopes[1] or root
  local srow, _, erow, _ = target_scope:range()

  local matches = {}
  local seen = {}
  for id, captured in query:iter_captures(target_scope, bufnr, srow, erow + 1) do
    local cap = query.captures[id]
    if cap:find("definition") or cap:find("reference") then
      local nid = captured:id()
      if not seen[nid] and vim.treesitter.get_node_text(captured, bufnr) == symbol_text then
        seen[nid] = true
        table.insert(matches, {
          node = captured,
          is_def = cap:find("definition") ~= nil,
        })
      end
    end
  end

  if #matches == 0 then
    return false
  end

  for _, m in ipairs(matches) do
    local msrow, mscol, merow, mecol = m.node:range()
    vim.api.nvim_buf_set_extmark(bufnr, ns, msrow, mscol, {
      end_row = merow,
      end_col = mecol,
      hl_group = m.is_def and "LspReferenceWrite" or "LspReferenceText",
    })
  end

  return true
end

--- Highlight symbol under cursor using LSP or Tree-sitter scope query.
function M.highlight()
  local bufnr = vim.api.nvim_get_current_buf()
  local winid = vim.api.nvim_get_current_win()

  if ignored_filetypes[vim.bo[bufnr].filetype] then
    return
  end
  if vim.api.nvim_get_mode().mode ~= "n" then
    return
  end

  M.clear(bufnr)

  if try_lsp(bufnr) then
    return
  end

  try_treesitter(bufnr, winid)
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup("document_highlight", { clear = true })

  vim.api.nvim_create_autocmd("CursorHold", {
    group = augroup,
    callback = function()
      M.highlight()
    end,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
    group = augroup,
    callback = function(ev)
      M.clear(ev.buf)
    end,
  })
end

M.setup()

return M
