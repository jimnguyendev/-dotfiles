# Huong Dan Su Dung - Tu VSCode Sang Terminal Workflow

## Tong Quan Setup

```
WezTerm (terminal, tu dong khoi dong tmux)
  └── tmux (session/window manager)
       ├── Window 1: nvim (code editor)
       ├── Window 2: shell (chay lenh)
       └── Window 3: lazygit (git TUI)
```

3 lop chinh:
- **WezTerm** = Terminal emulator. Mo len la tu dong vao tmux.
- **tmux** = Quan ly session/window. Co the detach va attach lai, session khong mat.
- **Neovim (LazyVim)** = Code editor. Thay the VSCode.

---

## 1. WEZTERM

**Thiet lap hien tai:**
- Font: JetBrainsMono Nerd Font 13pt, line-height 1.3
- Theme: Catppuccin Mocha
- Opacity 0.85 + blur 30 (trong suot + mo nen)
- Cua so khoi dong: 200 cot x 55 dong
- **Tu dong vao tmux session "main"** khi mo

**Phim tat:**
| Phim | Chuc nang |
|------|-----------|
| `Ctrl+Q` | Toggle fullscreen |
| `Ctrl+'` | Xoa scrollback |
| `Ctrl+Click` | Mo link |

---

## 2. TMUX - Quan ly Session & Window

Mo WezTerm la ban dang trong tmux session "main" san roi. Khong can `tmux` lai.

### Prefix = Ctrl+A
Tat ca phim tat tmux bat dau bang **Ctrl+A** roi den phim tiep theo.

### Windows (giong tabs cua VSCode)

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A Ctrl+C` | Tao window moi (mo o $HOME) |
| `Ctrl+A H` | Window truoc |
| `Ctrl+A L` | Window sau |
| `Ctrl+A Ctrl+A` | Chuyen qua lai 2 window cuoi |
| `Ctrl+A 1-9` | Nhay den window so 1-9 |
| `Ctrl+A r` | Doi ten window |
| `Ctrl+A w` | Liet ke tat ca window |

### Panes (chia cua so)

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A v` | Chia doc (canh ben) |
| `Ctrl+A s` | Chia ngang (tren/duoi) |
| `Ctrl+A h/j/k/l` | Di chuyen giua panes |
| `Ctrl+A z` | Zoom pane (phong to/thu nho) |
| `Ctrl+A c` | Dong pane hien tai |
| `Ctrl+A x` | Hoan vi pane |
| `Ctrl+A , .` | Resize trai/phai |
| `Ctrl+A - =` | Resize xuong/len |

### Sessions

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A o` | Session picker (sessionx + zoxide) - chon hoac tao session |
| `Ctrl+A S` | Chon session (built-in) |
| `Ctrl+A p` | Floating terminal (floax) |
| `Ctrl+A d` | Detach (thoat ma giu session song) |

### Copy mode (cuon va copy text)

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A [` | Vao copy mode |
| `h/j/k/l` | Di chuyen |
| `v` | Bat dau chon |
| `y` | Copy vao clipboard |
| `q` | Thoat copy mode |

