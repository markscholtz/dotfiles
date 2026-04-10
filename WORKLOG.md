# Worklog

## Nvim migration

The original setup was "vim-first": `nvim/init.vim` sourced `~/.vimrc` and added two
nvim-specific settings. Both `vim` and `vi` are aliased to Neovim. The config was
entirely Vimscript with minpac as the plugin manager.

Steps 1-3 cleaned up dead plugins, stale config, and orphaned files. Steps 4-6 were
skipped/deferred (absorbed into step 7). Step 7 built a new Lua-based nvim config from
scratch. The vimrc stays as a vim-only fallback.

Working branch: `nvim-lua-config`.

### 1. Remove dead plugins

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

### 2. Remove stale/orphaned configuration from vimrc

- [x] **Vimux mappings (~lines 189-211):** 7 keybindings for a plugin that isn't installed
- [x] **YouCompleteMe config (~lines 261-269):** YCM isn't installed; `<leader>jd` mapping and `g:ycm_semantic_triggers` are dead
- [x] **Ack config (~line 257):** `let g:ackprg = 'ag ...'` — neither ack.vim nor ag.vim is installed
- [x] **Powerline config (~lines 244-248):** commented-out Powerline settings
- [x] **Powerline section header (line 185):** says "Powerline" but actually configures Gundo — rename to "Gundo"
- [x] **DistractionFreeWriting function (~lines 225-234):** uses MacVim-specific GUI commands (`fullscreen`, `fuoptions`) that have no effect in terminal Neovim

### 3. Clean up tracked files that shouldn't be in git

- [x] Delete `vim/vim/.netrwhist` (auto-generated netrw history from 2013 with stale Ruby 1.9.3 paths)
- [x] Add `vim/vim/.netrwhist` to `.gitignore`
- [x] Add `vim/vim/tmp/` to `.gitignore` (contains 356 backup files and 151 swap files — runtime artifacts, not config)
- [x] Delete `vim/vim/ftplugin/nerdtree.vim` (NERDTree is not installed)

### ~~4. Remove redundant settings (already Neovim defaults)~~ — SKIPPED

Skipped — these settings are needed for vim compatibility. The vimrc is being kept
as-is as a fallback for when vim (not neovim) is needed.

### ~~5. Review Tripboard~~ — DEFERRED

Deferred — clipboard handling will be addressed as part of the new nvim config.

### ~~6. Modernize plugins~~ — DEFERRED

Deferred — plugin modernization is absorbed into the full nvim migration below.

### 7. Build new Lua-based nvim config

The vimrc (cleaned up in steps 1-3) stays as the vim fallback. Neovim gets a fresh
`init.lua` that no longer sources vimrc. Working branch: `nvim-lua-config`.

#### Directory structure

```
nvim/
  aliases.zsh                    # keep as-is
  init.lua                       # entry point (replaces init.vim)
  nvim-pack-lock.json            # auto-generated, commit for reproducibility
  lua/
    config/
      options.lua                # vim.opt settings (ported from vimrc)
      keymaps.lua                # non-plugin keymaps
      autocmds.lua               # autocommand groups
      plugins.lua                # vim.pack.add() + plugin configuration
```

#### Plugin decisions

**Keep (Vimscript, still best-in-class):**
fugitive, rhubarb, repeat, unimpaired, vinegar, endwise, dispatch, obsession,
tabular, vim-folding-rspec.

**Replace with Lua equivalents:**
- vim-solarized8 → `maxmx03/solarized.nvim` (treesitter highlight support)
- vim-airline → `lualine.nvim` (lighter, solarized theme)
- syntastic + tsuquyomi → `nvim-lspconfig` + `mason.nvim` (native LSP)
- vim-javascript, typescript-vim, vim-markdown → `nvim-treesitter`
- fzf.vim → `telescope.nvim` (Lua ecosystem integration, same keymaps)
- vim-surround → `nvim-surround` (same cs/ds/ys muscle memory, treesitter-aware)
- vim-commentary → `Comment.nvim` (treesitter-aware, handles embedded languages)

