# Dotfiles

Personal dotfiles for macOS, managing configuration for Zsh, Neovim/Vim, Tmux, Git, and supporting tools. Installed via [Dotbot](https://github.com/anishathalye/dotbot) which symlinks config files into `~`.

## Install

```sh
./install
```

This runs Dotbot with `install.conf.yaml`, which:
- Symlinks config files into `~` (ex: `~/.zshrc` -> `zsh/zshrc`, `~/.vimrc` -> `vim/vimrc`)
- Initializes git submodules
- Installs [fzf](https://github.com/junegunn/fzf), [rbenv](https://github.com/rbenv/rbenv), and Ruby

## Two-repo architecture

- **`dotfiles`** (this repo): Universal configs shared across machines.
- **`dotfiles-local`** (separate private repo): Machine-specific overrides with its own Dotbot `install.conf.yaml`.

Almost every major config sources a local override file at the end:

| Config | Local override |
|--------|---------------|
| `~/.zshrc` | `~/.zshrc_local` |
| `~/.zshenv` | `~/.zshenv_local` |
| `~/.vimrc` | `~/.vimrc_local` |
| `~/.gitconfig` | `~/.gitconfig_local` |
| `~/.tmux.conf` | `~/.tmux_local.conf` |

These local files are managed by `dotfiles-local`, not this repo.

## Zsh

`$ZSH` points to this repo root. The `zshrc` auto-discovers and sources all `**/*.zsh` files under `$ZSH` in this order:

1. `path.zsh` -- PATH additions
2. `*.zsh` -- everything else
3. `completion.zsh` -- completion setup (loaded last)

To add config for a new tool, create a directory with `.zsh` files following this naming convention. No registration needed.

Custom shell functions live in `zsh/functions/` and are autoloaded via `fpath`.

## Vim / Neovim

Plugins are managed by [minpac](https://github.com/k-takata/minpac) (Vim 8+ native packages), declared in `PackInit()` in `vim/vimrc`.

```vim
:PackUpdateAll    " Update all plugins.
:PackClean        " Remove plugins no longer in PackInit().
:PackStatus       " Show plugin status.
```

`nvim/init.vim` sources `~/.vimrc` and adds nvim-specific settings. Both `vim` and `vi` are aliased to `nvim`.

## Submodules

| Submodule | Purpose |
|-----------|---------|
| `dotbot/` | Install framework |
| `bin/fzf/` | Fuzzy finder |
| `bin/tripboard/` | Clipboard bridge for tmux + vim |
| `zsh/zsh-completions/` | Additional zsh completions |
| `vim/vim/pack/minpac/opt/minpac` | Plugin manager (plugins it manages are gitignored) |

```sh
git submodule update --init --recursive   # Initialize all.
git submodule foreach git pull origin master  # Update all.
```

To remove a submodule:

```sh
git submodule deinit <path>
git rm <path>
```

## Notes

### Ignoring tags files globally

From tpope's vim-pathogen README -- still useful general advice:

```sh
git config --global core.excludesfile '~/.cvsignore'
echo tags >> ~/.cvsignore
```

## Color scheme & typography

**Tokyo Night Moon** is the standard color scheme across all tools.

### Managed by this repo

- **Neovim**: `nvim/lua/config/plugins.lua` loads `folke/tokyonight.nvim` with `style = "moon"`. `lualine` auto-detects the matching theme.
- **Tmux**: `tmux/tmux.conf` sources `tmux/tokyonight_moon.tmux` (via `~/.tmux/tokyonight_moon.tmux`) for statusline tabs, powerline chevrons, and pane borders. This file is copied from the upstream `folke/tokyonight.nvim` extras directory (`extras/tmux/tokyonight_moon.tmux`).

### Client terminal setup (iTerm2)

When configuring a terminal client on macOS:

1. **Color preset**: Import `iterm/tokyonight_moon.itermcolors` (copied from `folke/tokyonight.nvim`'s `extras/iterm/tokyonight_moon.itermcolors`) under **Settings > Profiles > Colors > Color Presets... > Import...**.
2. **Font**: Set font to **JetBrainsMono Nerd Font Mono** (or any patched Nerd Font) under **Settings > Profiles > Text > Font** to render Devicon filetype icons and Powerline glyphs cleanly.

## Key conventions

- **Tokyo Night Moon** color scheme everywhere (Neovim, Tmux, iTerm2)
- **Vi keybindings** in Zsh (`bindkey -v`) and Tmux (`mode-keys vi`)
- **Tmux prefix** is `C-a` (Screen-style)
