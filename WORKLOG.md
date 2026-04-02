# Vim/Neovim Configuration Worklog

## Overview

The current setup is "vim-first": `nvim/init.vim` sources `~/.vimrc` and adds two
nvim-specific settings. Both `vim` and `vi` are aliased to Neovim 0.10.0. The config
is entirely Vimscript with minpac as the plugin manager.

---

## 1. Remove dead plugins

These are installed but unused, redundant, or broken:

- [x] `altercation/vim-colors-solarized` — not used; config uses `color solarized8` (lifepillar)
- [x] `vim-scripts/matchit.zip` — bundled with Vim 8+ and Neovim natively
- [x] `tlib_vim` + `vim-addon-mw-utils` — dependencies for vim-snipmate, which isn't installed; UltiSnips doesn't need them
- [x] `kana/vim-vspec` — Vim plugin testing framework; not needed unless actively developing Vim plugins
- [x] `zsh-users/zsh-completions` — ZSH plugin, not a Vim plugin; does nothing in vim/pack
- [x] `vim-scripts/JSON.vim` — Vim and Neovim have built-in JSON syntax highlighting
- [x] `sjl/gundo.vim` — requires Python 2 (EOL); maintained fork is mundo.vim, or use nvim's built-in `:earlier`/`:later`
- [x] `vim-scripts/taglist.vim` — unmaintained since ~2007

After removing from `PackInit()`, run `:PackClean` to delete the plugin directories.

## 2. Remove stale/orphaned configuration from vimrc

- [x] **Vimux mappings (~lines 189-211):** 7 keybindings for a plugin that isn't installed
- [x] **YouCompleteMe config (~lines 261-269):** YCM isn't installed; `<leader>jd` mapping and `g:ycm_semantic_triggers` are dead
- [x] **Ack config (~line 257):** `let g:ackprg = 'ag ...'` — neither ack.vim nor ag.vim is installed
- [x] **Powerline config (~lines 244-248):** commented-out Powerline settings
- [x] **Powerline section header (line 185):** says "Powerline" but actually configures Gundo — rename to "Gundo"
- [x] **DistractionFreeWriting function (~lines 225-234):** uses MacVim-specific GUI commands (`fullscreen`, `fuoptions`) that have no effect in terminal Neovim

## 3. Clean up tracked files that shouldn't be in git

- [x] Delete `vim/vim/.netrwhist` (auto-generated netrw history from 2013 with stale Ruby 1.9.3 paths)
- [x] Add `vim/vim/.netrwhist` to `.gitignore`
- [x] Add `vim/vim/tmp/` to `.gitignore` (contains 356 backup files and 151 swap files — runtime artifacts, not config)
- [x] Delete `vim/vim/ftplugin/nerdtree.vim` (NERDTree is not installed)

## 4. Remove redundant settings (already Neovim defaults)

These can be removed from vimrc since nvim always has them enabled:

- [ ] `set nocompatible`
- [ ] `set encoding=utf-8`
- [ ] `set hidden` (also, the comment says "Not sure what this does")
- [ ] `set incsearch`
- [ ] `set hlsearch`
- [ ] `set wildmenu`
- [ ] `set backspace=indent,eol,start`
- [ ] `set autoindent`
- [ ] `set history=1000` (nvim default is 10000)
- [ ] `set laststatus=2` (overridden to 3 in init.vim)
- [ ] `filetype plugin indent on`
- [ ] `syntax enable`
- [ ] `t_8f`/`t_8b` terminal escape sequences (Vim-specific, ignored by Neovim)
- [ ] Tmux cursor shape sequences (nvim handles cursor shape natively via `guicursor`)

If you want to keep Vim compatibility, guard these with `if !has('nvim')` instead of removing them.

## 5. Review Tripboard

`tripboard.vim` uses Ruby to shuttle text between Vim and a file for cross-pane clipboard sharing. Modern alternatives exist:

- [ ] Evaluate replacing with `set clipboard=unnamedplus` (pbcopy works out of the box on macOS)
- [ ] Consider nvim 0.10's built-in OSC 52 clipboard support
- [ ] Consider tmux's `set -g set-clipboard on`
- [ ] Resolve confusing duplicate clipboard mappings: tripboard maps `<Leader>C`/`<Leader>V`, vimrc maps `<LocalLeader>c`/`<LocalLeader>v`