**Drop:**
vim-vroom, vim-rails, vim-rake, vim-bundler (add back on demand), ultisnips +
vim-snippets (nvim 0.10 native snippets + LSP), vim-markdown-folding (treesitter),
vim-scriptease.

#### Key design decisions

- **Leader:** set both `mapleader` and `maplocalleader` to `","` (vimrc only set localleader)
- **Clipboard:** `clipboard = "unnamedplus"` unconditionally — nvim 0.10 OSC 52 works through tmux. Drop tripboard keymaps.
- **Backup/swap/view:** use nvim defaults (`~/.local/state/nvim/`, `~/.local/share/nvim/`) — drop mkdir pattern
- **Local overrides:** load `~/.config/nvim-local/init.lua` if it exists (matches `~/.vimrc_local` pattern)
- **Folding:** treesitter foldexpr globally; test interaction with vim-folding-rspec for `_spec.rb` files
- **Plugin manager:** `vim.pack` (built-in, nvim 0.12+) — no bootstrap needed, replaces lazy.nvim

#### Tasks

**Phase 1 — Core foundation:**
- [x] `config/options.lua` — port vim.opt settings from vimrc
- [x] `config/keymaps.lua` — port non-plugin keymaps + utility functions
- [x] `config/autocmds.lua` — port autocommand groups
- [x] `init.lua` — entry point + local override loading

**Phase 2 — Plugins (via `vim.pack`):**
- [x] Upgrade Neovim to 0.12+ (`brew upgrade neovim`)
- [x] `config/plugins.lua` — vim.pack.add() for all plugins + configuration:
  - solarized.nvim (colorscheme)
  - repeat, unimpaired, vinegar, dispatch, obsession, tabular
  - fugitive + rhubarb
  - nvim-surround, Comment.nvim, endwise
  - nvim-treesitter (install for used languages)
  - telescope.nvim + fzf-native (migrated keymaps)
  - lualine.nvim (auto theme, minimal sections)
  - ~~nvim-lspconfig~~ vim.lsp.config + mason
  - vim-folding-rspec

**Phase 3 — Cutover:**
- [x] Delete `nvim/init.vim.bak`
- [x] Commit `nvim-pack-lock.json`
- [x] Verify end-to-end (colorscheme, keymaps, treesitter, LSP, clipboard, statusline, checkhealth)

## Move `homebrew/path.zsh` to `dotfiles-local`

The Homebrew PATH setup (`path=("/opt/homebrew/bin" $path)`) is Apple Silicon-specific
and belongs in the machine-local repo, not the universal dotfiles. Intel Macs use
`/usr/local` and Linux machines don't have Homebrew at all.

### Tasks

- [ ] Add `homebrew/path.zsh` (or equivalent) to `dotfiles-local`
- [ ] Remove `homebrew/path.zsh` from this repo
- [ ] Verify Homebrew is still on PATH after a fresh shell

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

Planned the new Lua-based nvim config structure (step 7). Key decisions:

- **Directory layout:** `nvim/lua/config/` for core settings (options, keymaps, autocmds,
  lazy bootstrap), `nvim/lua/plugins/` for lazy.nvim plugin specs grouped by function.
- **Plugin manager:** ~~lazy.nvim~~ → `vim.pack` (built-in, nvim 0.12+; replaces minpac for nvim).
- **Modern replacements:** treesitter (syntax), nvim-lspconfig + mason (LSP), telescope
  (fuzzy finding), lualine (statusline), nvim-surround, Comment.nvim, solarized.nvim.
- **Kept as-is:** tpope essentials (fugitive, rhubarb, repeat, unimpaired, vinegar,
  endwise, dispatch, obsession), tabular, vim-folding-rspec.
- **Dropped:** vim-vroom, rails/rake/bundler (add back on demand), ultisnips (nvim 0.10
  native snippets), vim-markdown-folding (treesitter), vim-scriptease.
- **Clipboard:** `unnamedplus` unconditionally — nvim 0.10 OSC 52 works through tmux
  natively, replacing tripboard.
