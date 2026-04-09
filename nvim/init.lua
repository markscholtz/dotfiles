-- Leader keys must be set before any require (lazy.nvim reads them at setup).
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

-- Local machine-specific overrides (matches ~/.vimrc_local pattern).
local local_init = vim.fn.expand("~/.config/nvim-local/init.lua")
if vim.uv.fs_stat(local_init) then
  dofile(local_init)
end
