local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Show line numbers in help and netrw buffers.
local number_group = augroup("set_relativenumber", { clear = true })
autocmd("FileType", {
  group = number_group,
  pattern = { "help", "netrw" },
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})

-- Override netrw's <C-L> (NetrwRefresh) so it navigates windows instead.
local netrw_group = augroup("netrw_mappings", { clear = true })
autocmd("FileType", {
  group = netrw_group,
  pattern = "netrw",
  callback = function(args)
    vim.keymap.set("n", "<C-L>", "<C-W>l", { buffer = args.buf })
  end,
})

-- Filetype detection for extensions nvim may not handle the same way.
local ft_group = augroup("set_filetypes", { clear = true })

autocmd({ "BufNewFile", "BufRead" }, {
  group = ft_group,
  pattern = "*.json",
  callback = function() vim.bo.filetype = "json" end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = ft_group,
  pattern = "*.less",
  callback = function() vim.bo.filetype = "css" end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = ft_group,
  pattern = "*.md",
  callback = function() vim.bo.filetype = "markdown" end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = ft_group,
  pattern = "Guardfile",
  callback = function() vim.bo.filetype = "ruby" end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = ft_group,
  pattern = "*.coffee",
  callback = function()
    vim.wo.foldmethod = "indent"
    vim.wo.foldenable = false
  end,
})