- **Local overrides:** `~/.config/nvim-local/init.lua` pattern (matches vimrc_local).
- **Leader key:** set both `mapleader` and `maplocalleader` to `","` — the vimrc only
  set localleader, but Lua plugins expect `<leader>`.

### 2026-04-08

Completed Phase 1 of step 7: created the Lua-based nvim config foundation.

Renamed `nvim/init.vim` to `nvim/init.vim.bak` — nvim errors if both `init.vim` and
`init.lua` exist in the same config directory. The backup stays until Phase 4 cutover.

Created the following files:

- **`nvim/init.lua`** — entry point. Sets both leader keys to `,` before any requires
  (lazy.nvim reads `mapleader` during setup). Loads options, keymaps, autocmds, and
  lazy.nvim bootstrap in that order. Loads `~/.config/nvim-local/init.lua` via
  `dofile()` if it exists.

- **`nvim/lua/config/options.lua`** — `vim.opt` settings ported from vimrc. Dropped
  settings that are nvim defaults (backspace, hlsearch, incsearch, wildmenu, ruler,
  showcmd, etc.) to keep the file focused on non-default values. Key changes from
  vimrc: `clipboard=unnamedplus` is now unconditional (no tmux check, no tripboard),
  and backup/swap/view dirs use nvim defaults instead of custom `~/.vim/tmp/` paths.

- **`nvim/lua/config/keymaps.lua`** — non-plugin keymaps using `vim.keymap.set` with
  `<cmd>` syntax. Ported: jk escape, window/tab navigation, wrapped-line j/k, fold
  toggle, C-b increment (tmux workaround), search clear, config edit/source, and
  trailing whitespace strip. Dropped: tripboard keymaps (clipboard replaces them),
  C-S-S synstack mapping (treesitter inspect replaces it in Phase 3), fzf keymaps
  (telescope in Phase 3). Added `:Stab` and `:SynStack` as user commands.

- **`nvim/lua/config/autocmds.lua`** — three augroups ported: `set_relativenumber`
  (help/netrw get line numbers), `netrw_mappings` (override C-L for window nav),
  `set_filetypes` (json, less, md, Guardfile, coffee). Fixed a bug in the original
  vimrc where the `netrw_mappings` group was missing `autocmd!` — the Lua version
  uses `clear = true` on all groups.

- **`nvim/lua/config/lazy.lua`** — standard lazy.nvim bootstrap. Clones from the
  stable branch on first launch, prepends to rtp, and calls `setup()` importing
  from the `plugins/` directory with silent change detection.

- **`nvim/lua/plugins/.gitkeep`** — empty placeholder so lazy.nvim doesn't warn about
  a missing plugins directory. Will be replaced by actual plugin specs in Phase 2.

