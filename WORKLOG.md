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

## ~~4. Remove redundant settings (already Neovim defaults)~~ — SKIPPED

Skipped — these settings are needed for vim compatibility. The vimrc is being kept
as-is as a fallback for when vim (not neovim) is needed.

## ~~5. Review Tripboard~~ — DEFERRED

Deferred — clipboard handling will be addressed as part of the new nvim config.

## ~~6. Modernize plugins~~ — DEFERRED

Deferred — plugin modernization is absorbed into the full nvim migration below.

## 7. Build new Lua-based nvim config

The vimrc (cleaned up in steps 1-3) stays as the vim fallback. Neovim gets a fresh
`init.lua` that no longer sources vimrc.

- [ ] Plan the new config structure
- [ ] Set up `lazy.nvim` as plugin manager
- [ ] Migrate core settings (options, keymaps, autocmds) to Lua
- [ ] Add `nvim-treesitter` for syntax highlighting
- [ ] Add `nvim-lspconfig` for language server support
- [ ] Add a modern statusline (`lualine.nvim` or `mini.statusline`)
- [ ] Set up clipboard (replace tripboard with native nvim clipboard support)
- [ ] Carry over tpope essentials (fugitive, surround, repeat, unimpaired, etc.)
- [ ] Evaluate which remaining plugins to keep, replace, or drop
- [ ] Remove `nvim/init.vim` once `init.lua` is ready

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

### 2026-04-02

Decision: skip steps 4-6 and jump straight to a full Lua-based nvim modernization
(step 7). The reasoning:

- Step 4 (remove nvim defaults from vimrc) is counterproductive if the vimrc is
  being kept as a vim fallback — vim actually *needs* those settings.
- Step 5 (tripboard) will be solved differently in the new nvim config (native
  clipboard support).
- Step 6 (modernize plugins) is absorbed into the new config entirely.

The vimrc is in good shape after steps 1-3 cleaned out dead plugins, stale config,
and orphaned files. It stays as-is for the rare case vim (not neovim) is needed.
The new `init.lua` will be built from scratch rather than evolving the vimrc.

### 2026-04-13

Created `claude/CLAUDE.md` in the dotfiles repo to hold global Claude Code instructions
(symlinked to `~/.claude/CLAUDE.md` via dotbot). First entry is the WORKLOG convention —
previously stored as a per-project auto-memory, now promoted to a global instruction so
it applies across all projects.
