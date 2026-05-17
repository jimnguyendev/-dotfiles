# Huong Dan Su Dung - Tu VSCode / PhpStorm Sang Terminal Workflow

> Tai lieu nay viet cho nguoi quen VSCode hoac PhpStorm muon chuyen sang stack
> **WezTerm + tmux + LazyVim**. Khong yeu cau biet Vim truoc.
> Doc tuan tu lan dau, sau do dung phan "Tra cuu nhanh" o cuoi.

---

## Muc luc

1. [Tong quan kien truc](#1-tong-quan-kien-truc)
2. [Cau noi tu duy tu VSCode / PhpStorm](#2-cau-noi-tu-duy-tu-vscode--phpstorm)
3. [Triet ly Vim - Modal editing](#3-triet-ly-vim---modal-editing)
4. [WezTerm](#4-wezterm)
5. [tmux - Quan ly session, window, pane](#5-tmux---quan-ly-session-window-pane)
6. [Neovim / LazyVim chi tiet](#6-neovim--lazyvim-chi-tiet)
7. [Cau noi PhpStorm -> LazyVim](#7-cau-noi-phpstorm---lazyvim)
8. [Cau noi VSCode -> LazyVim](#8-cau-noi-vscode---lazyvim)
9. [ZSH aliases & helpers](#9-zsh-aliases--helpers)
10. [AeroSpace - Tiling WM](#10-aerospace---tiling-wm)
11. [Television - Universal picker](#11-television---universal-picker)
12. [LazyGit](#12-lazygit)
13. [Workflow mau](#13-workflow-mau)
14. [Troubleshooting - "Stuck in vim"](#14-troubleshooting---stuck-in-vim)
15. [Lo trinh hoc 30 ngay](#15-lo-trinh-hoc-30-ngay)

---

## 1. Tong quan kien truc

```
┌─ AeroSpace (tiling window manager o macOS) ───────────────┐
│                                                            │
│   ┌─ WezTerm (terminal emulator) ─────────────────────┐    │
│   │                                                    │    │
│   │   ┌─ tmux (session/window/pane manager) ──────┐   │    │
│   │   │                                            │   │    │
│   │   │   Window 1: nvim (LazyVim - code editor)  │   │    │
│   │   │   Window 2: zsh (shell, chay lenh)        │   │    │
│   │   │   Window 3: lazygit (git TUI)             │   │    │
│   │   │                                            │   │    │
│   │   └────────────────────────────────────────────┘   │    │
│   └─────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘
```

**Vai tro tung lop:**

| Lop | Vai tro | Tuong duong trong VSCode |
|-----|---------|--------------------------|
| AeroSpace | Sap xep cua so app o macOS | macOS Spaces / Stage Manager |
| WezTerm | Terminal emulator (ve text, font, color) | Khong co - VSCode tu chua |
| tmux | Persistent session, chia window/pane | Workspace + Terminal tab |
| Neovim | Code editor (sua file) | Cua so chinh VSCode |
| LazyGit | Git TUI | Source Control sidebar |
| Television | Fuzzy picker da kenh | Ctrl+Shift+P + Quick Open |

**Y tuong chinh:** Moi lop lam **mot viec** that tot. Khac voi IDE (mot app lam tat), o day ban **lap rap** tools tu ban toi.

---

## 2. Cau noi tu duy tu VSCode / PhpStorm

### Ban dang **tu duy theo cua so**, hay chuyen sang **tu duy theo buffer**

Trong VSCode/PhpStorm, **moi tab la mot khung nhin va mot file**. Dong tab = dong file khoi bo nho.

Trong Vim, co **3 khai niem khac nhau**:

| Khai niem | Mo ta | Y nghia |
|-----------|-------|---------|
| **Buffer** | File da load vao bo nho | Co the **an** nhung van ton tai, mo lai khong can load lai disk |
| **Window** (split) | Khung nhin len 1 buffer | Mot buffer co the hien o nhieu window, hoac an di |
| **Tab** | Bo cuc nhieu window | Khong phai "file tabs" - it dung |

> **Bai hoc 1:** `:bd` (buffer delete) moi that su dong file. Dong split (`:q`) khong dong file.

### tmux session = workspace cua VSCode

Trong VSCode ban co "Workspace" - moi project mot folder co `.vscode/settings.json`.
Trong tmux, **moi tmux session = mot workspace**:

- Detach tmux (`Ctrl+A d`) = dong VSCode nhung **giu nguyen** trang thai (nvim van mo, terminal van chay).
- Attach lai = quay lai workspace y nguyen, ke ca khi may da khoi dong lai (nho `tmux-resurrect` + `tmux-continuum`).

### "Search Everywhere" cua PhpStorm va "Quick Open" cua VSCode = telescope.nvim + television

| Tac vu | VSCode | PhpStorm | LazyVim / Stack moi |
|--------|--------|----------|---------------------|
| Mo file theo ten | `Ctrl+P` | `Ctrl+Shift+N` | `<Space><Space>` |
| Tim text trong project | `Ctrl+Shift+F` | `Ctrl+Shift+F` | `<Space>/` |
| Tim ham/class | `Ctrl+T` | `Ctrl+N` | `<Space>ss` |
| Command palette | `Ctrl+Shift+P` | `Ctrl+Shift+A` | `<Space>` (which-key) |
| Mo file gan day | `Ctrl+R` | `Ctrl+E` | `<Space>fr` |

### "Multi-cursor" -> Visual block + macro + Treesitter

Bo "multi-cursor" cua VSCode/PhpStorm rat tien nhung **khong cay sau** vao co bap. Vim co 3 cong cu thay the manh hon:

- **Visual block** (`Ctrl+V`): chon cot doc, sua dong loat.
- **Macro** (`q<ten><cac thao tac>q` -> phat lai `@<ten>`): ghi va replay chuoi lenh.
- **Treesitter swap / textobjects**: chon cau truc cu phap (function, class, argument).

---

## 3. Triet ly Vim - Modal editing

Khac biet **lon nhat** voi VSCode: Vim co nhieu **mode**. Phim `j` o mode khac nhau lam viec khac nhau.

### 5 mode chinh

| Mode | Vao mode bang | Y nghia | Thoat ve Normal |
|------|---------------|---------|-----------------|
| **Normal** | (default sau khi mo file) | Di chuyen, xoa, copy. **Khong** go chu duoc | - |
| **Insert** | `i` `a` `o` `I` `A` `O` | Go chu nhu editor binh thuong | `Esc` hoac `Ctrl+[` |
| **Visual** | `v` (char), `V` (line), `Ctrl+V` (block) | Boi den (selection) | `Esc` |
| **Command** | `:` | Go lenh (`:w`, `:q`, `:s/foo/bar/g`) | `Esc` hoac `Enter` |
| **Replace** | `R` | Go de len chu cu | `Esc` |

> **Quy tac vang:** Luc nao khong biet minh dang o dau, **bam `Esc` 2 lan** -> ve Normal.

### "Ngu phap" cua Vim: Verb + Modifier + Noun

Vim khong phai "phim tat", ma la **mot ngon ngu**. Khi quen, ban nghi `delete-inside-parentheses` -> go `di(`.

```
[count] <verb> <text-object>
   3       d        w           = delete 3 words
           c        i"          = change inside double-quote
           y        ap          = yank a paragraph
           v        i{          = visually select inside braces
           >        ip          = indent inside paragraph
```

**Verb thuong dung:**

| Verb | Y nghia |
|------|---------|
| `d` | delete (xoa va dua vao register) |
| `c` | change (xoa roi vao Insert) |
| `y` | yank (copy) |
| `v` | visual select |
| `>` `<` | indent right / left |
| `=` | auto-format |
| `gu` `gU` | lowercase / UPPERCASE |
| `gc` | comment toggle (Comment.nvim trong LazyVim) |

**Text object thuong dung:**

| Object | Pham vi |
|--------|---------|
| `w` `W` | tu (cham bo) / tu (khong dau cach) |
| `s` | cau (sentence) |
| `p` | doan (paragraph) |
| `t` | the HTML tag |
| `i"` `a"` | trong / quanh `""` (a = around, bao gom dau) |
| `i'` `a'` | trong / quanh `''` |
| `i(` `i[` `i{` | trong dau ngoac |
| `if` `af` | (Treesitter) trong / quanh function |
| `ic` `ac` | (Treesitter) trong / quanh class |

**Vi du thuc te:**

```
ci"     -> trong file "hello world", con tro o "hello" -> bam ci" -> xoa "hello world" + vao Insert
da(     -> xoa ca "func(a, b)" ke ca dau ngoac
yiw     -> copy 1 tu
viwp    -> paste de len 1 tu (substitute word)
ggVG    -> chon ca file (gg ve dau, V line-visual, G xuong cuoi)
=ip     -> auto-indent ca paragraph
gcip    -> comment ca paragraph
```

### Motion (di chuyen) phai biet

| Phim | Di chuyen |
|------|-----------|
| `h j k l` | Trai / Xuong / Len / Phai (mot ky tu) |
| `w` `b` `e` | Dau tu sau / dau tu truoc / cuoi tu |
| `0` `^` `$` | Dau dong / dau dong (bo qua space) / cuoi dong |
| `gg` `G` | Dau file / cuoi file |
| `<so>G` | Toi dong so do (vd: `42G`) |
| `f<char>` `F<char>` | Nhay den ky tu tiep / truoc tren cung dong |
| `t<char>` `T<char>` | Nhu f/F nhung dung **truoc** ky tu |
| `;` `,` | Lap lai f/t / nguoc lai |
| `%` | Nhay den dau ngoac doi xung |
| `*` `#` | Tim tu duoi con tro toi / lui |
| `Ctrl+d` `Ctrl+u` | Cuon xuong / len nua trang |
| `Ctrl+f` `Ctrl+b` | Cuon xuong / len 1 trang |
| `H` `M` `L` | Top / Middle / Bottom man hinh |
| `zz` `zt` `zb` | Dat dong hien tai ra giua / dau / cuoi man hinh |

### Edit nhanh

| Phim | Tac dung |
|------|----------|
| `i` `a` | Insert truoc / sau con tro |
| `I` `A` | Insert dau dong / cuoi dong |
| `o` `O` | Tao dong moi duoi / tren |
| `x` `X` | Xoa ky tu duoi / truoc con tro |
| `dd` | Xoa ca dong (van la `d` + text object `d`) |
| `yy` | Copy ca dong |
| `p` `P` | Paste sau / truoc |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `.` | Lap lai lenh sua **cuoi cung** (cuc manh) |
| `J` | Noi dong duoi vao dong hien tai |
| `r<char>` | Thay 1 ky tu |
| `~` | Toggle hoa/thuong |
| `>>` `<<` | Indent dong hien tai phai / trai |

---

## 4. WezTerm

**Vi tri config:** `~/.config/wezterm/wezterm.lua` (symlink toi `dotfiles/wezterm/wezterm.lua`)

### Thiet lap hien tai

- Font: **JetBrainsMono Nerd Font 13pt**, line-height 1.3
- Theme: **Catppuccin Mocha**
- Opacity 0.85 + blur 30 (trong suot, mo nen)
- Cua so khoi dong: 200 cot x 55 dong
- **Tu dong khoi dong vao tmux session "main"** khi mo

### Phim tat WezTerm

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+Q` | Toggle fullscreen (Native macOS) |
| `Ctrl+'` | Xoa scrollback buffer |
| `Cmd+Click` / `Ctrl+Click` | Mo link / file path |
| `Cmd++` / `Cmd+-` | Tang / giam font |
| `Cmd+0` | Reset font |

> **Luu y:** WezTerm khong can chia split rieng vi tmux da lo. Hay de tmux quan ly tat ca.

### Tai sao Nerd Font quan trong

Status bar tmux (catppuccin), file icon trong neo-tree, indicator trong lualine - **tat ca dung glyph cua Nerd Font**.
Neu ban thay o vuong `▢` thay vi icon thi font terminal sai. Kiem tra:

```bash
fc-list | grep -i nerd
```

---

## 5. tmux - Quan ly session, window, pane

### Prefix = `Ctrl+A`

**Cach goi prefix:** bam `Ctrl+A`, **tha tay ra**, roi bam phim tiep theo.
Khong giu Ctrl cho phim thu hai.

### Khai niem 3 cap

```
Session (project)
  └── Window 1 (tab logic)
  │     ├── Pane (chia khung)
  │     └── Pane
  └── Window 2
        └── Pane
```

- **Session** ~ "project workspace" - moi project nen 1 session.
- **Window** ~ "tab" trong session - dat ten theo muc dich (nvim / shell / lazygit).
- **Pane** ~ chia mot window thanh nhieu khung tren cung 1 tab.

### Sessions

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A o` | **sessionx** picker (fzf + zoxide) - chon/tao session, ho tro tim thu muc |
| `Ctrl+A S` | choose-tree session built-in |
| `Ctrl+A d` | Detach session (giu nen) |
| `Ctrl+A $` | Doi ten session |
| `Ctrl+A )` `(` | Session ke / truoc |
| `Ctrl+A p` | **floax** - terminal noi tren mau hinh (popup), bam lai de dong |

**Resurrect & continuum** da bat:
- Tu dong save session moi 15 phut (`continuum`).
- Khi mo lai may, attach session = trang thai ngay hom truoc (ke ca nvim).
- `Ctrl+A Ctrl+S` save thu cong, `Ctrl+A Ctrl+R` restore.

### Windows (giong tabs trong VSCode)

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A Ctrl+C` | Tao window moi (mo `$HOME`) |
| `Ctrl+A c` | **Dong pane** (warning: khong phai tao window!) - xem ghi chu |
| `Ctrl+A H` | Window truoc |
| `Ctrl+A L` | Window sau |
| `Ctrl+A Ctrl+A` | Last window (toggle 2 window cuoi) |
| `Ctrl+A 1` ... `9` | Nhay den window so 1-9 |
| `Ctrl+A r` | Doi ten window |
| `Ctrl+A w` | **choose-tree picker** (sau khi sua o dotfiles) - chon window/session truc quan |
| `Ctrl+A &` | Kill window (hoi xac nhan) |

> **Ghi chu:** `Ctrl+A c` o config nay duoc bind toi `kill-pane` (xem `tmux.reset.conf`).
> Default tmux la `new-window`, neu ban kho chiu co the doi lai trong reset file.

### Panes (chia cua so)

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A v` | Chia doc (canh ben), giu nguyen thu muc |
| `Ctrl+A s` | Chia ngang (tren/duoi), giu nguyen thu muc |
| `Ctrl+A \|` | Chia ngang (built-in) |
| `Ctrl+A h/j/k/l` | Di chuyen giua panes |
| `Ctrl+A z` | Zoom pane (toan man hinh, bam lai de thu nho) |
| `Ctrl+A c` | Dong pane hien tai (binding o config nay) |
| `Ctrl+A x` | Hoan vi pane voi pane ke |
| `Ctrl+A ,` `.` | Resize trai 20 / phai 20 |
| `Ctrl+A -` `=` | Resize xuong 7 / len 7 |
| `Ctrl+A *` | Toggle sync panes (go 1 lan -> nhieu pane cung go) |
| `Ctrl+A q` | Hien so pane vai giay (bam so de focus) |

### Copy mode (cuon, tim, copy text)

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A [` | Vao copy mode |
| `h j k l` `w b` | Di chuyen kieu Vim |
| `Ctrl+u` `Ctrl+d` | Cuon nua trang |
| `g` `G` | Dau / cuoi buffer |
| `/` `?` | Tim toi / lui |
| `n` `N` | Ket qua tim ke / truoc |
| `v` | Bat dau chon |
| `Ctrl+V` | Block selection |
| `y` | Copy vao clipboard he thong (nho `tmux-yank`) |
| `q` hoac `Esc` | Thoat copy mode |

### Khac

| Phim | Chuc nang |
|------|-----------|
| `Ctrl+A K` | Clear screen + Enter |
| `Ctrl+A R` | Reload `~/.config/tmux/tmux.conf` |
| `Ctrl+A I` | TPM: install / update plugins |
| `Ctrl+A U` | TPM: update plugins |
| `Ctrl+A :` | Command prompt cua tmux (vd: `:setw synchronize-panes`) |
| `Ctrl+A t` | Hien dong ho lon trong pane |

### Status bar (catppuccin)

Ben trai: `[session_name]` + window list.
Ben phai: thu muc hien tai + dong ho (`%H:%M`).

Tuy chinh trong `tmux/tmux.conf`:

```
set -g @catppuccin_status_modules_right "directory date_time"
set -g @catppuccin_date_time_text "%H:%M"
```

Doi format: vd `"%H:%M  %d-%b"` de them ngay.

---

## 6. Neovim / LazyVim chi tiet

**Leader = `<Space>`**. Tat ca shortcut chu cai trong LazyVim deu bat dau bang `Space`.

> **Khi quen leader, dung `<Space>` mot lan trong Normal mode** - which-key se hien menu cac phim tiep theo. Khong can nho het.

### Cau truc thu muc nvim

```
dotfiles/nvim/
├── init.lua              # entry point - load LazyVim
├── lazy-lock.json        # version lock cua plugin
├── lazyvim.json          # cau hinh "extras" da bat
├── stylua.toml           # rule format Lua code
└── lua/
    ├── config/           # cau hinh he thong (autocmds, keymaps, options)
    └── plugins/          # them plugin / override LazyVim
```

Khi them plugin moi: tao file `.lua` trong `lua/plugins/` - LazyVim **tu dong** load.

### File & Navigation

| Phim | Chuc nang | Tuong duong VSCode |
|------|-----------|--------------------|
| `<Space><Space>` | Tim file (fuzzy) | `Ctrl+P` |
| `<Space>ff` | Find files (cwd) | `Ctrl+P` |
| `<Space>fr` | Recent files | `Ctrl+R` |
| `<Space>fb` | Find buffers | `Ctrl+Tab` |
| `<Space>/` | Live grep ca project | `Ctrl+Shift+F` |
| `<Space>sw` | Search word duoi con tro | - |
| `<Space>sg` | Live grep (alias) | - |
| `<Space>ss` | Symbol trong file | `Ctrl+Shift+O` |
| `<Space>sS` | Symbol toan workspace | `Ctrl+T` |
| `<Space>e` | Toggle neo-tree (explorer) | `Ctrl+B` |
| `<Space>E` | neo-tree o file hien tai | `Right click reveal` |
| `<Space>,` | Buffer picker | `Ctrl+Tab` |
| `<Space>bd` | Delete buffer (close file) | `Ctrl+W` |
| `<Space>bD` | Delete buffer kem force | - |
| `<Space>bp` | Pin buffer | - |
| `<Space>fp` | Find Plugin File (custom) | - |

### LSP / Code

| Phim | Chuc nang | Tuong duong |
|------|-----------|-------------|
| `gd` | Go to definition | F12 |
| `gD` | Go to declaration | - |
| `gr` | References | Shift+F12 |
| `gI` | Implementation | Ctrl+F12 |
| `gy` | Type definition | - |
| `K` | Hover documentation | Mouse over / Ctrl+K K |
| `<Space>ca` | Code actions | `Ctrl+.` / `Alt+Enter` |
| `<Space>cr` | Rename symbol | F2 |
| `<Space>cf` | Format file (conform.nvim) | `Shift+Alt+F` |
| `<Space>cd` | Line diagnostics | - |
| `<Space>cs` | Symbols outline | `Ctrl+Shift+O` |
| `]d` `[d` | Diagnostic ke / truoc | F8 / Shift+F8 |
| `]e` `[e` | Error ke / truoc | - |
| `<Space>xx` | Trouble panel (all diagnostics) | Problems tab |
| `<Space>xd` | Document diagnostics | - |

### Cua so / Splits trong nvim

| Phim | Chuc nang |
|------|-----------|
| `<Space>wv` hoac `<Ctrl-w>v` | Split doc |
| `<Space>ws` hoac `<Ctrl-w>s` | Split ngang |
| `<Ctrl-h/j/k/l>` | Di chuyen giua splits (cung lam viec voi tmux pane qua `vim-tmux-navigator`) |
| `<Ctrl-w>=` | Resize bang nhau |
| `<Ctrl-w>_` | Toi da chieu cao split |
| `<Ctrl-w>\|` | Toi da chieu ngang split |
| `<Space>-` | Split duoi (LazyVim) |
| `<Space>\|` | Split phai (LazyVim) |
| `<Ctrl-w>q` | Dong split |

### Tabs (it dung - dung buffer thay)

| Phim | Chuc nang |
|------|-----------|
| `<Space><Tab><Tab>` | Tab moi |
| `<Space><Tab>]` | Tab ke |
| `<Space><Tab>[` | Tab truoc |
| `<Space><Tab>d` | Dong tab |

### Git

| Phim | Chuc nang |
|------|-----------|
| `<Space>gg` | **LazyGit** full TUI |
| `<Space>gG` | LazyGit cho file hien tai |
| `<Space>gb` | Git blame full file (`gitsigns`) |
| `<Space>gB` | Git blame line |
| `]h` `[h` | Hunk ke / truoc |
| `<Space>ghs` | Stage hunk |
| `<Space>ghr` | Reset hunk |
| `<Space>ghp` | Preview hunk |
| `<Space>ghd` | Diffview |

### Save / Quit / Run

| Lenh | Y nghia |
|------|---------|
| `:w` | Save |
| `:wa` | Save tat ca |
| `:q` | Quit |
| `:q!` | Quit khong save |
| `:wq` hoac `:x` | Save & quit |
| `:qa` | Quit tat ca |
| `:e <path>` | Mo file |
| `:e!` | Reload file tu disk |
| `:bd` | Close buffer |
| `:so %` | Source file Lua hien tai |
| `:!<cmd>` | Chay shell command (vd: `:!ls`) |
| `:r !<cmd>` | Chen output shell vao buffer |

### Search & replace

| Lenh | Chuc nang |
|------|-----------|
| `/foo` | Tim "foo" toi |
| `?foo` | Tim "foo" lui |
| `n` `N` | Ket qua ke / truoc |
| `:%s/foo/bar/g` | Replace toan file |
| `:%s/foo/bar/gc` | Replace co confirm |
| `:%s/\<foo\>/bar/g` | Replace whole-word (`\<...\>` la word boundary) |
| `<Space>sr` | Spectre - search & replace project-wide (neu cai) |
| `*` `#` | Tim tu duoi con tro toi / lui |

### Snippets (LuaSnip mac dinh trong LazyVim)

- Bam tab khi popup cmp mo de chap nhan goi y / nhay placeholder.
- `<Ctrl-l>` `<Ctrl-h>` jump placeholder toi / lui.
- Snippet ngu canh ngon ngu kich hoat sau khi LSP server (Mason install) san sang.

### Autocomplete (nvim-cmp)

- Trong Insert, danh chu se bat popup.
- `<Tab>` `<S-Tab>` chon item.
- `<Enter>` confirm.
- `<Ctrl-e>` cancel popup.
- `<Ctrl-Space>` mo popup thu cong.

### Mason - quan ly LSP / formatter / linter

```
:Mason              -- mo UI Mason
:LspInstall <ten>   -- cai LSP server
:MasonUpdate        -- cap nhat
```

LSP da co san khi LazyVim phat hien filetype.
Vi du `.php` -> ban can `:Mason` cai `intelephense` hoac `phpactor`.
File `.go` -> `gopls`. JS/TS -> `typescript-language-server`.

### Conform.nvim - format

Format khi save da bat cho cac filetype cau hinh trong `lua/plugins/conform.lua`.
Format thu cong: `<Space>cf`.

### Comment (Comment.nvim)

| Phim | Tac dung |
|------|----------|
| `gcc` | Toggle comment dong hien tai |
| `gc` + motion | Comment range (vd `gcap` = comment 1 paragraph) |
| `gc` (Visual) | Comment selection |

### Surround (nvim-surround)

Da bat trong `lua/plugins/surround.lua`.

| Phim | Y nghia |
|------|---------|
| `ys<motion><char>` | Add surround. Vd `ysiw"` = surround word voi `""` |
| `ds<char>` | Delete surround. Vd `ds"` xoa `""` quanh con tro |
| `cs<old><new>` | Change. Vd `cs'"` doi `'...'` thanh `"..."` |
| `ysiwt<tag>` | Surround word voi HTML tag |

### Macros - "ghi va replay"

```
qa              -> bat dau ghi vao register a
... lam viec ...
q               -> ngung ghi
@a              -> replay
@@              -> replay lan nua
10@a            -> replay 10 lan
```

Manh hon multi-cursor cua VSCode khi dung dung.

### Multi-cursor thay the

LazyVim co `<Ctrl-N>` (vim-visual-multi neu extra). Hoac dung:

```
:%s/pattern/replace/g       -- replace toan file
ggVG=                       -- chon ca file roi auto-indent
Ctrl+V <chon cot> I <chu> Esc  -- block insert
```

### Neo-tree shortcut quan trong (khi dang trong neo-tree)

| Phim | Tac dung |
|------|----------|
| `<Enter>` | Mo file |
| `a` | Add file/folder (`/foo/` = folder) |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `y` | Copy ten file |
| `Y` | Copy full path |
| `H` | Toggle hidden files |
| `R` | Refresh |
| `?` | Help |

### Telescope tips

- Trong picker: `<Ctrl-j>` `<Ctrl-k>` di chuyen, `<Ctrl-q>` dua tat ca ket qua vao quickfix.
- `<Ctrl-x>` mo trong split ngang, `<Ctrl-v>` mo trong split doc.
- `<Esc>` thoat luon (LazyVim cau hinh insert-mode-on-open).

---

## 7. Cau noi PhpStorm -> LazyVim

| PhpStorm | LazyVim / Tools |
|----------|-----------------|
| Search Everywhere (`Shift Shift`) | `<Space><Space>` (file) + `<Space>/` (text) + `<Space>sS` (symbol) |
| Find Action (`Ctrl Shift A`) | `<Space>` -> dung which-key, hoac `:` go lenh |
| Refactor -> Rename (`Shift F6`) | `<Space>cr` |
| Refactor -> Extract Method | Code actions `<Space>ca` (neu LSP support, vd: tsserver, intelephense) |
| Reformat Code (`Cmd Alt L`) | `<Space>cf` (conform.nvim) hoac auto-save |
| Optimize Imports | `<Space>co` (neu co), hoac LSP code action |
| Find Usages (`Alt F7`) | `gr` |
| Go to Declaration (`Cmd B`) | `gd` |
| Go to Implementation (`Cmd Alt B`) | `gI` |
| Go to Test (`Cmd Shift T`) | Dung neotest neu cai |
| Run / Debug | `nvim-dap` + `nvim-dap-ui` (LazyVim extra "dap" co san) |
| Database tool | external app (TablePlus / DBeaver), hoac plugin `vim-dadbod-ui` |
| HTTP Client | plugin `rest.nvim` hoac dung `curl` / `xh` (alias `http`) |
| Live Templates | LuaSnip snippets |
| Local History | `undotree` (`<Space>uu`) - di chuyen graph undo |
| Code With Me | Khong co tuong duong - dung `tmate` neu can share session |
| .editorconfig | LazyVim ho tro mac dinh |
| Markdown preview | plugin `markdown-preview.nvim` hoac dung `glow` trong terminal |
| Bookmark dong (`F11`) | `<Space>ma` (harpoon neu cai) hoac `mA` (built-in mark) |

### Dac biet cho PHP

Cai cac thanh phan sau qua `:Mason`:

- `intelephense` (LSP - free version OK) hoac `phpactor`
- `php-cs-fixer` hoac `pretty-php` (formatter)
- `phpstan` hoac `psalm` (linter)
- `phpdebug-adapter` (xdebug qua DAP)

Cau hinh nhanh trong `lua/plugins/php.lua`:

```lua
return {
  { "neovim/nvim-lspconfig", opts = {
      servers = { intelephense = {} } } },
  { "stevearc/conform.nvim",  opts = {
      formatters_by_ft = { php = { "php_cs_fixer" } } } },
}
```

---

## 8. Cau noi VSCode -> LazyVim

| VSCode | LazyVim |
|--------|---------|
| `Ctrl+P` Quick Open | `<Space><Space>` |
| `Ctrl+Shift+P` Command Palette | `<Space>` (which-key) + `:` (vim cmd) |
| `Ctrl+B` Toggle sidebar | `<Space>e` (neo-tree) |
| `Ctrl+J` Toggle terminal | `<Space>tt` (toggleterm) hoac `Ctrl+A %` (tmux pane) |
| `Ctrl+Shift+F` Find in files | `<Space>/` |
| `Ctrl+Shift+H` Replace in files | Spectre `<Space>sr` hoac `:cdo s/foo/bar/gc` |
| `Ctrl+D` Multi-cursor add next | `*` -> `cgn` -> `.` lap |
| `Alt+Click` Add cursor | Visual block `Ctrl+V` |
| `F2` Rename symbol | `<Space>cr` |
| `Ctrl+.` Quick fix | `<Space>ca` |
| `Ctrl+/` Toggle comment | `gcc` |
| `Alt+Up/Down` Move line | `:m+1` / `:m-2`, hoac map `<A-j>` `<A-k>` (LazyVim mac dinh) |
| `Ctrl+Enter` New line below | `o` |
| `Ctrl+G` Go to line | `<so>G` (vd `42G`) |
| `Ctrl+Tab` Switch buffer | `<Space>,` hoac `<S-h>` `<S-l>` |
| Zen mode | `<Space>uZ` |
| Settings sync | Git ca thu muc `~/.config/nvim` |

### Multi-cursor "thay the" cu the

Yeu cau: doi `oldName` -> `newName` o nhieu cho trong file.

**Cach Vim:**

```
/oldName<Enter>      -- tim
cgn newName<Esc>     -- change next match, doi xong ve normal
.                    -- lap lai cho ket qua tiep theo
.                    -- ...
```

**Hoac:**

```
:%s/\<oldName\>/newName/gc   -- replace toan file co confirm tung lan
```

---

## 9. ZSH aliases & helpers

**Vi tri:** `dotfiles/zshrc/.zshrc` (symlink toi `~/.zshrc`)

### Git

```bash
gst              # git status
gc "msg"         # git commit -m "msg"
gca "msg"        # git commit -a -m
gp               # git push origin HEAD
gpu main         # git pull origin main
glog             # git log dep co graph
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
kd pod ten       # kubectl describe
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
ltree            # eza tree khong long format
cat file         # bat (syntax highlight)
v file           # nvim
cx folder        # cd vao + ls
fcd              # fzf cd
fv               # fzf find file -> mo nvim
..               # cd ..
...              # cd ../..
....             # cd ../../..
```

### Khac

```bash
http URL         # xh (curl thay the)
cl               # clear
server           # python http server port 4445
tunnel           # ngrok http 4445
mat              # cmatrix trong tmux window moi (vui :))
```

### Autosuggestions (chu xam phia sau)

- `Ctrl+E` - chap nhan goi y (chi dien, **chua** chay)
- `Ctrl+W` - chap nhan goi y va **chay luon**

---

## 10. AeroSpace - Tiling WM

**Vi tri config:** `aerospace/aerospace.toml` (symlink toi `~/.config/aerospace/aerospace.toml`)

Bat dau: Mo AeroSpace.app tu `/Applications`, cho phep Accessibility trong System Settings.

### Phim co ban

| Phim | Chuc nang |
|------|-----------|
| `Alt+H/J/K/L` | Focus cua so trai/duoi/tren/phai |
| `Alt+Shift+H/J/K/L` | Di chuyen cua so |
| `Alt+1`..`Alt+4` | Chuyen workspace 1-4 |
| `Alt+Shift+1`..`4` | Move app sang workspace |
| `Alt+Tab` | Last workspace |
| `Alt+W` | Mo WezTerm |
| `Alt+O` | Mo Obsidian (neu binding co) |
| `Alt+F` | Toggle fullscreen |

---

## 11. Television - Universal picker

```bash
tv                    # File picker default
tv git-log            # Git commit history
tv git-branch         # Git branches
tv docker-containers  # Docker
tv k8s-pods           # Kubernetes pods (qua kubectl)
tv gh-prs             # GitHub PRs
tv ssh-hosts          # SSH config hosts
tv tmux-sessions      # Tmux sessions
tv alias              # Xem va chay aliases
```

Trong picker:

- `Ctrl+S` chuyen kenh (channel)
- `Tab` multi-select
- `Enter` chon
- `Ctrl+J/K` di chuyen
- `Esc` thoat

---

## 12. LazyGit

Mo bang `<Space>gg` trong nvim hoac chay `lazygit` o terminal.

### Panel layout (so 1-5)

```
1. Status   - thay doi unstaged/staged
2. Files    - chi tiet file
3. Branches - branches local + remote
4. Commits  - log
5. Stash    - stash
```

Bam phim so de chuyen panel.

### Phim chinh

| Phim | Tac dung |
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
| `e` | Edit file (mo nvim) |
| `<Enter>` | Vao chi tiet |
| `?` | Help |
| `q` | Thoat |

---

## 13. Workflow mau

### Bat dau project moi

```bash
# 1. Mo WezTerm (tu dong attach session "main")

# 2. Tao session moi cho project
Ctrl+A o
# -> go ten "myapi" hoac chon thu muc qua zoxide -> Enter

# 3. Trong session moi, mo nvim
cd ~/Workspace/myapi
v .

# 4. Trong nvim:
Space Space        # tim file
Space /            # grep
Space gg           # lazygit

# 5. Can shell ben canh nvim
Ctrl+A v           # split doc trong tmux
# hoac
Ctrl+A Ctrl+C      # window moi (tmux)
```

### Sua bug nhanh

```bash
fv                 # fzf find file -> nvim
# Trong nvim:
gd                 # go to definition cua function loi
gr                 # tim noi su dung
*                  # tim tu nay trong file
ci"                # sua noi dung trong dau ""
:w                 # save
]d                 # diagnostic ke - kiem tra hint LSP
Space ca           # code action - dung khi co goi y fix
Space gg           # commit qua lazygit
```

### Het ngay

```bash
Ctrl+A d           # detach session
# Dong WezTerm
# Tat may

# Hom sau:
# 1. Bat may, mo WezTerm
# 2. Attach session san co -> nvim van mo dung file dang sua, terminal van o cwd cu
```

### Review PR

```bash
gco pr-branch
v .
Space gg
# Trong lazygit: bam 4 (Commits) -> chon commit -> Enter de xem diff
# Hoac trong nvim: :Gitsigns toggle_deleted
# Hoac shell: gh pr checkout 123 && gh pr diff
```

---

## 14. Troubleshooting - "Stuck in vim"

### Khong biet minh dang o dau

Bam `Esc` 2-3 lan. Neu van la, bam `Ctrl+C`.
Kiem tra goc duoi cua nvim - se ghi mode (`-- INSERT --`, `-- VISUAL --`...).

### Lo bam dau ":" khong thoat duoc

Day la Command mode. Bam `Esc`.

### Khong save duoc, bao "no write since last change"

```
:wq         -- save & quit
:q!         -- quit khong save
```

### File khong save cao "E37: No write since last change"

Co the file `readonly`. Kiem tra `:set ro?`. Thay doi: `:set noro`.
Hoac save force: `:w!`.

### "Found a swap file" khi mo file

Da co session khac mo file (hoac crash truoc). Chon:
- `O` - read-only mo
- `R` - recover swap (lay du lieu chua save)
- `D` - delete swap (neu chac chan khong can)

### Bam phim khong phan ung trong tmux

Co the do escape time. Trong config da dat `set -g escape-time 0`. Neu van loi, reload: `Ctrl+A R`.

### Plugin khong load sau khi sua tmux.conf

```
Ctrl+A R       # reload config
Ctrl+A I       # TPM install
```

### Status bar tmux ve mau xanh la mac dinh

Plugin catppuccin chua chay. Reload + install:

```bash
tmux source-file ~/.config/tmux/tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
```

### Nvim mo cham

```
:Lazy profile      -- xem plugin nao load lau
:checkhealth       -- chan doan tong the
```

### LSP khong nhan filetype

```
:LspInfo                 -- xem LSP da attach chua
:Mason                   -- cai LSP cho ngon ngu
:checkhealth lsp
```

### Format khong chay khi save

```
:ConformInfo             -- xem formatter cau hinh
:checkhealth conform
```

### Reset toan bo plugin

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
nvim                     # LazyVim se cai lai
```

---

## 15. Lo trinh hoc 30 ngay

### Tuan 1 - Sinh ton

Muc tieu: **mo file, sua, save, thoat** khong panic.

- Hoc `i a o`, `Esc`, `:w`, `:q`, `:wq`, `:q!`.
- Di chuyen: `h j k l`, `w b`, `gg G`, `0 $`.
- Xoa: `x`, `dd`. Undo: `u`. Paste: `p`.
- Trong tmux: chi can `Ctrl+A o` (session), `Ctrl+A d` (detach), `Ctrl+A 1-9` (window).
- Trong LazyVim: chi can `<Space><Space>`, `<Space>/`, `<Space>e`, `<Space>gg`.

> Muc tieu tuan 1: **khong quay ve VSCode** de sua 1 file.

### Tuan 2 - Tang toc

- Hoc verb + text object: `ciw`, `da(`, `yi"`, `vip`.
- LSP: `gd`, `gr`, `K`, `<Space>ca`, `<Space>cr`.
- tmux pane: `Ctrl+A v`, `Ctrl+A s`, `Ctrl+A z`.
- LazyGit hoan chinh.

### Tuan 3 - Hieu qua

- `f t F T ; ,` - di chuyen ngang dong nhanh.
- `*` `#` `n` `N` `/` `?` - tim trong file.
- `.` (dot repeat) - lam ban yeu Vim.
- Macro `q@`.
- Visual block `Ctrl+V`.
- Snippets, autocomplete fluent.

### Tuan 4 - Master

- Cau hinh `lua/plugins/*.lua` rieng.
- Them LSP cho ngon ngu chinh.
- Dung `<Space>` + which-key, khong nho keymap.
- Multi-buffer workflow: harpoon hoac bookmark.
- Treesitter textobjects: `if af ic ac`.
- Cau hinh nvim-dap de debug.

> Sau 1 thang: ban se tu thay khong muon ve VSCode/PhpStorm.

---

## Tra cuu nhanh - "Toi muon..."

| Toi muon... | Phim |
|-------------|------|
| Mo mot file | `<Space><Space>` |
| Tim text trong project | `<Space>/` |
| Mo terminal ben canh code | `Ctrl+A v` |
| Tao project workspace moi | `Ctrl+A o` -> ten moi |
| Quay lai project hom qua | `Ctrl+A o` -> chon |
| Commit code | `<Space>gg` -> Space stage -> `c` |
| Rename ham/bien | `<Space>cr` |
| Xem documentation | `K` |
| Tim noi function duoc goi | `gr` |
| Format file | `<Space>cf` |
| Toggle comment | `gcc` |
| Quit nvim | `:qa` |
| Detach tmux | `Ctrl+A d` |

---

## Reload & cap nhat config

```bash
# Tmux
Ctrl+A R                # trong tmux

# Nvim
:Lazy sync              # cap nhat plugin
:Mason                  # cap nhat LSP
:checkhealth            # chan doan

# Zsh
exec zsh                # reload shell
source ~/.zshrc         # source lai

# WezTerm
# Tu dong reload khi save wezterm.lua
```

---

> **Loi khuyen cuoi:**
> Vim/tmux khong yeu cau ban ghi nho het. **Bam `<Space>` cho which-key, bam `:Telescope keymaps` de tim phim.**
> Dau tu 30 phut moi ngay trong 1 thang, ban se quay lai VSCode chi de... copy file.