## 6. Modernize plugins (larger effort)

Plugins that have much better modern alternatives in the Neovim ecosystem:

| Current | Replacement | Benefit |
|---|---|---|
| `syntastic` | nvim built-in LSP + diagnostics | Async diagnostics, go-to-definition, rename, etc. |
| `vim-airline` | `lualine.nvim` or `mini.statusline` | Faster, better nvim integration |
| `tsuquyomi` + `typescript-vim` | `nvim-lspconfig` + tsserver | Native LSP client, no Vimscript wrapper |
| `pangloss/vim-javascript` | `nvim-treesitter` | Better highlighting, indentation, text objects for all languages |
| `tpope/vim-markdown` | `nvim-treesitter` | Same |
| `junegunn/fzf.vim` | `telescope.nvim` | LSP integration, extensibility (lower priority — fzf still works fine) |
| `minpac` | `lazy.nvim` | Lazy-loading, lockfile, UI, de facto standard |

### Plugins worth keeping

- `tpope/vim-fugitive` + `vim-rhubarb` — still excellent
- `tpope/vim-surround` — classic (or switch to `mini.surround`)
- `tpope/vim-repeat`
- `tpope/vim-unimpaired`
- `tpope/vim-vinegar`
- `tpope/vim-endwise`
- `tpope/vim-dispatch`
- `tpope/vim-obsession`
- `godlygeek/tabular`

### Ruby/Rails plugins to evaluate

Drop if no longer doing Rails work:

- [ ] `tpope/vim-rails`
- [ ] `tpope/vim-rake`
- [ ] `tpope/vim-bundler`
- [ ] `skalnik/vim-vroom`
- [ ] `markscholtz/vim-folding-rspec`

## 7. Migrate to Lua-based nvim config (largest effort)

If pursuing a full modernization:

1. Switch to `lazy.nvim` as plugin manager
2. Add `nvim-lspconfig` for language server support
3. Add `nvim-treesitter` for syntax highlighting and text objects
4. Migrate vimrc settings to `init.lua`
5. Keep tpope essentials (they work fine from Lua configs)

This can be done incrementally — start with items 1-4 above, then layer in LSP and Treesitter.

---

## Log

### 2026-04-01

Completed step 1: removed 9 dead plugins from `PackInit()` in vimrc and ran
`:PackClean` to delete the plugin directories. The removed plugins were:
altercation/vim-colors-solarized, vim-scripts/matchit.zip, tlib_vim,
vim-addon-mw-utils, kana/vim-vspec, zsh-users/zsh-completions,
vim-scripts/JSON.vim, sjl/gundo.vim, and vim-scripts/taglist.vim.

Notably, zsh-users/zsh-completions was never intentionally a Vim plugin — it got
swept into the bundle directory and carried over during the Pathogen-to-minpac
migration in 2021. It's properly managed as a git submodule under
`zsh/zsh-completions/` and loaded via `zsh/completion.zsh`.

Completed step 2: removed stale/orphaned configuration from vimrc. Removed:
- Vimux mappings (7 keybindings for a plugin that was never installed)
- YouCompleteMe config (GoToDefinition mapping + semantic triggers — YCM not installed)
- Ack config (`g:ackprg` pointing at `ag` — neither ack.vim nor ag.vim installed, using fzf `:Rg` instead)
- Commented-out Powerline config (using vim-airline, not Powerline)
- "Powerline" section that actually contained a Gundo mapping (Gundo removed in step 1)
- Taglist mapping and config (Taglist removed in step 1)
- Vroom's `g:vroom_use_vimux = 1` setting (Vimux not installed, so this was dead)
- DistractionFreeWriting function (used MacVim GUI commands — `fuoptions`, `fullscreen` — that are no-ops in terminal Neovim; had a TODO saying it needed work)

Completed step 3: clean up tracked files that shouldn't be in git. Found that
`.netrwhist` and `vim/vim/tmp/` were already gitignored and untracked (likely
from a previous cleanup), so those items needed no action. Deleted
`vim/vim/ftplugin/nerdtree.vim` — a one-line ftplugin (`setlocal relativenumber`)
for NERDTree, which isn't installed.
