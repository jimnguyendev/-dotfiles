# Hướng Dẫn Sử Dụng – Từ VSCode / PhpStorm Sang Terminal Workflow

> Tài liệu này viết cho người quen VSCode hoặc PhpStorm muốn chuyển sang stack
> **WezTerm + tmux + LazyVim**. Không yêu cầu biết Vim trước.
> Đọc tuần tự lần đầu, sau đó dùng phần "Tra cứu nhanh" ở cuối.

---

## Mục lục

1. [Tổng quan kiến trúc](#1-tổng-quan-kiến-trúc)
2. [Cầu nối tư duy từ VSCode / PhpStorm](#2-cầu-nối-tư-duy-từ-vscode--phpstorm)
3. [Triết lý Vim – Modal editing](#3-triết-lý-vim--modal-editing)
4. [WezTerm](#4-wezterm)
5. [tmux – Quản lý session, window, pane](#5-tmux--quản-lý-session-window-pane)
6. [Neovim / LazyVim chi tiết](#6-neovim--lazyvim-chi-tiết)
7. [Cầu nối PhpStorm → LazyVim](#7-cầu-nối-phpstorm--lazyvim)
8. [Cầu nối VSCode → LazyVim](#8-cầu-nối-vscode--lazyvim)
9. [ZSH aliases & helpers](#9-zsh-aliases--helpers)
10. [AeroSpace – Tiling WM](#10-aerospace--tiling-wm)
11. [Television – Universal picker](#11-television--universal-picker)
12. [LazyGit](#12-lazygit)
13. [Workflow mẫu](#13-workflow-mẫu)
14. [Tình huống thực tế khi viết code](#14-tình-huống-thực-tế-khi-viết-code)
15. [Troubleshooting – "Stuck in vim"](#15-troubleshooting--stuck-in-vim)
16. [Lộ trình học 30 ngày](#16-lộ-trình-học-30-ngày)

---

## 1. Tổng quan kiến trúc

```
┌─ AeroSpace (tiling window manager ở macOS) ───────────────┐
│                                                            │
│   ┌─ WezTerm (terminal emulator) ─────────────────────┐    │
│   │                                                    │    │
│   │   ┌─ tmux (session/window/pane manager) ──────┐   │    │
│   │   │                                            │   │    │
│   │   │   Window 1: nvim (LazyVim – code editor)  │   │    │
│   │   │   Window 2: zsh (shell, chạy lệnh)        │   │    │
│   │   │   Window 3: lazygit (git TUI)             │   │    │
│   │   │                                            │   │    │
│   │   └────────────────────────────────────────────┘   │    │
│   └─────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘
```

**Vai trò từng lớp:**

| Lớp | Vai trò | Tương đương trong VSCode |
|-----|---------|--------------------------|
| AeroSpace | Sắp xếp cửa sổ app ở macOS | macOS Spaces / Stage Manager |
| WezTerm | Terminal emulator (vẽ text, font, color) | Không có – VSCode tự chứa |
| tmux | Persistent session, chia window/pane | Workspace + Terminal tab |
| Neovim | Code editor (sửa file) | Cửa sổ chính VSCode |
| LazyGit | Git TUI | Source Control sidebar |
| Television | Fuzzy picker đa kênh | Ctrl+Shift+P + Quick Open |

**Ý tưởng chính:** Mỗi lớp làm **một việc** thật tốt. Khác với IDE (một app làm tất), ở đây bạn **lắp ráp** tools tự bạn.

---

## 2. Cầu nối tư duy từ VSCode / PhpStorm

### Bạn đang **tư duy theo cửa sổ**, hãy chuyển sang **tư duy theo buffer**

Trong VSCode/PhpStorm, **mỗi tab là một khung nhìn và một file**. Đóng tab = đóng file khỏi bộ nhớ.

Trong Vim, có **3 khái niệm khác nhau**:

| Khái niệm | Mô tả | Ý nghĩa |
|-----------|-------|---------|
| **Buffer** | File đã load vào bộ nhớ | Có thể **ẩn** nhưng vẫn tồn tại, mở lại không cần load lại disk |
| **Window** (split) | Khung nhìn lên 1 buffer | Một buffer có thể hiện ở nhiều window, hoặc ẩn đi |
| **Tab** | Bố cục nhiều window | Không phải "file tabs" – ít dùng |

> **Bài học 1:** `:bd` (buffer delete) mới thật sự đóng file. Đóng split (`:q`) không đóng file.

### tmux session = workspace của VSCode

Trong VSCode bạn có "Workspace" – mỗi project một folder có `.vscode/settings.json`.
Trong tmux, **mỗi tmux session = một workspace**:

- Detach tmux (`Ctrl+A d`) = đóng VSCode nhưng **giữ nguyên** trạng thái (nvim vẫn mở, terminal vẫn chạy).
- Attach lại = quay lại workspace y nguyên, kể cả khi máy đã khởi động lại (nhờ `tmux-resurrect` + `tmux-continuum`).

### "Search Everywhere" của PhpStorm và "Quick Open" của VSCode = telescope.nvim + television

| Tác vụ | VSCode | PhpStorm | LazyVim / Stack mới |
|--------|--------|----------|---------------------|
| Mở file theo tên | `Ctrl+P` | `Ctrl+Shift+N` | `<Space><Space>` |
| Tìm text trong project | `Ctrl+Shift+F` | `Ctrl+Shift+F` | `<Space>/` |
| Tìm hàm/class | `Ctrl+T` | `Ctrl+N` | `<Space>ss` |
| Command palette | `Ctrl+Shift+P` | `Ctrl+Shift+A` | `<Space>` (which-key) |
| Mở file gần đây | `Ctrl+R` | `Ctrl+E` | `<Space>fr` |

### "Multi-cursor" → Visual block + macro + Treesitter

Bộ "multi-cursor" của VSCode/PhpStorm rất tiện nhưng **không cắm sâu** vào cơ bắp. Vim có 3 công cụ thay thế mạnh hơn:

- **Visual block** (`Ctrl+V`): chọn cột dọc, sửa đồng loạt.
- **Macro** (`q<tên><các thao tác>q` → phát lại `@<tên>`): ghi và replay chuỗi lệnh.
- **Treesitter swap / textobjects**: chọn cấu trúc cú pháp (function, class, argument).

---

## 3. Triết lý Vim – Modal editing

Khác biệt **lớn nhất** với VSCode: Vim có nhiều **mode**. Phím `j` ở mode khác nhau làm việc khác nhau.

### 5 mode chính

| Mode | Vào mode bằng | Ý nghĩa | Thoát về Normal |
|------|---------------|---------|-----------------|
| **Normal** | (default sau khi mở file) | Di chuyển, xóa, copy. **Không** gõ chữ được | – |
| **Insert** | `i` `a` `o` `I` `A` `O` | Gõ chữ như editor bình thường | `Esc` hoặc `Ctrl+[` |
| **Visual** | `v` (char), `V` (line), `Ctrl+V` (block) | Bôi đen (selection) | `Esc` |
| **Command** | `:` | Gõ lệnh (`:w`, `:q`, `:s/foo/bar/g`) | `Esc` hoặc `Enter` |
| **Replace** | `R` | Gõ đè lên chữ cũ | `Esc` |

> **Quy tắc vàng:** Lúc nào không biết mình đang ở đâu, **bấm `Esc` 2 lần** → về Normal.

### "Ngữ pháp" của Vim: Verb + Modifier + Noun

Vim không phải "phím tắt", mà là **một ngôn ngữ**. Khi quen, bạn nghĩ `delete-inside-parentheses` → gõ `di(`.

```
[count] <verb> <text-object>
   3       d        w           = delete 3 words
           c        i"          = change inside double-quote
           y        ap          = yank a paragraph
           v        i{          = visually select inside braces
           >        ip          = indent inside paragraph
```

**Verb thường dùng:**

| Verb | Ý nghĩa |
|------|---------|
| `d` | delete (xóa và đưa vào register) |
| `c` | change (xóa rồi vào Insert) |
| `y` | yank (copy) |
| `v` | visual select |
| `>` `<` | indent right / left |
| `=` | auto-format |
| `gu` `gU` | lowercase / UPPERCASE |
| `gc` | comment toggle (Comment.nvim trong LazyVim) |

**Text object thường dùng:**

| Object | Phạm vi |
|--------|---------|
| `w` `W` | từ (chấm bỏ) / từ (không dấu cách) |
| `s` | câu (sentence) |
| `p` | đoạn (paragraph) |
| `t` | thẻ HTML tag |
| `i"` `a"` | trong / quanh `""` (a = around, bao gồm dấu) |
| `i'` `a'` | trong / quanh `''` |
| `i(` `i[` `i{` | trong dấu ngoặc |
| `if` `af` | (Treesitter) trong / quanh function |
| `ic` `ac` | (Treesitter) trong / quanh class |

**Ví dụ thực tế:**

```
ci"     → trong file "hello world", con trỏ ở "hello" → bấm ci" → xóa "hello world" + vào Insert
da(     → xóa cả "func(a, b)" kể cả dấu ngoặc
yiw     → copy 1 từ
viwp    → paste đè lên 1 từ (substitute word)
ggVG    → chọn cả file (gg về đầu, V line-visual, G xuống cuối)
=ip     → auto-indent cả paragraph
gcip    → comment cả paragraph
```

### Motion (di chuyển) phải biết

| Phím | Di chuyển |
|------|-----------|
| `h j k l` | Trái / Xuống / Lên / Phải (một ký tự) |
| `w` `b` `e` | Đầu từ sau / đầu từ trước / cuối từ |
| `0` `^` `$` | Đầu dòng / đầu dòng (bỏ qua space) / cuối dòng |
| `gg` `G` | Đầu file / cuối file |
| `<số>G` | Tới dòng số đó (vd: `42G`) |
| `f<char>` `F<char>` | Nhảy đến ký tự tiếp / trước trên cùng dòng |
| `t<char>` `T<char>` | Như f/F nhưng dừng **trước** ký tự |
| `;` `,` | Lặp lại f/t / ngược lại |
| `%` | Nhảy đến dấu ngoặc đối xứng |
| `*` `#` | Tìm từ dưới con trỏ tới / lùi |
| `Ctrl+d` `Ctrl+u` | Cuộn xuống / lên nửa trang |
| `Ctrl+f` `Ctrl+b` | Cuộn xuống / lên 1 trang |
| `H` `M` `L` | Top / Middle / Bottom màn hình |
| `zz` `zt` `zb` | Đặt dòng hiện tại ra giữa / đầu / cuối màn hình |

### Edit nhanh

| Phím | Tác dụng |
|------|----------|
| `i` `a` | Insert trước / sau con trỏ |
| `I` `A` | Insert đầu dòng / cuối dòng |
| `o` `O` | Tạo dòng mới dưới / trên |
| `x` `X` | Xóa ký tự dưới / trước con trỏ |
| `dd` | Xóa cả dòng (vẫn là `d` + text object `d`) |
| `yy` | Copy cả dòng |
| `p` `P` | Paste sau / trước |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `.` | Lặp lại lệnh sửa **cuối cùng** (cực mạnh) |
| `J` | Nối dòng dưới vào dòng hiện tại |
| `r<char>` | Thay 1 ký tự |
| `~` | Toggle hoa/thường |
| `>>` `<<` | Indent dòng hiện tại phải / trái |

---

## 4. WezTerm

**Vị trí config:** `~/.config/wezterm/wezterm.lua` (symlink tới `dotfiles/wezterm/wezterm.lua`)

### Thiết lập hiện tại

- Font: **JetBrainsMono Nerd Font 13pt**, line-height 1.3
- Theme: **Catppuccin Mocha**
- Opacity 0.85 + blur 30 (trong suốt, mờ nền)
- Cửa sổ khởi động: 200 cột x 55 dòng
- **Tự động khởi động vào tmux session "main"** khi mở

### Phím tắt WezTerm

| Phím | Chức năng |
|------|-----------|
| `Ctrl+Q` | Toggle fullscreen (Native macOS) |
| `Ctrl+'` | Xóa scrollback buffer |
| `Cmd+Click` / `Ctrl+Click` | Mở link / file path |
| `Cmd++` / `Cmd+-` | Tăng / giảm font |
| `Cmd+0` | Reset font |

> **Lưu ý:** WezTerm không cần chia split riêng vì tmux đã lo. Hãy để tmux quản lý tất cả.

### Tại sao Nerd Font quan trọng

Status bar tmux (catppuccin), file icon trong neo-tree, indicator trong lualine – **tất cả dùng glyph của Nerd Font**.
Nếu bạn thấy ô vuông `▢` thay vì icon thì font terminal sai. Kiểm tra:

```bash
fc-list | grep -i nerd
```

---

## 5. tmux – Quản lý session, window, pane

### Prefix = `Ctrl+A`

**Cách gọi prefix:** bấm `Ctrl+A`, **thả tay ra**, rồi bấm phím tiếp theo.
Không giữ Ctrl cho phím thứ hai.

### Khái niệm 3 cấp

```
Session (project)
  └── Window 1 (tab logic)
  │     ├── Pane (chia khung)
  │     └── Pane
  └── Window 2
        └── Pane
```

- **Session** ~ "project workspace" – mỗi project nên 1 session.
- **Window** ~ "tab" trong session – đặt tên theo mục đích (nvim / shell / lazygit).
- **Pane** ~ chia một window thành nhiều khung trên cùng 1 tab.

### Sessions

| Phím | Chức năng |
|------|-----------|
| `Ctrl+A o` | **sessionx** picker (fzf + zoxide) – chọn/tạo session, hỗ trợ tìm thư mục |
| `Ctrl+A S` | choose-tree session built-in |
| `Ctrl+A d` | Detach session (giữ nền) |
| `Ctrl+A $` | Đổi tên session |
| `Ctrl+A )` `(` | Session kế / trước |
| `Ctrl+A p` | **floax** – terminal nổi trên màn hình (popup), bấm lại để đóng |

**Resurrect & continuum** đã bật:
- Tự động save session mỗi 15 phút (`continuum`).
- Khi mở lại máy, attach session = trạng thái ngay hôm trước (kể cả nvim).
- `Ctrl+A Ctrl+S` save thủ công, `Ctrl+A Ctrl+R` restore.

### Windows (giống tabs trong VSCode)

| Phím | Chức năng |
|------|-----------|
| `Ctrl+A Ctrl+C` | Tạo window mới (mở `$HOME`) |
| `Ctrl+A c` | **Đóng pane** (warning: không phải tạo window!) – xem ghi chú |
| `Ctrl+A H` | Window trước |
| `Ctrl+A L` | Window sau |
| `Ctrl+A Ctrl+A` | Last window (toggle 2 window cuối) |
| `Ctrl+A 1` ... `9` | Nhảy đến window số 1-9 |
| `Ctrl+A r` | Đổi tên window |
| `Ctrl+A w` | **choose-tree picker** (sau khi sửa ở dotfiles) – chọn window/session trực quan |
| `Ctrl+A &` | Kill window (hỏi xác nhận) |

> **Ghi chú:** `Ctrl+A c` ở config này được bind tới `kill-pane` (xem `tmux.reset.conf`).
> Default tmux là `new-window`, nếu bạn khó chịu có thể đổi lại trong reset file.

### Panes (chia cửa sổ)

| Phím | Chức năng |
|------|-----------|
| `Ctrl+A v` | Chia dọc (cạnh bên), giữ nguyên thư mục |
| `Ctrl+A s` | Chia ngang (trên/dưới), giữ nguyên thư mục |
| `Ctrl+A \|` | Chia ngang (built-in) |
| `Ctrl+A h/j/k/l` | Di chuyển giữa panes |
| `Ctrl+A z` | Zoom pane (toàn màn hình, bấm lại để thu nhỏ) |
| `Ctrl+A c` | Đóng pane hiện tại (binding ở config này) |
| `Ctrl+A x` | Hoán vị pane với pane kế |
| `Ctrl+A ,` `.` | Resize trái 20 / phải 20 |
| `Ctrl+A -` `=` | Resize xuống 7 / lên 7 |
| `Ctrl+A *` | Toggle sync panes (gõ 1 lần → nhiều pane cùng gõ) |
| `Ctrl+A q` | Hiện số pane vài giây (bấm số để focus) |

### Copy mode (cuộn, tìm, copy text)

| Phím | Chức năng |
|------|-----------|
| `Ctrl+A [` | Vào copy mode |
| `h j k l` `w b` | Di chuyển kiểu Vim |
| `Ctrl+u` `Ctrl+d` | Cuộn nửa trang |
| `g` `G` | Đầu / cuối buffer |
| `/` `?` | Tìm tới / lùi |
| `n` `N` | Kết quả tìm kế / trước |
| `v` | Bắt đầu chọn |
| `Ctrl+V` | Block selection |
| `y` | Copy vào clipboard hệ thống (nhờ `tmux-yank`) |
| `q` hoặc `Esc` | Thoát copy mode |

### Khác

| Phím | Chức năng |
|------|-----------|
| `Ctrl+A K` | Clear screen + Enter |
| `Ctrl+A R` | Reload `~/.config/tmux/tmux.conf` |
| `Ctrl+A I` | TPM: install / update plugins |
| `Ctrl+A U` | TPM: update plugins |
| `Ctrl+A :` | Command prompt của tmux (vd: `:setw synchronize-panes`) |
| `Ctrl+A t` | Hiện đồng hồ lớn trong pane |

### Mouse mode

Config đã bật `set -g mouse on`, nghĩa là:
- Scroll wheel trong TUI app (claude code, less, nvim) được tmux truyền thẳng xuống app → cuộn đúng kiểu native.
- Scroll wheel trong shell thường → tmux tự vào copy-mode để cuộn lịch sử. Bấm `q` để thoát.
- Click vào pane khác → focus pane đó. Drag border → resize pane.
- Muốn select text bằng chuột để copy ra ngoài tmux, giữ `Option` (Alt) khi kéo trong WezTerm.

### Status bar (catppuccin)

Bên trái: `[session_name]` + window list.
Bên phải: thư mục hiện tại + đồng hồ (`%H:%M`).

Tùy chỉnh trong `tmux/tmux.conf`:

```
set -g @catppuccin_status_modules_right "directory date_time"
set -g @catppuccin_date_time_text "%H:%M"
```

Đổi format: vd `"%H:%M  %d-%b"` để thêm ngày.

---

## 6. Neovim / LazyVim chi tiết

**Leader = `<Space>`**. Tất cả shortcut chữ cái trong LazyVim đều bắt đầu bằng `Space`.

> **Khi quên leader, dùng `<Space>` một lần trong Normal mode** – which-key sẽ hiện menu các phím tiếp theo. Không cần nhớ hết.

### Cấu trúc thư mục nvim

```
dotfiles/nvim/
├── init.lua              # entry point – load LazyVim
├── lazy-lock.json        # version lock của plugin
├── lazyvim.json          # cấu hình "extras" đã bật
├── stylua.toml           # rule format Lua code
└── lua/
    ├── config/           # cấu hình hệ thống (autocmds, keymaps, options)
    └── plugins/          # thêm plugin / override LazyVim
```

Khi thêm plugin mới: tạo file `.lua` trong `lua/plugins/` – LazyVim **tự động** load.

### File & Navigation

| Phím | Chức năng | Tương đương VSCode |
|------|-----------|--------------------|
| `<Space><Space>` | Tìm file (fuzzy) | `Ctrl+P` |
| `<Space>ff` | Find files (cwd) | `Ctrl+P` |
| `<Space>fr` | Recent files | `Ctrl+R` |
| `<Space>fb` | Find buffers | `Ctrl+Tab` |
| `<Space>/` | Live grep cả project | `Ctrl+Shift+F` |
| `<Space>sw` | Search word dưới con trỏ | – |
| `<Space>sg` | Live grep (alias) | – |
| `<Space>ss` | Symbol trong file | `Ctrl+Shift+O` |
| `<Space>sS` | Symbol toàn workspace | `Ctrl+T` |
| `<Space>e` | Toggle neo-tree (explorer) | `Ctrl+B` |
| `<Space>E` | neo-tree ở file hiện tại | `Right click reveal` |
| `<Space>,` | Buffer picker | `Ctrl+Tab` |
| `<Space>bd` | Delete buffer (close file) | `Ctrl+W` |
| `<Space>bD` | Delete buffer kèm force | – |
| `<Space>bp` | Pin buffer | – |
| `<Space>fp` | Find Plugin File (custom) | – |

### LSP / Code

| Phím | Chức năng | Tương đương |
|------|-----------|-------------|
| `gd` | Go to definition | F12 |
| `gD` | Go to declaration | – |
| `gr` | References | Shift+F12 |
| `gI` | Implementation | Ctrl+F12 |
| `gy` | Type definition | – |
| `K` | Hover documentation | Mouse over / Ctrl+K K |
| `<Space>ca` | Code actions | `Ctrl+.` / `Alt+Enter` |
| `<Space>cr` | Rename symbol | F2 |
| `<Space>cf` | Format file (conform.nvim) | `Shift+Alt+F` |
| `<Space>cd` | Line diagnostics | – |
| `<Space>cs` | Symbols outline | `Ctrl+Shift+O` |
| `]d` `[d` | Diagnostic kế / trước | F8 / Shift+F8 |
| `]e` `[e` | Error kế / trước | – |
| `<Space>xx` | Trouble panel (all diagnostics) | Problems tab |
| `<Space>xd` | Document diagnostics | – |

### Cửa sổ / Splits trong nvim

| Phím | Chức năng |
|------|-----------|
| `<Space>wv` hoặc `<Ctrl-w>v` | Split dọc |
| `<Space>ws` hoặc `<Ctrl-w>s` | Split ngang |
| `<Ctrl-h/j/k/l>` | Di chuyển giữa splits (cũng làm việc với tmux pane qua `vim-tmux-navigator`) |
| `<Ctrl-w>=` | Resize bằng nhau |
| `<Ctrl-w>_` | Tối đa chiều cao split |
| `<Ctrl-w>\|` | Tối đa chiều ngang split |
| `<Space>-` | Split dưới (LazyVim) |
| `<Space>\|` | Split phải (LazyVim) |
| `<Ctrl-w>q` | Đóng split |

### Tabs (ít dùng – dùng buffer thay)

| Phím | Chức năng |
|------|-----------|
| `<Space><Tab><Tab>` | Tab mới |
| `<Space><Tab>]` | Tab kế |
| `<Space><Tab>[` | Tab trước |
| `<Space><Tab>d` | Đóng tab |

### Git

| Phím | Chức năng |
|------|-----------|
| `<Space>gg` | **LazyGit** full TUI |
| `<Space>gG` | LazyGit cho file hiện tại |
| `<Space>gb` | Git blame full file (`gitsigns`) |
| `<Space>gB` | Git blame line |
| `]h` `[h` | Hunk kế / trước |
| `<Space>ghs` | Stage hunk |
| `<Space>ghr` | Reset hunk |
| `<Space>ghp` | Preview hunk |
| `<Space>ghd` | Diffview |

### Save / Quit / Run

| Lệnh | Ý nghĩa |
|------|---------|
| `:w` | Save |
| `:wa` | Save tất cả |
| `:q` | Quit |
| `:q!` | Quit không save |
| `:wq` hoặc `:x` | Save & quit |
| `:qa` | Quit tất cả |
| `:e <path>` | Mở file |
| `:e!` | Reload file từ disk |
| `:bd` | Close buffer |
| `:so %` | Source file Lua hiện tại |
| `:!<cmd>` | Chạy shell command (vd: `:!ls`) |
| `:r !<cmd>` | Chèn output shell vào buffer |

### Search & replace

| Lệnh | Chức năng |
|------|-----------|
| `/foo` | Tìm "foo" tới |
| `?foo` | Tìm "foo" lùi |
| `n` `N` | Kết quả kế / trước |
| `:%s/foo/bar/g` | Replace toàn file |
| `:%s/foo/bar/gc` | Replace có confirm |
| `:%s/\<foo\>/bar/g` | Replace whole-word (`\<...\>` là word boundary) |
| `<Space>sr` | Spectre – search & replace project-wide (nếu cài) |
| `*` `#` | Tìm từ dưới con trỏ tới / lùi |

### Snippets (LuaSnip mặc định trong LazyVim)

- Bấm tab khi popup cmp mở để chấp nhận gợi ý / nhảy placeholder.
- `<Ctrl-l>` `<Ctrl-h>` jump placeholder tới / lùi.
- Snippet ngữ cảnh ngôn ngữ kích hoạt sau khi LSP server (Mason install) sẵn sàng.

### Autocomplete (nvim-cmp)

- Trong Insert, đánh chữ sẽ bật popup.
- `<Tab>` `<S-Tab>` chọn item.
- `<Enter>` confirm.
- `<Ctrl-e>` cancel popup.
- `<Ctrl-Space>` mở popup thủ công.

### Mason – quản lý LSP / formatter / linter

```
:Mason              -- mở UI Mason
:LspInstall <tên>   -- cài LSP server
:MasonUpdate        -- cập nhật
```

LSP đã có sẵn khi LazyVim phát hiện filetype.
Ví dụ `.php` → bạn cần `:Mason` cài `intelephense` hoặc `phpactor`.
File `.go` → `gopls`. JS/TS → `typescript-language-server`.

### Conform.nvim – format

Format khi save đã bật cho các filetype cấu hình trong `lua/plugins/conform.lua`.
Format thủ công: `<Space>cf`.

### Comment (Comment.nvim)

| Phím | Tác dụng |
|------|----------|
| `gcc` | Toggle comment dòng hiện tại |
| `gc` + motion | Comment range (vd `gcap` = comment 1 paragraph) |
| `gc` (Visual) | Comment selection |

### Surround (nvim-surround)

Đã bật trong `lua/plugins/surround.lua`.

| Phím | Ý nghĩa |
|------|---------|
| `ys<motion><char>` | Add surround. Vd `ysiw"` = surround word với `""` |
| `ds<char>` | Delete surround. Vd `ds"` xóa `""` quanh con trỏ |
| `cs<old><new>` | Change. Vd `cs'"` đổi `'...'` thành `"..."` |
| `ysiwt<tag>` | Surround word với HTML tag |

### Macros – "ghi và replay"

```
qa              → bắt đầu ghi vào register a
... làm việc ...
q               → ngưng ghi
@a              → replay
@@              → replay lần nữa
10@a            → replay 10 lần
```

Mạnh hơn multi-cursor của VSCode khi dùng đúng.

### Multi-cursor thay thế

LazyVim có `<Ctrl-N>` (vim-visual-multi nếu extra). Hoặc dùng:

```
:%s/pattern/replace/g       -- replace toàn file
ggVG=                       -- chọn cả file rồi auto-indent
Ctrl+V <chọn cột> I <chữ> Esc  -- block insert
```

### Neo-tree shortcut quan trọng (khi đang trong neo-tree)

| Phím | Tác dụng |
|------|----------|
| `<Enter>` | Mở file |
| `a` | Add file/folder (`foo/` = folder; `bar/baz.go` = tạo cả chain) |
| `A` | Add folder |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy → tới đích → `p` paste |
| `x` | Cut |
| `m` | Move |
| `y` | Copy tên file |
| `Y` | Copy full path |
| `o` | **Prefix sort** (`oc`/`og`/`om`/`on`/`os`/`ot`) – không phải open |
| `H` | Toggle hidden files |
| `R` | Refresh |
| `?` | Help (xem toàn bộ keymap) |

### Telescope tips

- Trong picker: `<Ctrl-j>` `<Ctrl-k>` di chuyển, `<Ctrl-q>` đưa tất cả kết quả vào quickfix.
- `<Ctrl-x>` mở trong split ngang, `<Ctrl-v>` mở trong split dọc.
- `<Esc>` thoát luôn (LazyVim cấu hình insert-mode-on-open).

---

## 7. Cầu nối PhpStorm → LazyVim

| PhpStorm | LazyVim / Tools |
|----------|-----------------|
| Search Everywhere (`Shift Shift`) | `<Space><Space>` (file) + `<Space>/` (text) + `<Space>sS` (symbol) |
| Find Action (`Ctrl Shift A`) | `<Space>` → dùng which-key, hoặc `:` gõ lệnh |
| Refactor → Rename (`Shift F6`) | `<Space>cr` |
| Refactor → Extract Method | Code actions `<Space>ca` (nếu LSP support, vd: tsserver, intelephense) |
| Reformat Code (`Cmd Alt L`) | `<Space>cf` (conform.nvim) hoặc auto-save |
| Optimize Imports | `<Space>co` (nếu có), hoặc LSP code action |
| Find Usages (`Alt F7`) | `gr` |
| Go to Declaration (`Cmd B`) | `gd` |
| Go to Implementation (`Cmd Alt B`) | `gI` |
| Go to Test (`Cmd Shift T`) | Dùng neotest nếu cài |
| Run / Debug | `nvim-dap` + `nvim-dap-ui` (LazyVim extra "dap" có sẵn) |
| Database tool | external app (TablePlus / DBeaver), hoặc plugin `vim-dadbod-ui` |
| HTTP Client | plugin `rest.nvim` hoặc dùng `curl` / `xh` (alias `http`) |
| Live Templates | LuaSnip snippets |
| Local History | `undotree` (`<Space>uu`) – di chuyển graph undo |
| Code With Me | Không có tương đương – dùng `tmate` nếu cần share session |
| .editorconfig | LazyVim hỗ trợ mặc định |
| Markdown preview | plugin `markdown-preview.nvim` hoặc dùng `glow` trong terminal |
| Bookmark dòng (`F11`) | `<Space>ma` (harpoon nếu cài) hoặc `mA` (built-in mark) |

### Đặc biệt cho PHP

Cài các thành phần sau qua `:Mason`:

- `intelephense` (LSP – free version OK) hoặc `phpactor`
- `php-cs-fixer` hoặc `pretty-php` (formatter)
- `phpstan` hoặc `psalm` (linter)
- `phpdebug-adapter` (xdebug qua DAP)

Cấu hình nhanh trong `lua/plugins/php.lua`:

```lua
return {
  { "neovim/nvim-lspconfig", opts = {
      servers = { intelephense = {} } } },
  { "stevearc/conform.nvim",  opts = {
      formatters_by_ft = { php = { "php_cs_fixer" } } } },
}
```

---

## 8. Cầu nối VSCode → LazyVim

| VSCode | LazyVim |
|--------|---------|
| `Ctrl+P` Quick Open | `<Space><Space>` |
| `Ctrl+Shift+P` Command Palette | `<Space>` (which-key) + `:` (vim cmd) |
| `Ctrl+B` Toggle sidebar | `<Space>e` (neo-tree) |
| `Ctrl+J` Toggle terminal | `<Space>tt` (toggleterm) hoặc `Ctrl+A %` (tmux pane) |
| `Ctrl+Shift+F` Find in files | `<Space>/` |
| `Ctrl+Shift+H` Replace in files | Spectre `<Space>sr` hoặc `:cdo s/foo/bar/gc` |
| `Ctrl+D` Multi-cursor add next | `*` → `cgn` → `.` lặp |
| `Alt+Click` Add cursor | Visual block `Ctrl+V` |
| `F2` Rename symbol | `<Space>cr` |
| `Ctrl+.` Quick fix | `<Space>ca` |
| `Ctrl+/` Toggle comment | `gcc` |
| `Alt+Up/Down` Move line | `:m+1` / `:m-2`, hoặc map `<A-j>` `<A-k>` (LazyVim mặc định) |
| `Ctrl+Enter` New line below | `o` |
| `Ctrl+G` Go to line | `<số>G` (vd `42G`) |
| `Ctrl+Tab` Switch buffer | `<Space>,` hoặc `<S-h>` `<S-l>` |
| Zen mode | `<Space>uZ` |
| Settings sync | Git cả thư mục `~/.config/nvim` |

### Multi-cursor "thay thế" cụ thể

Yêu cầu: đổi `oldName` → `newName` ở nhiều chỗ trong file.

**Cách Vim:**

```
/oldName<Enter>      -- tìm
cgn newName<Esc>     -- change next match, đổi xong về normal
.                    -- lặp lại cho kết quả tiếp theo
.                    -- ...
```

**Hoặc:**

```
:%s/\<oldName\>/newName/gc   -- replace toàn file có confirm từng lần
```

---

## 9. ZSH aliases & helpers

**Vị trí:** `dotfiles/zshrc/.zshrc` (symlink tới `~/.zshrc`)

### Git

```bash
gst              # git status
gc "msg"         # git commit -m "msg"
gca "msg"        # git commit -a -m
gp               # git push origin HEAD
gpu main         # git pull origin main
glog             # git log đẹp có graph
gco branch       # git checkout
gb               # git branch
gba              # git branch -a
gadd file        # git add
ga               # git add -p (interactive)
gdiff            # git diff
gre              # git reset
```

### Docker

```bash
dco up -d        # docker compose up -d
dco logs -f      # docker compose logs
dps              # docker ps
dpa              # docker ps -a
dx container     # docker exec -it
```

### Kubernetes

```bash
k get pods       # kubectl get pods
kg pods          # kubectl get
kd pod tên       # kubectl describe
kl pod           # kubectl logs -f
ke pod -- sh     # kubectl exec -it
kc cluster       # kubectx
kns namespace    # kubens
kcns ns          # set current namespace
```

### File / Navigation

```bash
l                # eza -l --icons --git -a
lt               # eza tree view (level 2)
ltree            # eza tree không long format
cat file         # bat (syntax highlight)
v file           # nvim
cx folder        # cd vào + ls
fcd              # fzf cd
fv               # fzf find file → mở nvim
..               # cd ..
...              # cd ../..
....             # cd ../../..
```

### Khác

```bash
http URL         # xh (curl thay thế)
cl               # clear
server           # python http server port 4445
tunnel           # ngrok http 4445
mat              # cmatrix trong tmux window mới (vui :))
```

### Autosuggestions (chữ xám phía sau)

- `Ctrl+E` – chấp nhận gợi ý (chỉ điền, **chưa** chạy)
- `Ctrl+W` – chấp nhận gợi ý và **chạy luôn**

---

## 10. AeroSpace – Tiling WM

**Vị trí config:** `aerospace/aerospace.toml` (symlink tới `~/.config/aerospace/aerospace.toml`)

Bắt đầu: Mở AeroSpace.app từ `/Applications`, cho phép Accessibility trong System Settings.

### Phím cơ bản

| Phím | Chức năng |
|------|-----------|
| `Alt+H/J/K/L` | Focus cửa sổ trái/dưới/trên/phải |
| `Alt+Shift+H/J/K/L` | Di chuyển cửa sổ |
| `Alt+1`..`Alt+4` | Chuyển workspace 1-4 |
| `Alt+Shift+1`..`4` | Move app sang workspace |
| `Alt+Tab` | Last workspace |
| `Alt+W` | Mở WezTerm |
| `Alt+O` | Mở Obsidian (nếu binding có) |
| `Alt+F` | Toggle fullscreen |

---

## 11. Television – Universal picker

```bash
tv                    # File picker default
tv git-log            # Git commit history
tv git-branch         # Git branches
tv docker-containers  # Docker
tv k8s-pods           # Kubernetes pods (qua kubectl)
tv gh-prs             # GitHub PRs
tv ssh-hosts          # SSH config hosts
tv tmux-sessions      # Tmux sessions
tv alias              # Xem và chạy aliases
```

Trong picker:

- `Ctrl+S` chuyển kênh (channel)
- `Tab` multi-select
- `Enter` chọn
- `Ctrl+J/K` di chuyển
- `Esc` thoát

---

## 12. LazyGit

Mở bằng `<Space>gg` trong nvim hoặc chạy `lazygit` ở terminal.

### Panel layout (số 1-5)

```
1. Status   – thay đổi unstaged/staged
2. Files    – chi tiết file
3. Branches – branches local + remote
4. Commits  – log
5. Stash    – stash
```

Bấm phím số để chuyển panel.

### Phím chính

| Phím | Tác dụng |
|------|----------|
| `Space` | Toggle stage file/hunk |
| `c` | Commit |
| `A` | Amend last commit |
| `P` | Push |
| `p` | Pull |
| `f` | Fetch |
| `s` | Stash unstaged |
| `b` | Checkout branch |
| `n` | New branch |
| `M` | Merge |
| `r` | Rebase |
| `R` | Reset |
| `e` | Edit file (mở nvim) |
| `<Enter>` | Vào chi tiết |
| `?` | Help |
| `q` | Thoát |

---

## 13. Workflow mẫu

### Bắt đầu project mới

```bash
# 1. Mở WezTerm (tự động attach session "main")

# 2. Tạo session mới cho project
Ctrl+A o
# → gõ tên "myapi" hoặc chọn thư mục qua zoxide → Enter

# 3. Trong session mới, mở nvim
cd ~/Workspace/myapi
v .

# 4. Trong nvim:
Space Space        # tìm file
Space /            # grep
Space gg           # lazygit

# 5. Cần shell bên cạnh nvim
Ctrl+A v           # split dọc trong tmux
# hoặc
Ctrl+A Ctrl+C      # window mới (tmux)
```

### Sửa bug nhanh

```bash
fv                 # fzf find file → nvim
# Trong nvim:
gd                 # go to definition của function lỗi
gr                 # tìm nơi sử dụng
*                  # tìm từ này trong file
ci"                # sửa nội dung trong dấu ""
:w                 # save
]d                 # diagnostic kế – kiểm tra hint LSP
Space ca           # code action – dùng khi có gợi ý fix
Space gg           # commit qua lazygit
```

### Hết ngày

```bash
Ctrl+A d           # detach session
# Đóng WezTerm
# Tắt máy

# Hôm sau:
# 1. Bật máy, mở WezTerm
# 2. Attach session sẵn có → nvim vẫn mở đúng file đang sửa, terminal vẫn ở cwd cũ
```

### Review PR

```bash
gco pr-branch
v .
Space gg
# Trong lazygit: bấm 4 (Commits) → chọn commit → Enter để xem diff
# Hoặc trong nvim: :Gitsigns toggle_deleted
# Hoặc shell: gh pr checkout 123 && gh pr diff
```

---

## 14. Tình huống thực tế khi viết code

Phần này là **toa thuốc** – từng đoạn mô tả một việc bạn làm trong ngày, kèm chuỗi phím chính xác. Đọc lướt, gặp tình huống thì áp dụng. Khi quen sẽ tự kết hợp.

### 14.1. Đổi tên một biến trong toàn bộ file

**Tình huống:** đang sửa hàm, đổi `userId` → `accountId` ở ~20 chỗ trong cùng file.

**Cách nhanh nhất (Vim "way"):**

```
/userId<Enter>          # tìm match đầu
cgn                     # change next match
accountId<Esc>          # gõ tên mới, thoát
.                       # lặp lại ở match kế (kiểm tra ngữ cảnh trước khi bấm .)
.                       # ...
```

**Hoặc force-replace toàn file:**

```
:%s/\<userId\>/accountId/gc
```

`\<...\>` = word boundary (không match `userIds`, `currentUserId`).
`gc` = global + confirm từng lần.

### 14.2. Rename biến/hàm an toàn theo LSP (toàn project)

**Tình huống:** đổi tên một hàm xuất khẩu, phải sửa cả nơi import.

- Đặt con trỏ lên tên hàm.
- `<Space>cr` → gõ tên mới → Enter.
- LSP đổi đúng symbol, **không đụng** vào chuỗi string trùng tên.

Khác `:%s` ở chỗ: LSP hiểu code, hiểu scope.

### 14.3. Thay đổi nội dung bên trong dấu ngoặc / chuỗi

**Tình huống:** `log.Info("user not found")` → đổi message.

```
fi"     # nhảy tới dấu " đầu
ci"     # change inside double-quote
# Insert mode → gõ message mới
<Esc>
```

Biến thể:
- `ci(` – sửa toàn bộ trong `(...)`
- `ci{` – sửa toàn bộ trong `{...}`
- `ci[` – sửa trong `[...]`
- `cit` – sửa nội dung trong HTML tag

### 14.4. Bao quanh một từ bằng dấu ngoặc / function call

**Tình huống:** có `name`, muốn thành `String(name)`.

```
ysiwf String<Enter>    # nvim-surround: surround word với function call
```

Hoặc đơn giản hơn:

```
ysiw)                  # bao word với (...)
I String<Esc>          # thêm "String" trước đoạn vừa surround
```

Đổi dấu ngoặc cũ sang khác: `'hello'` → `"hello"`:

```
cs'"                   # change surround ' → "
```

Xóa bao quanh: `(foo)` → `foo`:

```
ds(
```

### 14.5. Tìm và mở file trong khi viết code

**Tình huống:** đang viết `import ... from '../utils/format'`, cần mở file đó.

- Đặt con trỏ trên path → `gf` (go to file).
- Hoặc `<Space><Space>` → gõ `format` → Enter.
- Quay lại file cũ: `<Ctrl-o>` (jump back).

### 14.6. Nhảy giữa khai báo / cách dùng

| Vị trí | Phím | Tác dụng |
|--------|------|----------|
| Tên hàm/biến | `gd` | Đi đến nơi khai báo |
| Tên hàm | `gr` | Liệt kê tất cả nơi gọi (quickfix list) |
| Type/Interface | `gy` | Type definition |
| Bất cứ đâu | `<Ctrl-o>` / `<Ctrl-i>` | Lùi / tiến trong jumplist |

Mẹo: `gr` mở quickfix → `:cnext` / `:cprev` (hoặc `]q` / `[q`) để duyệt từng kết quả.

### 14.7. Sửa nhiều dòng giống nhau (block insert)

**Tình huống:** thêm `const ` vào đầu 10 dòng liên tiếp.

```
<Ctrl-V>      # visual block
10j           # mở rộng selection 10 dòng xuống
I             # insert ở đầu mỗi dòng
const         # gõ chữ
<Esc>         # áp dụng cho toàn bộ block
```

Xóa cột:

```
<Ctrl-V>
10j
$             # tới cuối mỗi dòng
d             # xóa
```

### 14.8. Sửa các dòng có pattern bằng macro

**Tình huống:** có 50 dòng `{"key": "value"}`, muốn đổi thành `key = value`.

```
qq                          # bắt đầu ghi macro vào register q
0                           # về đầu dòng
f"                          # nhảy tới " đầu
ci"<Esc>                    # xóa key cũ... thực ra đơn giản hơn:
                            # ví dụ thực tế:
:s/"\(\w*\)": "\(\w*\)"/\1 = \2/<Enter>
j                           # xuống dòng kế
q                           # ngưng ghi
50@q                        # phát lại macro 50 lần
```

Khi macro ổn, chỉnh số lần phát theo nhu cầu.

### 14.9. Comment một block code nhanh

```
gcc           # comment 1 dòng
5gcc          # comment 5 dòng từ dòng hiện tại
gcap          # comment cả paragraph
V}gc          # visual line tới đoạn trắng → comment
```

Bỏ comment: lặp lại phím trên.

### 14.10. Xem định nghĩa mà không rời file

**Tình huống:** đang viết, muốn liếc qua signature của hàm `parseConfig`.

```
gd                  # go to definition (mở file kia)
<Ctrl-o>            # quay về file cũ ngay sau khi xem
```

Hoặc dùng hover documentation **không cần nhảy**:

```
K                   # hover doc/signature
K                   # bấm thêm để vào hover window và scroll
```

### 14.11. Thêm import sau khi gõ tên hàm

**Tình huống:** gõ `formatDate(...)` nhưng chưa import.

- LSP báo lỗi underline.
- `<Space>ca` → chọn "Add import" / "Auto import" / "Import …".
- Hoặc `]d` để nhảy tới chỗ báo lỗi tiếp theo nếu cách xa.

### 14.12. Format file đang viết

```
<Space>cf          # format file qua conform.nvim
gg=G               # auto-indent cả file (built-in Vim, không format đẹp như Prettier)
```

Format từng phần:

```
=ip                # indent paragraph
=i{                # indent inside block
```

### 14.13. Mở terminal cạnh code để test

**Cách 1 (tmux – tốt nhất):**

```
Ctrl+A v           # chia pane dọc, có shell
# Chạy test, đọc log
Ctrl+A h           # quay lại pane nvim
```

**Cách 2 (terminal trong nvim):**

```
<Space>tt          # toggleterm – terminal nổi
<Esc><Esc>         # thoát terminal mode → normal mode trong terminal
i                  # quay lại insert để gõ tiếp
```

Mình khuyên dùng tmux pane vì sống ngoài nvim, không bị mất khi `:qa`.

### 14.14. Chạy test cho file đang viết

**Setup TDD 3 pane:**

```
# Pane 1 (left): nvim
# Pane 2 (top right): chạy test watcher
ctrl+a v           # chia dọc
ctrl+a s           # pane 2 chia ngang
# Trong pane top-right:
npm test -- --watch
# Pane 3 (bottom right): shell rảnh để chạy lệnh ad-hoc
```

Sửa code ở pane nvim, save → pane test tự re-run, đọc kết quả ngay cạnh.

### 14.15. Sửa file config / JSON nhanh

**Tình huống:** sửa `package.json`, đổi version "1.2.3" → "1.3.0".

```
/"version"<Enter>
f"                  # nhảy tới " đầu của value
ci"1.3.0<Esc>
:w
```

**Sửa giá trị key bất kỳ trong JSON:**

```
/"timeout"<Enter>
f:                  # tới dấu :
w                   # tới giá trị
ciw3000<Esc>
```

### 14.16. Edit nhiều file song song

**Cách 1 – split:**

```
:vsp ../other-file.go     # mở file kia bên cạnh
<Ctrl-h> / <Ctrl-l>       # nhảy giữa 2 panes
```

**Cách 2 – buffer (không chia split):**

```
<Space><Space>            # tìm file mới → mở
<Space>,                  # buffer picker (giống Cmd+Tab)
<S-h> <S-l>               # buffer trước / kế (LazyVim)
:bd                       # đóng buffer hiện tại
```

### 14.17. Đặt "bookmark" để nhảy lại nhanh

**Built-in marks:**

```
ma                        # mark vị trí hiện tại là 'a' (local file)
mA                        # mark global (nhảy giữa file)
'a                        # nhảy về mark a
``                        # nhảy về vị trí trước khi nhảy
:marks                    # xem tất cả mark
```

**Harpoon (cài thêm):** quản lý 4-5 file "hot" như iOS dock – tham khảo plugin `ThePrimeagen/harpoon`.

### 14.18. Lùi lại trạng thái cũ của file

```
u                         # undo
<Ctrl-r>                  # redo
:earlier 5m               # quay về trạng thái 5 phút trước
:later 5m                 # ngược lại
<Space>uu                 # mở undotree (visual graph)
```

Vim lưu undo tree, không phải stack — nhánh undo cũ không mất.

### 14.19. Tìm và edit theo regex toàn file

**Tình huống:** đổi tất cả `console.log(...)` thành `logger.debug(...)`.

```
:%s/console\.log(\(.*\))/logger.debug(\1)/g
```

`\(...\)` capture group, `\1` reference. Bấm `c` cuối → confirm từng cái.

### 14.20. Tìm và replace toàn project

```
:Spectre                  # mở UI search-and-replace project-wide (nếu cài)
```

Hoặc workflow telescope + quickfix:

```
<Space>/                  # live grep
<Ctrl-q>                  # đẩy tất cả match vào quickfix list
:cdo s/foo/bar/gc | update    # áp dụng :s lên từng item quickfix
```

### 14.21. Sửa nhanh lỗi typo trong tên biến vừa gõ

**Tình huống:** vừa gõ `usreName` mà ý là `userName`.

Trong Insert mode:

```
<Ctrl-w>                  # xóa từ vừa gõ
userName                  # gõ lại đúng
```

Trong Normal:

```
b                         # về đầu từ
ciw userName<Esc>
```

### 14.22. Mở file vừa thấy trong stack trace / log

Log có `at internal/auth/service.go:42`:

- Trong terminal: `Cmd+Click` lên path (WezTerm hyperlink).
- Trong nvim: `gF` (go to file with line) — nhảy đúng file đúng dòng.

### 14.23. Đóng tất cả buffer trừ buffer hiện tại

```
:%bd|e#|bd#
```

Hoặc dùng lệnh sẵn của LazyVim:

```
<Space>bo                 # buffer-only (close others)
```

### 14.24. Soạn commit message dài

**Tình huống:** `<Space>gg` → soạn commit, cần nhiều dòng + xuống dòng đẹp.

Trong LazyGit, bấm `c` mở editor. Editor sẽ là nvim (đã set `EDITOR=nvim`). Soạn xong `:wq`.

### 14.25. Xem diff trước khi commit

```
<Space>gg                 # lazygit
# Panel 1 → trỏ vào file → Enter
# Xem hunk, Space để stage từng hunk → c để commit
```

Hoặc trong nvim:

```
<Space>ghd                # diffview cho file hiện tại
:DiffviewOpen             # diff toàn workspace
:DiffviewClose            # đóng
```

### 14.26. So sánh với branch main

```bash
# Shell:
git diff main...HEAD --stat
gh pr diff                # nếu đang trên PR branch

# Trong nvim:
:DiffviewOpen main...HEAD
```

### 14.27. Quay lại session đang dở khi máy reboot

```bash
# Mở WezTerm
# tmux-continuum tự attach session "main"
# nvim đã được tmux-resurrect khôi phục → mở đúng file đang sửa hôm qua
```

Nếu không tự khôi phục: `Ctrl+A Ctrl+R` để restore thủ công.

### 14.28. Làm việc với nhiều repo cùng lúc

```bash
Ctrl+A o                  # sessionx
# Chọn repo A → tạo session A
# Detach: Ctrl+A d
# Chọn repo B → tạo session B
# Switch nhanh: Ctrl+A o lần nữa
```

Mỗi session độc lập – nvim, lazygit, log đều riêng.

### 14.29. Đóng file mà không thoát nvim

Thói quen VSCode: `Ctrl+W`. Trong nvim:

```
<Space>bd                 # close buffer (giữ window)
:bd                       # tương đương
```

`:q` đóng cả split – khác `:bd`. Khi chỉ có một split, `:q` cũng đóng nvim.

### 14.30. Xem hàm/biến này đến từ đâu (import path)

Đặt con trỏ trên symbol → `K` (hover) – LSP hiển thị doc + full qualified name + path.
Hoặc `gd` để nhảy thẳng đến file định nghĩa.

### 14.31. Edit chuỗi dài có nhiều dấu nháy

**Tình huống:** chuỗi SQL `"SELECT * FROM users WHERE id = '" + id + "'"`, muốn ghép lại.

```
V                         # visual line
:s/" + /'/g               # replace cục bộ trong selection
```

Hoặc bao quanh selection bằng template literal:

```
S`                        # surround visual với backtick
```

### 14.32. Định vị "tôi đang ở đâu" trong cây code

```
<Space>cs                 # symbols outline – cây hàm/class của file
:Outline                  # (nếu cài aerial.nvim)
<Space>e                  # neo-tree highlight file hiện tại
```

### 14.33. Đọc log nhiều dòng nhanh

Trong tmux pane log:

```
Ctrl+A [                  # copy mode
?ERROR<Enter>             # tìm "ERROR" ngược về phía trên
n / N                     # kết quả kế / trước
q                         # thoát copy mode
```

Mouse mode đã bật → cũng có thể scroll bằng wheel.

### 14.34. Đổi case nhanh

| Tình huống | Phím |
|------------|------|
| `userName` → `UserName` | `~` trên chữ `u` (toggle case 1 ký tự) |
| Cả từ thành UPPERCASE | `gUiw` |
| Cả từ thành lowercase | `guiw` |
| Cả dòng UPPERCASE | `gUU` |
| Toggle case cả vùng | Visual → `~` |

### 14.35. Insert nhanh "use strict" / boilerplate đầu file

```
gg                        # về đầu file
O                         # tạo dòng mới phía trên (Insert mode)
"use strict";<Esc>
```

Nếu là boilerplate dài → dùng snippet (LuaSnip). Trong LazyVim gõ trigger (vd: `clog` cho `console.log`) rồi `<Tab>`.

### 14.36. Xóa tất cả dòng trắng thừa trong file

```
:g/^$/d
```

`:g/pattern/cmd` = áp dụng `cmd` cho mọi dòng match `pattern`. Ở đây xóa các dòng rỗng.

### 14.37. Sửa indent của block code

**Tăng indent block trong `{...}`:**

```
>i{                       # indent inside braces, tăng 1 cấp
=i{                       # auto-indent inside braces theo formatter
```

Visual mode:

```
V}                        # chọn tới dấu trắng cuối block
>                         # tăng indent
gv                        # reselect (visual cũ)
>                         # tăng tiếp
```

### 14.38. Quick chạy lệnh shell rồi paste output vào file

**Tình huống:** muốn paste `git log --oneline -5` vào commit notes.

```
:r !git log --oneline -5
```

Output chèn ngay sau dòng hiện tại.

### 14.39. Diff giữa 2 file mở

```
:vsp file2
:windo diffthis           # bật diff cho cả 2 split
:windo diffoff            # tắt
```

### 14.40. "Tôi sửa nhầm file khác" – chỉ undo file hiện tại

`u` chỉ undo buffer hiện tại. Nếu lỡ save và muốn quay về phiên bản trước:

```
:earlier 1h               # về 1 giờ trước
:later 30m                # tiến 30 phút
<Space>uu                 # undotree để xem nhánh
```

Nếu đã commit thì dùng git: `:Gitsigns reset_buffer` hoặc `git checkout HEAD -- <file>`.

---

## 15. Troubleshooting – "Stuck in vim"

### Không biết mình đang ở đâu

Bấm `Esc` 2-3 lần. Nếu vẫn lạ, bấm `Ctrl+C`.
Kiểm tra góc dưới của nvim – sẽ ghi mode (`-- INSERT --`, `-- VISUAL --`...).

### Lỡ bấm dấu ":" không thoát được

Đây là Command mode. Bấm `Esc`.

### Không save được, báo "no write since last change"

```
:wq         -- save & quit
:q!         -- quit không save
```

### File không save báo "E37: No write since last change"

Có thể file `readonly`. Kiểm tra `:set ro?`. Thay đổi: `:set noro`.
Hoặc save force: `:w!`.

### "Found a swap file" khi mở file

Đã có session khác mở file (hoặc crash trước). Chọn:
- `O` – read-only mở
- `R` – recover swap (lấy dữ liệu chưa save)
- `D` – delete swap (nếu chắc chắn không cần)

### Bấm phím không phản ứng trong tmux

Có thể do escape time. Trong config đã đặt `set -g escape-time 0`. Nếu vẫn lỗi, reload: `Ctrl+A R`.

### Plugin không load sau khi sửa tmux.conf

```
Ctrl+A R       # reload config
Ctrl+A I       # TPM install
```

### Status bar tmux về màu xanh lá mặc định

Plugin catppuccin chưa chạy. Reload + install:

```bash
tmux source-file ~/.config/tmux/tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
```

### Scroll wheel trong claude code / TUI app gửi mũi tên (không cuộn)

Mouse mode chưa bật trong tmux. Đã được set sẵn (`set -g mouse on`). Nếu vẫn gặp:

```
:set -g mouse on          # trong command mode tmux
Ctrl+A R                   # reload
```

### Nvim mở chậm

```
:Lazy profile      -- xem plugin nào load lâu
:checkhealth       -- chẩn đoán tổng thể
```

### LSP không nhận filetype

```
:LspInfo                 -- xem LSP đã attach chưa
:Mason                   -- cài LSP cho ngôn ngữ
:checkhealth lsp
```

### Format không chạy khi save

```
:ConformInfo             -- xem formatter cấu hình
:checkhealth conform
```

### Reset toàn bộ plugin

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
nvim                     # LazyVim sẽ cài lại
```

---

## 16. Lộ trình học 30 ngày

### Tuần 1 – Sinh tồn

Mục tiêu: **mở file, sửa, save, thoát** không panic.

- Học `i a o`, `Esc`, `:w`, `:q`, `:wq`, `:q!`.
- Di chuyển: `h j k l`, `w b`, `gg G`, `0 $`.
- Xóa: `x`, `dd`. Undo: `u`. Paste: `p`.
- Trong tmux: chỉ cần `Ctrl+A o` (session), `Ctrl+A d` (detach), `Ctrl+A 1-9` (window).
- Trong LazyVim: chỉ cần `<Space><Space>`, `<Space>/`, `<Space>e`, `<Space>gg`.

> Mục tiêu tuần 1: **không quay về VSCode** để sửa 1 file.

### Tuần 2 – Tăng tốc

- Học verb + text object: `ciw`, `da(`, `yi"`, `vip`.
- LSP: `gd`, `gr`, `K`, `<Space>ca`, `<Space>cr`.
- tmux pane: `Ctrl+A v`, `Ctrl+A s`, `Ctrl+A z`.
- LazyGit hoàn chỉnh.
- Đọc section 14, áp dụng 3 tình huống mỗi ngày.

### Tuần 3 – Hiệu quả

- `f t F T ; ,` – di chuyển ngang dòng nhanh.
- `*` `#` `n` `N` `/` `?` – tìm trong file.
- `.` (dot repeat) – làm bạn yêu Vim.
- Macro `q@`.
- Visual block `Ctrl+V`.
- Snippets, autocomplete fluent.
- Surround: `ys`, `cs`, `ds`.

### Tuần 4 – Master

- Cấu hình `lua/plugins/*.lua` riêng.
- Thêm LSP cho ngôn ngữ chính.
- Dùng `<Space>` + which-key, không nhớ keymap.
- Multi-buffer workflow: harpoon hoặc bookmark.
- Treesitter textobjects: `if af ic ac`.
- Cấu hình nvim-dap để debug.

> Sau 1 tháng: bạn sẽ tự thấy không muốn về VSCode/PhpStorm.

---

## Tra cứu nhanh – "Tôi muốn..."

| Tôi muốn... | Phím |
|-------------|------|
| Mở một file | `<Space><Space>` |
| Tìm text trong project | `<Space>/` |
| Mở terminal bên cạnh code | `Ctrl+A v` |
| Tạo project workspace mới | `Ctrl+A o` → tên mới |
| Quay lại project hôm qua | `Ctrl+A o` → chọn |
| Commit code | `<Space>gg` → Space stage → `c` |
| Rename hàm/biến | `<Space>cr` |
| Xem documentation | `K` |
| Tìm nơi function được gọi | `gr` |
| Format file | `<Space>cf` |
| Toggle comment | `gcc` |
| Quit nvim | `:qa` |
| Detach tmux | `Ctrl+A d` |
| Đổi nội dung trong dấu `"..."` | `ci"` |
| Bao một từ bằng `"..."` | `ysiw"` |
| Lặp lại lệnh sửa cuối | `.` |
| Đổi 1 biến nhiều chỗ trong file | `*` → `cgn` → mới → `.` lặp |
| Đổi 1 biến cả project an toàn | `<Space>cr` (LSP rename) |
| Nhảy về file vừa rời | `<Ctrl-o>` |
| Mở file dưới con trỏ | `gf` |

---

## Reload & cập nhật config

```bash
# Tmux
Ctrl+A R                # trong tmux

# Nvim
:Lazy sync              # cập nhật plugin
:Mason                  # cập nhật LSP
:checkhealth            # chẩn đoán

# Zsh
exec zsh                # reload shell
source ~/.zshrc         # source lại

# WezTerm
# Tự động reload khi save wezterm.lua
```

---

> **Lời khuyên cuối:**
> Vim/tmux không yêu cầu bạn ghi nhớ hết. **Bấm `<Space>` cho which-key, bấm `:Telescope keymaps` để tìm phím.**
> Đầu tư 30 phút mỗi ngày trong 1 tháng, bạn sẽ quay lại VSCode chỉ để... copy file.
