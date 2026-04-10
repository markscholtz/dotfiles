-- Build hooks — must be registered before vim.pack.add() to fire on first install.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end

    if name == "telescope-fzf-native.nvim" then
      vim.system({ "make" }, { cwd = ev.data.path }):wait()
    end

    if name == "nvim-treesitter" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

-- Install plugins.
vim.pack.add({
  -- Colorscheme
  "https://github.com/maxmx03/solarized.nvim",

  -- Tpope essentials
  "https://github.com/tpope/vim-repeat",
  "https://github.com/tpope/vim-unimpaired",
  "https://github.com/tpope/vim-vinegar",
  "https://github.com/tpope/vim-dispatch",
  "https://github.com/tpope/vim-obsession",
  "https://github.com/tpope/vim-endwise",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-rhubarb",

  -- Text alignment
  "https://github.com/godlygeek/tabular",

  -- Editing
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/numToStr/Comment.nvim",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",

  -- Telescope
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",

  -- Statusline
  "https://github.com/nvim-lualine/lualine.nvim",

  -- LSP
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",

  -- Ruby
  "https://github.com/markscholtz/vim-folding-rspec",
})

-- Colorscheme (before lualine so theme auto-detection works).
require("solarized").setup({})
vim.cmd.colorscheme("solarized")

-- Treesitter (install parsers — highlighting enabled via FileType autocmd below).
require("nvim-treesitter").install({
  "bash", "css", "html", "javascript", "json", "lua",
  "markdown", "markdown_inline", "ruby", "tsx", "typescript",
  "vim", "vimdoc", "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

-- Telescope
local telescope = require("telescope")
telescope.setup({})
telescope.load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fl", builtin.current_buffer_fuzzy_find, { desc = "Buffer lines" })
vim.keymap.set("n", "<leader>fr", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fh", builtin.command_history, { desc = "Command history" })

-- Lualine (showmode disabled since lualine shows mode in section_a).
require("lualine").setup({
  options = {
    theme = "auto",
  },
})
vim.opt.showmode = false

-- nvim-surround
require("nvim-surround").setup({})

-- Comment.nvim
require("Comment").setup({})

-- LSP (mason must be set up before mason-lspconfig).
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "ts_ls", "ruby_lsp" },
})

-- Use vim.lsp.config (nvim 0.11+) instead of deprecated require('lspconfig').
-- nvim-lspconfig provides default server configs via its lsp/ directory.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

vim.lsp.enable({ "lua_ls", "ts_ls", "ruby_lsp" })

-- LSP keymaps (gd only — grn/gra/grr/K are nvim 0.11+ defaults).
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      buffer = ev.buf,
      desc = "Go to definition",
    })
  end,
})