### Khac

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A K` | Clear screen |
| `Ctrl+A R` | Reload config tmux |

---

## 3. NEOVIM (LazyVim)

### Leader = Space

**Di chuyen co ban (Vim motions):**
| Phim | Chuc nang |
|------|-----------|
| `h/j/k/l` | Trai/Xuong/Len/Phai |
| `w/b` | Nhay theo tu (tien/lui) |
| `gg/G` | Dau file / Cuoi file |
| `0/$` | Dau dong / Cuoi dong |
| `Ctrl+d/u` | Cuon nua trang |
| `Esc` | Thoat insert mode |

**File & Navigation:**
| Phim | Chuc nang |
|------|-----------|
| `Space Space` | Tim file (Ctrl+P trong VSCode) |
| `Space /` | Grep text trong project (Ctrl+Shift+F) |
| `Space e` | File explorer (neo-tree) |
| `Space ,` | Chuyen buffer |
| `Space f r` | File gan day |

**Code:**
| Phim | Chuc nang |
|------|-----------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `Space c a` | Code actions |
| `Space c r` | Rename symbol |
| `Space c f` | Format file |

**Git:**
| Phim | Chuc nang |
|------|-----------|
| `Space g g` | LazyGit (full Git TUI) |
| `Space g b` | Git blame dong hien tai |

**Windows trong nvim:**
| Phim | Chuc nang |
|------|-----------|
| `Space w v` | Split doc |
| `Space w s` | Split ngang |
| `Ctrl+h/j/k/l` | Di chuyen giua splits |

---

## 4. ZSH ALIASES

**Git:**
```bash
gst              # git status
gc "msg"         # git commit -m
gp               # git push origin HEAD
gpu main         # git pull origin main
glog             # git log dep
gco branch       # git checkout
```

**Docker:**
```bash
dco up -d        # docker compose up
dps              # docker ps
dx container     # docker exec -it
```

**Kubernetes:**
```bash
k get pods       # kubectl
kg pods          # kubectl get
kl pod           # kubectl logs -f
```

**Files & Navigation:**
```bash
l                # eza voi icons + git status
lt               # eza tree view
cat file         # bat (syntax highlight)
v file           # nvim
cx folder        # cd + list files
fcd              # cd bang fzf
fv               # tim file bang fzf roi mo nvim
```

**Autosuggestions (chu xam mo phia sau):**
- `Ctrl+E` - Chap nhan goi y (chi dien, chua chay)
- `Ctrl+W` - Chap nhan goi y va chay luon

---

## 5. AEROSPACE - Tiling Window Manager

Mo AeroSpace.app tu Applications, cho phep Accessibility.

| Phim | Chuc nang |
|------|-----------|
| `Alt+H/J/K/L` | Focus cua so |
| `Alt+Shift+H/J/K/L` | Di chuyen cua so |
| `Alt+1/2/3/4` | Chuyen workspace |
| `Alt+Tab` | Workspace cuoi |
| `Alt+W` | Mo WezTerm |
| `Alt+O` | Mo Obsidian |

---

## 6. TELEVISION - Universal Picker

```bash
tv                    # File picker
tv git-log            # Git commits
tv docker-containers  # Docker
tv k8s-pods           # Kubernetes pods
tv gh-prs             # GitHub PRs
tv ssh-hosts          # SSH hosts
tv tmux-sessions      # Tmux sessions
tv alias              # Xem aliases
```

Trong picker: `Ctrl+S` chuyen kenh, `Tab` multi-select, `Enter` chon.

---

## WORKFLOW MAU

### Mo project moi
```bash
# 1. Mo WezTerm (tu dong vao tmux "main")

# 2. Mo session moi cho project
Ctrl+A o           # Session picker, chon hoac tao "myproject"

# 3. Trong session, mo nvim
cd ~/Workspace/myproject
v .                # alias cua nvim

# 4. Trong nvim:
Space Space        # Tim file
Space /            # Grep text
Space g g          # LazyGit cho git operations

# 5. Can chay terminal song song?
Ctrl+A v           # Split pane ben canh nvim
# hoac
Ctrl+A Ctrl+C      # Tao window moi

# 6. Het ngay
Ctrl+A d           # Detach, dong WezTerm
# Hom sau mo WezTerm len, "main" session van con
# Bam Ctrl+A o de quay ve "myproject"
```

### Tim va sua file nhanh
```bash
fv                 # Tim file bang fzf -> Enter -> mo nvim
```

### Review git changes
```bash
v .                # Mo nvim
Space g g          # LazyGit
# Trong LazyGit: arrow keys, Space toggle, c commit, P push
q                  # Thoat
```

---

## TIPS CHO NGUOI MOI TU VSCODE

1. **Bat dau nho**: Chi can hoc 5 phim - `Space Space` (tim file), `Space /` (grep), `Space e` (explorer), `Space g g` (git), `Esc` (thoat insert). Khac se den tu nhien.

2. **Bi ket trong vim?** Bam `Esc` nhieu lan, roi `:q!` Enter de thoat.

3. **Which-key la ban tot**: Bam `Space` trong nvim va doi - menu se hien tat ca phim co the bam tiep.

4. **tmux session = workspace cua VSCode**: Moi project 1 session. `Ctrl+A o` de chuyen.

5. **LazyGit thay Source Control**: Khong can vao VSCode de commit nua.

6. **Khong can luu thu cong**: LazyVim auto-save khi switch buffer.

7. **Tat ca phim Ctrl+A trong tmux** la *prefix*, nghia la bam Ctrl+A, **tha ra**, roi bam phim ke tiep. Khong giu Ctrl khi bam phim thu hai.
