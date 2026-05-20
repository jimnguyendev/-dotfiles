# Hướng dẫn cài đặt dotfiles

Hướng dẫn từng bước để dựng lại bộ dotfiles này trên một máy macOS mới
(Apple Silicon hoặc Intel). Mọi thứ đều quản lý bằng [GNU Stow](https://www.gnu.org/software/stow/)
+ một script nhỏ cho Warp.

## 1. Chuẩn bị hệ thống

### 1.1 Cài Homebrew (nếu chưa có)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Sau khi cài xong, làm theo hướng dẫn cuối cùng của installer để thêm
`brew` vào `PATH` (`eval "$(/opt/homebrew/bin/brew shellenv)"` trên Apple Silicon).

### 1.2 Cài các CLI cần dùng

```bash
brew install neovim stow tmux starship fzf zoxide ripgrep fd lazygit \
             eza bat atuin direnv television zsh-autosuggestions
```

### 1.3 Cài terminal + fonts

```bash
brew install --cask font-jetbrains-mono-nerd-font font-hack-nerd-font \
             wezterm warp \
             nikitabobko/tap/aerospace
brew tap FelixKratz/formulae && brew install sketchybar
```

| App   | Vai trò                                   |
|-------|-------------------------------------------|
| WezTerm | Terminal chính, auto-attach tmux khi mở |
| Warp    | Terminal phụ cho AI agent / chat        |
| AeroSpace | Tiling window manager kiểu i3         |
| SketchyBar | Status bar macOS                     |

## 2. Clone repo

Repo có thể clone vào bất kỳ đâu — script dùng đường dẫn tuyệt đối, không phụ
thuộc vị trí. Mặc định khuyến nghị `~/Workspace/jimdev/dotfiles` (khớp với
symlink hiện tại) hoặc `~/dotfiles`.

```bash
mkdir -p ~/Workspace/jimdev
git clone git@github.com:jimnguyendev/-dotfiles.git ~/Workspace/jimdev/dotfiles
cd ~/Workspace/jimdev/dotfiles
```

> Chưa có SSH key? Dùng HTTPS: `git clone https://github.com/jimnguyendev/-dotfiles.git ...`

## 3. Chạy setup

```bash
./setup.sh
```

Script làm 2 việc:

1. `stow .` — symlink toàn bộ các thư mục con (`nvim/`, `wezterm/`, `tmux/`,
   `starship/`, `aerospace/`, `sketchybar/`, `television/`, `zshrc/`) vào
   `~/.config/` (cấu hình ở `.stowrc`).
2. Symlink thủ công `warp/settings.toml` → `~/.warp/settings.toml` và mỗi
   theme trong `warp/themes/*` → `~/.warp/themes/*` (Warp không đọc
   `~/.config`, nên không stow được).

### Xử lý khi stow báo conflict

Nếu trên máy đã có file/thư mục thật ở vị trí stow muốn ghi, nó sẽ báo
`existing target is neither a link nor a directory`. Xử lý:

```bash
mv ~/.config/<thư-mục-xung-đột> ~/.config/<thư-mục-xung-đột>.bak
./setup.sh
```

## 4. Cài tmux plugins

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```

Hoặc mở `tmux` rồi bấm `Ctrl+A` + `I` (in hoa) để TPM tự cài.

## 5. Khởi động Neovim lần đầu

```bash
nvim
```

LazyVim sẽ tự tải ~50 plugin (LazyVim core, blink.cmp, copilot, mini.files,
fzf-lua, harpoon, mason, treesitter, DAP…). Đợi tới khi cửa sổ Lazy đóng,
sau đó chạy:

```vim
:checkhealth
:Mason
```

để kiểm tra LSP / formatter / linter có thiếu gì không.

### Đăng nhập Copilot

```vim
:Copilot auth
```

Làm theo hướng dẫn dán device code vào trình duyệt.

## 6. Cấu hình terminal

### WezTerm

Mở WezTerm — config tự load từ `~/.config/wezterm/wezterm.lua`. Mặc định:
- Catppuccin Mocha, JetBrainsMono Nerd Font 13pt, line-height 1.3
- Cửa sổ 120×35, blur 30, opacity 0.85, không tab bar
- Khi mở, tự `tmux attach || tmux new -s main`
- `Ctrl+Q` fullscreen, `Ctrl+'` clear scrollback

### Warp

Mở Warp lần đầu, đăng nhập tài khoản (vì `is_settings_sync_enabled = true`).
Settings sẽ đọc từ symlink — chỉnh trong UI sẽ ghi đè file trong repo, đó
là điểm cần lưu ý: thay đổi setting trong Warp = `git diff` trong dotfiles.

Theme Tokyo Night đã có sẵn trong `~/.warp/themes/warp-tokyo-night/`. Vào
*Settings → Appearance → Themes* để chọn `Tokyo Night` (hoặc light/storm).

> Nếu Warp ghi đè `settings.toml` thật thay vì follow symlink (đã từng xảy
> ra với một số version), sau khi Warp khởi động lần đầu, kiểm tra:
> `ls -la ~/.warp/settings.toml` — phải là symlink. Nếu không, chạy lại
> `./setup.sh`.

## 7. ZSH

Repo có sẵn `zshrc/`. Nếu shell mặc định chưa phải zsh:

```bash
chsh -s /bin/zsh
```

Mở terminal mới — sẽ thấy Starship prompt (multi-line: info ở trên, ký tự
prompt ở dưới).

## 8. AeroSpace + SketchyBar (tùy chọn)

Mở AeroSpace lần đầu:

```bash
open -a AeroSpace
```

Cấp quyền Accessibility khi macOS hỏi. Config nằm ở
`~/.config/aerospace/aerospace.toml`.

Khởi động SketchyBar:

```bash
brew services start sketchybar
```

## 9. Verify mọi thứ chạy đúng

| Check                              | Kỳ vọng                                  |
|------------------------------------|------------------------------------------|
| `ls -la ~/.config/nvim`            | Symlink → `…/dotfiles/nvim`              |
| `ls -la ~/.warp/settings.toml`     | Symlink → `…/dotfiles/warp/settings.toml`|
| `nvim --headless "+Lazy! sync" +qa`| Không lỗi                                |
| `tmux new -s test \; ls`           | Status bar Catppuccin, prefix `Ctrl+A`   |
| Mở WezTerm                         | Tự vào tmux session `main`               |

## 10. Cập nhật sau này

```bash
cd ~/Workspace/jimdev/dotfiles
git pull
./setup.sh           # idempotent — chạy lại không vấn đề
nvim --headless "+Lazy! sync" +qa
```

## Cấu trúc repo

```
dotfiles/
├── setup.sh            # Entry point cài đặt
├── .stowrc             # Cấu hình stow → ~/.config
├── nvim/               # LazyVim
├── wezterm/            # WezTerm config
├── warp/               # ← MỚI: Warp settings + theme
│   ├── settings.toml
│   └── themes/warp-tokyo-night/
├── tmux/
├── starship/
├── aerospace/
├── sketchybar/
├── television/
├── zshrc/
└── HUONG_DAN.md        # Cheatsheet phím tắt tiếng Việt
```

## Gỡ cài đặt

```bash
cd ~/Workspace/jimdev/dotfiles
stow -D .                                   # gỡ symlink ~/.config
rm ~/.warp/settings.toml                    # gỡ symlink Warp
rm ~/.warp/themes/warp-tokyo-night
```
