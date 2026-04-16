# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal dotfiles repository for macOS, managing configuration for Zsh, Vim/Neovim, Tmux, Git, and supporting tools. Installed via [Dotbot](https://github.com/anishathalye/dotbot) which symlinks config files into `~`.

## Installation

```sh
./install                    # Runs Dotbot with install.conf.yaml.
```

This creates symlinks (e.g. `~/.zshrc` → `zsh/zshrc`, `~/.vimrc` → `vim/vimrc`), initializes git submodules, and installs fzf, rbenv, and Ruby.

## Two-Repo Architecture

- **`dotfiles`** (this repo): Universal configs shared across machines.
- **`dotfiles-local`** (`~/code/personal/dotfiles-local`): Machine-specific overrides — per-machine Brewfiles, tmuxinator layouts, zsh/tmux/git/vim local configs. Has its own Dotbot `install.conf.yaml`.

Almost every major config sources a `*_local` override file at the end:
- `~/.zshrc` → `~/.zshrc_local`
- `~/.zshenv` → `~/.zshenv_local`
- `~/.vimrc` → `~/.vimrc_local`
- `~/.gitconfig` → `~/.gitconfig_local`
- `~/.tmux.conf` → `~/.tmux_local.conf`

These local files are managed by `dotfiles-local`, not this repo.

## Zsh Module Convention

Each tool gets its own directory with optional `.zsh` files following a naming convention:

- `<tool>/path.zsh` — PATH additions (loaded first)
- `<tool>/aliases.zsh` — shell aliases
- `<tool>/completion.zsh` — completion setup (loaded last, after `compinit`)
- `<tool>/<anything>.zsh` — other config (loaded in the middle)

The `zshrc` auto-discovers and sources all `**/*.zsh` files under `$ZSH` in this order: path → everything else → compinit → completion. To add config for a new tool, create a directory with `.zsh` files — no registration needed.

Custom shell functions live in `zsh/functions/` and are autoloaded via `fpath`.

## Vim/Neovim

**Plugin manager**: [minpac](https://github.com/k-takata/minpac) (Vim 8+ native packages). Plugins are declared in `PackInit()` in `vim/vimrc`. Useful commands:

```vim
:PackUpdateAll    " Update all plugins.
:PackClean        " Remove plugins no longer in PackInit().
:PackStatus       " Show plugin status.
```

**Current structure**: `nvim/init.vim` sources `~/.vimrc` and adds two nvim-specific settings. Both `vim` and `vi` are aliased to `nvim` (in `nvim/aliases.zsh`).

**Active migration**: The Neovim config is being rewritten from scratch in Lua (`init.lua` with lazy.nvim, treesitter, LSP). See `WORKLOG.md` for the plan and progress. The existing vimrc stays as a Vim-only fallback.

## Git Submodules

Four submodules managed in this repo:

| Submodule | Purpose |
|-----------|---------|
| `dotbot/` | Install framework |
| `bin/fzf/` | Fuzzy finder |
| `bin/tripboard/` | Clipboard bridge for tmux+vim |
| `zsh/zsh-completions/` | Additional zsh completions |

minpac itself is also a submodule at `vim/vim/pack/minpac/opt/minpac`, but plugins it manages are gitignored (`vim/vim/pack/minpac/` is in `.gitignore`).

```sh
git submodule update --init --recursive   # Initialize all.
git submodule foreach git pull origin master  # Update all.
```

## Key Conventions

- **No build/test/lint system** — this is a config-only repo managed by Dotbot.
- **`$ZSH`** is set to this dotfiles repo root (e.g. `~/code/personal/dotfiles`), not Oh My Zsh. All zsh module sourcing is relative to this variable.
- **Solarized Dark** is the color scheme everywhere (vim, tmux, terminal).
- **Vi keybindings** in both Zsh (`bindkey -v`) and Tmux (`mode-keys vi`).
- **Tmux prefix** is `C-a` (Screen-style), not the default `C-b`.
