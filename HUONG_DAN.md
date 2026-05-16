# Huong Dan Chuyen Tu VSCode Sang Terminal Workflow

## Tong Quan Setup

Setup nay dua tren 3 lop chinh:
- **WezTerm** = Terminal emulator (thay iTerm/Terminal.app)
- **tmux** = Quan ly nhieu cua so/session trong 1 terminal
- **Neovim (LazyVim)** = Code editor (thay VSCode)

```
WezTerm (terminal)
  └── tmux (session/window manager)
       ├── Window 1: nvim (code editor)
       ├── Window 2: shell (terminal commands)
       └── Window 3: lazygit (git TUI)
```

---

## 1. WEZTERM - Terminal Emulator

Khoi dong WezTerm, ban se thay giao dien toi gian (khong tab bar, khong title bar).

**Phim tat:**
| Phim | Chuc nang |
|------|-----------|
| `Ctrl+Q` | Toggle fullscreen |
| `Ctrl+'` | Xoa scrollback (clear man hinh) |
| `Ctrl+Click` | Mo link duoi con tro |

---

## 2. TMUX - Session & Window Manager

Tmux la lop quan trong nhat. No cho phep ban co nhieu "cua so" trong 1 terminal,
va giu session song khi ban dong terminal.

### Bat dau
```bash
tmux                    # Tao session moi
tmux new -s ten-session # Tao session co ten
tmux a                  # Attach lai session cu
```

### Prefix Key = Ctrl+A
Tat ca phim tat tmux bat dau bang **Ctrl+A** (bam Ctrl+A truoc, roi bam phim tiep theo).

### Phim tat thuong dung

**Windows (tabs):**
| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A c` | Tao window moi (nhu mo tab moi) |
| `Ctrl+A H` | Window truoc (trai) |
| `Ctrl+A L` | Window sau (phai) |
| `Ctrl+A 1-9` | Nhay den window theo so |
| `Ctrl+A r` | Doi ten window |
| `Ctrl+A ^A` | Chuyen qua lai 2 window cuoi |

**Panes (chia man hinh):**
| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A v` | Chia doc (vertical split) |
| `Ctrl+A s` | Chia ngang (horizontal split) |
| `Ctrl+A h/j/k/l` | Di chuyen giua cac pane (vim style) |
| `Ctrl+A z` | Zoom pane (phong to/thu nho) |
| `Ctrl+A c` | Dong pane hien tai |

**Sessions:**
| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A o` | Mo sessionx (chon/tao session bang fzf) |
| `Ctrl+A S` | Chon session |
| `Ctrl+A d` | Detach (thoat ma khong mat session) |
| `Ctrl+A p` | Mo floax (floating terminal) |

**Khac:**
| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A R` | Reload config tmux |
| `Ctrl+A K` | Clear man hinh |

### Plugins da cai
- **tmux-resurrect + continuum**: Tu dong luu/phuc hoi session khi restart
- **tmux-sessionx**: Chon session bang fzf (Ctrl+A o)
- **tmux-floax**: Floating terminal (Ctrl+A p)
- **tmux-yank**: Copy vao clipboard he thong
- **tmux-thumbs**: Nhan dien va copy text (URL, path, hash...)
- **tmux-fzf-url**: Tim va mo URL trong scrollback
- **catppuccin-tmux**: Theme Catppuccin Mocha

---

## 3. NEOVIM (LazyVim) - Code Editor

LazyVim la Neovim distribution co san plugins, keymaps, va LSP.
No thay the duoc VSCode cho hau het tac vu.

### Khoi dong
```bash
nvim .           # Mo thu muc hien tai
nvim file.go     # Mo file cu the
v .              # Alias: nvim (sau khi source .zshrc)
```

### Leader Key = Space
Hau het phim tat bat dau bang **Space** (leader key). Bam Space va cho which-key hien thi.

### Phim tat thiet yeu

**Di chuyen co ban (Vim motions):**
| Phim | Chuc nang |
|------|-----------|
| `h/j/k/l` | Trai/Xuong/Len/Phai |
| `w/b` | Nhay theo tung tu (tien/lui) |
| `gg/G` | Dau file / Cuoi file |
| `0/$` | Dau dong / Cuoi dong |
| `Ctrl+d/u` | Cuon nua trang xuong/len |
| `jj` hoac `jk` | Thoat Insert mode (thay Esc) |

**File & Navigation:**
| Phim | Chuc nang |
|------|-----------|
| `Space Space` | Tim file (nhu Ctrl+P trong VSCode) |
| `Space /` | Tim text trong project (nhu Ctrl+Shift+F) |
| `Space e` | Mo file explorer (neo-tree) |
| `Space ,` | Chuyen buffer (nhu chuyen tab) |
| `Space f f` | Tim file |
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

**Git (LazyGit):**
| Phim | Chuc nang |
|------|-----------|
| `Space g g` | Mo LazyGit (full Git TUI) |
| `Space g b` | Git blame dong hien tai |

**Windows & Buffers:**
| Phim | Chuc nang |
|------|-----------|
| `Space w v` | Split doc |
| `Space w s` | Split ngang |
| `Ctrl+h/j/k/l` | Di chuyen giua split |
| `Space b d` | Dong buffer hien tai |

**Search & Replace:**
| Phim | Chuc nang |
|------|-----------|
| `/` | Tim trong file |
| `n/N` | Ket qua tiep/truoc |
| `Space s r` | Search & Replace (grug-far) |

