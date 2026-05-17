# Dotfiles

Terminal-centric dev setup on macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

| Directory | Tool | Description |
|-----------|------|-------------|
| `nvim/` | [LazyVim](https://www.lazyvim.org/) | Neovim distro with LSP, Treesitter, Harpoon, mini-files, DAP debug |
| `wezterm/` | [WezTerm](https://wezfurlong.org/wezterm/) | GPU terminal - Catppuccin Mocha, JetBrainsMono Nerd Font, transparency |
| `tmux/` | [tmux](https://github.com/tmux/tmux) | Session manager - Catppuccin theme, sessionx, floax, resurrect |
| `starship/` | [Starship](https://starship.rs/) | Shell prompt - minimal left, git/time on right, Catppuccin palette |
| `aerospace/` | [AeroSpace](https://github.com/nikitabobko/AeroSpace) | Tiling window manager (i3-like) |
| `sketchybar/` | [SketchyBar](https://github.com/FelixKratz/SketchyBar) | Custom macOS status bar |
| `television/` | [Television](https://github.com/alexpasmantier/television) | Universal fuzzy picker - 70+ channels (git, docker, k8s, ssh...) |
| `zshrc/` | ZSH | Aliases, keybindings, tool integrations |

## Prerequisites

```bash
brew install neovim stow tmux starship fzf zoxide ripgrep fd lazygit \
             eza bat atuin direnv television zsh-autosuggestions
brew install --cask font-jetbrains-mono-nerd-font wezterm \
             nikitabobko/tap/aerospace
brew tap FelixKratz/formulae && brew install sketchybar
```

tmux plugin manager:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Install

```bash
git clone git@github.com:jimnguyendev/-dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
```

This symlinks everything into `~/.config/` (configured via `.stowrc`).

Then install tmux plugins:
```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

Open `nvim` and LazyVim will auto-install ~48 plugins on first launch.

## Key bindings cheat sheet

### tmux

Prefix key: `Ctrl+A` (all tmux shortcuts start with this).

**Settings:** vi mode, status bar on top, windows start at index 1, 1M scrollback history, system clipboard integration, session auto-restore on restart.

**Plugins (11):**

| Plugin | What it does |
|--------|-------------|
| [tpm](https://github.com/tmux-plugins/tpm) | Plugin manager |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank) | Copy to system clipboard |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save/restore sessions across restarts |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Auto-save sessions every 15 min |
| [tmux-thumbs](https://github.com/fcsonline/tmux-thumbs) | Quick copy - highlights URLs, paths, hashes to copy |
| [tmux-fzf](https://github.com/sainnhe/tmux-fzf) | Fuzzy finder for sessions, windows, panes |
| [tmux-fzf-url](https://github.com/wfxr/tmux-fzf-url) | Find and open URLs from scrollback |
| [catppuccin-tmux](https://github.com/catppuccin/tmux) | Catppuccin Mocha theme for status bar |
| [tmux-sessionx](https://github.com/omerxx/tmux-sessionx) | Session picker with fzf + zoxide integration |
| [tmux-floax](https://github.com/omerxx/tmux-floax) | Floating terminal overlay (80% width/height) |

**Windows:**

| Keys | Action |
|------|--------|
| `Ctrl+A Ctrl+C` | New window (opens at $HOME) |
| `Ctrl+A H` | Previous window |
| `Ctrl+A L` | Next window |
| `Ctrl+A Ctrl+A` | Toggle last two windows |
| `Ctrl+A 1-9` | Jump to window by number |
| `Ctrl+A r` | Rename current window |
| `Ctrl+A w` | List all windows |

**Panes:**

| Keys | Action |
|------|--------|
| `Ctrl+A v` | Split vertical (side by side) |
| `Ctrl+A s` | Split horizontal (top/bottom) |
| `Ctrl+A h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+A z` | Zoom/unzoom current pane |
| `Ctrl+A c` | Close current pane |
| `Ctrl+A x` | Swap pane down |
| `Ctrl+A ,/.` | Resize pane left/right |
| `Ctrl+A -/=` | Resize pane down/up |
| `Ctrl+A *` | Synchronize input to all panes |

**Sessions & Plugins:**

| Keys | Action |
|------|--------|
| `Ctrl+A o` | Session picker (sessionx + zoxide) |
| `Ctrl+A S` | Choose session (built-in) |
| `Ctrl+A p` | Floating terminal (floax) |
| `Ctrl+A d` | Detach from session |
| `Ctrl+A K` | Clear screen |
| `Ctrl+A R` | Reload tmux config |

**Copy mode (vi keys):**

| Keys | Action |
|------|--------|
| `Ctrl+A [` | Enter copy mode |
| `v` | Start selection (in copy mode) |
| `y` | Copy selection to clipboard |
| `q` | Exit copy mode |

**Typical workflow:**
```bash
tmux new -s project       # Create named session
# ... work ...
Ctrl+A v                  # Split for a terminal alongside editor
Ctrl+A o                  # Switch to another project session
Ctrl+A d                  # Detach, go home
tmux a -t project         # Reattach tomorrow (session survives)
```

### Neovim (leader: Space)

| Keys | Action |
|------|--------|
| `Space Space` | Find file |
| `Space /` | Grep project |
| `Space e` | File explorer |
| `Space g g` | LazyGit |
| `gd` | Go to definition |
| `gr` | Go to references |
| `Space c a` | Code actions |
| `jj` or `jk` | Exit insert mode |

### AeroSpace

| Keys | Action |
|------|--------|
| `Alt+H/J/K/L` | Focus window |
| `Alt+Shift+H/J/K/L` | Move window |
| `Alt+1/2/3/4` | Switch workspace |
| `Alt+Tab` | Last workspace |

## ZSH aliases

Source `~/.config/zshrc/.zshrc` from your `~/.zshrc`, or cherry-pick what you need.

Highlights: `gst` `gc` `gp` `glog` (git), `dco` `dps` `dx` (docker), `k` `kg` `kd` (kubectl), `l` `lt` (eza), `v` (nvim), `cat` (bat), `fcd` (fzf cd), `fv` (fzf + nvim).

## Credits

Based on [omerxx/dotfiles](https://github.com/omerxx/dotfiles), customized for personal use.