Switched from lazy.nvim to `vim.pack` (Neovim 0.12's built-in package manager).
Neovim 0.12.1 is available via Homebrew; current install is 0.10.0. The switch
simplifies the config: no bootstrap code needed, no third-party plugin manager
dependency. Deleted `config/lazy.lua` and `lua/plugins/` entirely. The `vim.pack.add()`
calls will go in a new `config/plugins.lua` when we add plugins in Phase 2.

This also collapses the old Phase 2 (low-config plugins) and Phase 3 (substantial
config plugins) into a single Phase 2, since vim.pack doesn't impose a spec-file-per-
group convention. All plugins and their configuration will live in `config/plugins.lua`.

### 2026-04-09

Completed Phase 2 of step 7: created `config/plugins.lua` with all plugin installation
and configuration. Added `require("config.plugins")` to `init.lua`.

21 plugins installed via a single `vim.pack.add()` call with PackChanged build hooks
for telescope-fzf-native (`make`) and nvim-treesitter (`TSUpdate`).

Key discoveries during implementation:

- **nvim-treesitter API changed:** the old `require("nvim-treesitter.configs").setup()`
  module no longer exists. The new API is `require("nvim-treesitter").install({...})`
  for parser installation. Treesitter highlighting is not enabled globally by default
  in nvim 0.12 — only lua, markdown, and vimdoc get it via bundled ftplugins. Added a
  FileType autocmd with `pcall(vim.treesitter.start)` to enable it for all filetypes
  with an available parser.

- **nvim-lspconfig deprecated:** `require('lspconfig')` framework is deprecated in
  nvim 0.11+ in favor of the built-in `vim.lsp.config()` + `vim.lsp.enable()`. Switched
  to the native API. nvim-lspconfig is still needed for its `lsp/` directory which
  provides default server configurations.

- **tree-sitter CLI required:** nvim-treesitter now shells out to `tree-sitter build`
  to compile parsers (older versions used cc/gcc directly). The Homebrew `tree-sitter`
  package is just the C library — the CLI is a separate `tree-sitter-cli` formula.
  Nvim 0.12 ships bundled parsers for c, lua, markdown, markdown_inline, query, vim,
  and vimdoc, so those work without the CLI.

Plugin configuration summary:
- **Colorscheme:** solarized.nvim with `vim.cmd.colorscheme("solarized")`
- **Telescope:** 5 keymaps migrated from fzf.vim (`,ff` find_files, `,fb` buffers,
  `,fl` buffer lines, `,fr` live_grep, `,fh` command history). Dropped `,fs` (snippets)
  and `,fw` (windows).
- **Lualine:** auto theme detection (picks up solarized), `showmode = false` to avoid
  duplicate mode indicator
- **LSP:** mason + mason-lspconfig for server installation (ensure_installed: lua_ls,
  ts_ls, ruby_lsp). `vim.lsp.config()` for lua_ls settings (vim global). LspAttach
  autocmd for `gd` → definition; other keymaps are nvim 0.11+ defaults (grn, gra, grr, K).
- **Editing:** nvim-surround and Comment.nvim with defaults (same muscle memory as
  vim-surround and vim-commentary)
- **No config needed:** repeat, unimpaired, vinegar, dispatch, obsession, endwise,
  fugitive, rhubarb, tabular, vim-folding-rspec

### 2026-04-10

Completed Phase 3 (cutover) of step 7. Deleted `nvim/init.vim.bak` — the old
init.vim that sourced vimrc is no longer needed. The lockfile was already committed
in the Phase 2 commit.

End-to-end verification passed:
- Colorscheme: solarized active
- Keymaps: all 5 telescope mappings (`,ff`, `,fb`, `,fl`, `,fr`, `,fh`) registered
- Treesitter: all 14 parsers compiled and queries valid (checkhealth all green)
- LSP: `vim.lsp.enable` configured for lua_ls, ts_ls, ruby_lsp; mason available
- Clipboard: `unnamedplus` set unconditionally
- Statusline: lualine loaded with auto theme, `showmode` disabled
- All plugin modules load without error (nvim-surround, Comment, lualine, telescope,
  mason, solarized)
- Telescope checkhealth: fzf extension working, ripgrep found (one cosmetic warning
  about optional `fd` — not needed, telescope falls back to `find`)
- Vim fallback: `/usr/bin/vim` still loads `~/.vimrc` correctly (aliased `vim`/`vi`
  commands go through nvim, but the raw binary + vimrc remain functional)

Step 7 is complete. The new Lua-based nvim config is fully operational.

### 2026-04-13

Created `claude/CLAUDE.md` in the dotfiles repo to hold global Claude Code instructions
(symlinked to `~/.claude/CLAUDE.md` via dotbot). First entry is the WORKLOG convention —
previously stored as a per-project auto-memory, now promoted to a global instruction so
it applies across all projects.

### 2026-04-15

Rewrote `README.md` from scratch on `master`. The old README was largely inherited from
the original forked repo — it referenced Pathogen (replaced by minpac years ago), had an
incomplete submodule list, and lacked any description of the actual repo structure. The
new README covers: Dotbot install, two-repo architecture with `dotfiles-local`, the
`*_local` override convention, Zsh module auto-discovery, minpac commands, and a complete
submodule table. Kept the `.cvsignore` tip as a footnote under Notes.

Also updated inline code comments in both `README.md` and `CLAUDE.md` to use sentence
case with trailing periods, and added that as a style convention in the global
`~/.claude/CLAUDE.md`.
