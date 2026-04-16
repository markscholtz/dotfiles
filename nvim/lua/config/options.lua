-- Options ported from vim/vimrc for Neovim.
-- Settings that are nvim defaults (e.g. backspace, hlsearch, incsearch,
-- wildmenu, ruler, showcmd, syntax, filetype) are omitted.

local opt = vim.opt

-- General
opt.hidden = true
opt.autowrite = true
opt.history = 1000
opt.spell = false
opt.spellfile = vim.fn.expand("~/.vim/spell/en.utf-8.add")
opt.visualbell = true
opt.errorbells = false
opt.splitbelow = true
opt.splitright = true
opt.clipboard = "unnamedplus"

-- UI
opt.termguicolors = true
opt.background = "dark"
opt.cursorline = true
opt.laststatus = 3
opt.winbar = "%f"
opt.number = true
opt.relativenumber = true
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.winminheight = 0
opt.wildmode = "list:longest,full"
opt.whichwrap = "b,s,h,l,<,>,[,]"
opt.scrolloff = 3
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 99  -- Start with all folds open.
opt.gdefault = true

-- Formatting
opt.wrap = false
opt.autoindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true
opt.matchpairs:append("<:>")
opt.colorcolumn = "+1"
opt.list = true
opt.listchars = { tab = "▸ ", trail = "~", nbsp = "~", extends = "»", precedes = "«" }
