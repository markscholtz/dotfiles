local map = vim.keymap.set

-- Escape insert mode
map("i", "jk", "<Esc>")

-- Window navigation
map("n", "<C-J>", "<C-W>j")
map("n", "<C-K>", "<C-W>k")
map("n", "<C-L>", "<C-W>l")
map("n", "<C-H>", "<C-W>h")

-- Tab navigation
map("n", "<S-H>", "gT")
map("n", "<S-L>", "gt")

-- Move through wrapped lines
map("n", "j", "gj", { silent = true })
map("n", "k", "gk", { silent = true })

-- Toggle fold
map("n", "<Space>", "za")

-- Increment number (C-a is tmux prefix)
map("n", "<C-b>", "<C-a>")

-- Clear search highlight
map("n", "<leader><Space>", "<cmd>nohlsearch<CR>", { silent = true })

-- Edit and source config
map("n", "<leader>ev", "<cmd>edit $MYVIMRC<CR>", { silent = true })
map("n", "<leader>sv", "<cmd>source $MYVIMRC<CR>", { silent = true })

-- Strip trailing whitespace
map("n", "<leader>sw", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local save_search = vim.fn.getreg("/")
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setreg("/", save_search)
  vim.api.nvim_win_set_cursor(0, cursor)
end, { silent = true, desc = "Strip trailing whitespace" })

-- :Stab — set tabstop/softtabstop/shiftwidth to the same value
vim.api.nvim_create_user_command("Stab", function()
  local input = vim.fn.input("set tabstop = softtabstop = shiftwidth = ")
  local ts = tonumber(input)
  if ts and ts > 0 then
    vim.bo.tabstop = ts
    vim.bo.softtabstop = ts
    vim.bo.shiftwidth = ts
  end
  local et = vim.bo.expandtab and "expandtab" or "noexpandtab"
  vim.cmd("redraw")
  vim.cmd(string.format(
    [[echohl ModeMsg | echon 'tabstop=%d shiftwidth=%d softtabstop=%d %s' | echohl None]],
    vim.bo.tabstop, vim.bo.shiftwidth, vim.bo.softtabstop, et
  ))
end, { desc = "Set tab/shift/softtab to same value" })

-- :SynStack — show syntax highlight groups under cursor
vim.api.nvim_create_user_command("SynStack", function()
  local stack = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
  local names = vim.tbl_map(function(id) return vim.fn.synIDattr(id, "name") end, stack)
  print(vim.inspect(names))
end, { desc = "Show syntax highlight groups under cursor" })