**Harpoon (Bookmarks nhanh):**
| Phim | Chuc nang |
|------|-----------|
| `Space h a` | Them file vao harpoon |
| `Space h h` | Mo harpoon menu |
| `Space 1-4` | Nhay den file 1-4 |

### Extras da bat
- **Go**: LSP gopls, debug, test runner
- **TypeScript**: LSP, auto-import
- **Docker**: Dockerfile syntax
- **Terraform**: HCL syntax + LSP
- **Markdown**: Preview
- **Harpoon2**: Quick file switching
- **mini-files**: File browser
- **mini-surround**: Them/xoa/doi dau ngoac
- **DAP**: Debug Adapter Protocol

---

## 4. ZSH ALIASES - Phim tat Terminal

Repo co san nhieu alias huu ich. Them dong nay vao cuoi ~/.zshrc cua ban:
```bash
source ~/.config/zshrc/.zshrc
```

**Luu y**: Mot so dong trong file nay can tool rieng (kubectl, aws_completer).
Neu chua cai, comment chung di de tranh loi. Cu the:
```bash
# Comment dong nay neu chua cai kubectl:
# source <(kubectl completion zsh)
# Comment dong nay neu chua cai aws cli:
# complete -C '/usr/local/bin/aws_completer' aws
```

### Alias hay nhat

**Navigation thong minh:**
```bash
cx folder    # cd vao folder + tu dong list files
fcd          # cd bang fzf (chon folder interactive)
f            # Tim file bang fzf, copy path vao clipboard
fv           # Tim file bang fzf roi mo bang nvim
```

**Git nhanh:**
```bash
gst          # git status
gc "msg"     # git commit -m "msg"
gp           # git push origin HEAD
gpu main     # git pull origin main
glog         # git log dep
gdiff        # git diff
```

**File listing (eza):**
```bash
l            # List file dep voi icons + git status
lt           # Tree view 2 cap
cat file     # Hien file voi syntax highlight (bat)
```

**Docker:**
```bash
dco up -d    # docker compose up -d
dps          # docker ps
dx container # docker exec -it container
```

---

## 5. AEROSPACE - Window Manager

AeroSpace quan ly cua so bang phim tat, tu dong sap xep.

**Khoi dong:** Mo AeroSpace.app tu Applications, cho phep Accessibility.

**Phim tat co ban:**
| Phim | Chuc nang |
|------|-----------|
| `Alt+H/J/K/L` | Focus cua so trai/duoi/tren/phai |
| `Alt+Shift+H/J/K/L` | Di chuyen cua so |
| `Alt+1/2/3/4` | Chuyen workspace |
| `Alt+Shift+1/2/3/4` | Chuyen cua so sang workspace khac |
| `Alt+Tab` | Chuyen qua lai 2 workspace |
| `Alt+Ctrl+F` | Toggle floating/tiling |
| `Alt+W` | Mo WezTerm |

---

## 6. TELEVISION - Universal Picker

Television la tool tim kiem da nang. Chay bang lenh `tv`.

```bash
tv                    # Mo picker mac dinh (files)
tv git-log            # Tim git commits
tv docker-containers  # Quan ly Docker containers
tv gh-prs             # GitHub Pull Requests
tv ssh-hosts          # Chon SSH host
tv tmux-sessions      # Chon tmux session
tv alias              # Xem tat ca alias
tv brew-packages      # Quan ly brew packages
```

Bam `Ctrl+S` trong tv de chuyen kenh. `Tab` de multi-select. `Enter` de chon.

---

## 7. STARSHIP - Shell Prompt

Prompt da duoc cau hinh san: chi hien thu muc + git branch.
Thong tin khac (aws, k8s, go version) hien ben phai.

---

## 8. ATUIN - Shell History

Thay the `Ctrl+R` (reverse search) bang fuzzy search thong minh.

```bash
atuin register   # Dang ky de sync history giua cac may (tuy chon)
atuin login      # Dang nhap
```

Bam `Ctrl+R` hoac `Up Arrow` de tim lenh cu.

---

## WORKFLOW MAU: Mo project va code

```bash
# 1. Mo WezTerm

# 2. Tao tmux session cho project
tmux new -s myproject

# 3. Mo nvim
cd ~/Workspace/myproject
v .

# 4. Trong nvim:
#    Space Space -> tim file
#    Space / -> tim text
#    Space g g -> mo lazygit

# 5. Can terminal? Bam Ctrl+A v de split, hoac Ctrl+A ^C de tao window moi

# 6. Xong viec? Ctrl+A d de detach. Session van song.
#    Ngay mai: tmux a -t myproject
```

---

## TIPS CHO NGUOI MOI TU VSCODE

1. **Dung co hoc tat ca cung luc.** Bat dau voi: vim motions co ban + Space Space (tim file) + Space / (tim text) + Space g g (git). Con lai se den tu nhien.

2. **jj de thoat Insert mode** - day la thoi quen quan trong nhat can xay dung.

3. **Which-key la ban tot nhat** - bam Space va doi, no se chi ban tat ca phim tat co the.

4. **LazyGit thay the Source Control tab** cua VSCode. Bam Space g g trong nvim.

5. **tmux session = workspace cua VSCode.** Moi project 1 session, chuyen bang Ctrl+A o.

6. **Dung hoang khi bi ket trong Vim** - bam Esc nhieu lan, roi :q! de thoat.
