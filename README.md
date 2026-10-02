# CachyOS & Arch Linux Dotfiles

A minimalist, high-performance Wayland desktop configuration featuring **Labwc**, **Noctalia Shell**, and **Starship Prompt**.

Designed with a sharp geometric aesthetic (`radius = 0`), Windows-style ergonomic keybindings, and dynamic Material You color palette extraction directly from wallpapers.

---

## 🚀 Quick Start

Run this one-liner in your terminal to clone and install:

```bash
git clone https://github.com/sfpcshch/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

### Installation Options

* **Deploy configurations only (skip package manager checks):**
  ```bash
  ./install.sh --no-pkg
  ```

* **Save running system configs back into the repository:**
  ```bash
  ./install.sh --save
  ```

---

## ⌨️ Keybindings

### 1. Window Management & Multitasking

| Shortcut | Action |
| :--- | :--- |
| `Win` / `Win + Space` | Toggle Start Menu & App Launcher |
| `Win + Tab` | Task View (Interactive thumbnail window switcher OSD) |
| `Alt + Tab` | Switch windows with thumbnail preview |
| `Shift + Alt + Tab` | Switch to previous window |
| `Win + Q` / `Alt + F4` | Close active window |
| `Win + F` | Toggle true fullscreen |
| `Win + D` | Minimize all windows / Show Desktop |
| `Win + Up` | Maximize window |
| `Win + Down` | Minimize window to taskbar (Iconify) |
| `Win + Left` | Snap window to left half |
| `Win + Right` | Snap window to right half |

### 2. Applications & Tools

| Shortcut | Action |
| :--- | :--- |
| `Win + B` | Launch default web browser (`gtk-launch $(xdg-settings get default-web-browser)`) |
| `Win + E` | Open File Manager (Dolphin) |
| `Win + Enter` / `Win + T` | Open Terminal (Alacritty) |
| `Win + R` | Quick command launcher |
| `Ctrl + Shift + Esc` | Open Process Manager (btop) |
| `Win + Shift + S` / `Print` | Interactive region screenshot (Snipping Tool) |
| `Shift + Print` | Fullscreen screenshot |

### 3. System & Shell (Noctalia)

| Shortcut | Action |
| :--- | :--- |
| `Win + I` / `Win + S` | Toggle System Settings & Theme configuration |
| `Win + A` | Quick Settings & Control Center (Wi-Fi, Bluetooth, Audio) |
| `Win + N` | Notification Center |
| `Win + V` | Clipboard History Manager |
| `Win + L` | Lock screen |
| `Win + X` | Power & Session Menu (Shutdown, Reboot, Logout) |
| `Win + W` | Next Wallpaper (Wallhaven automated cycling) |
| `Win + Shift + W` | Previous Wallpaper |

### 4. Function & Media Keys

| Key | Action |
| :--- | :--- |
| `Fn + Brightness Up/Down` | Adjust screen brightness with Noctalia OSD |
| `Fn + Volume Up/Down/Mute` | Adjust speaker volume with Noctalia OSD |
| `Fn + Mic Mute` | Toggle microphone mute |
| `Fn + Play / Next / Prev` | Control active media playback |

---

## 🛠️ Management & Handy Commands

```bash
# Reload Labwc compositor configuration live:
labwc --reconfigure

# Toggle Dark / Light theme mode:
noctalia msg theme-mode-toggle

# Cycle to the next wallpaper:
wallpaper-cycle.sh next

# Open settings:
noctalia msg settings-toggle
```

---

## 🎨 Design Principles

* **Sharp Aesthetics**: Flat surfaces, crisp rectangular geometry (`cornerRadius = 0`).
* **Dynamic Palette**: System accent colors, prompt colors, and borders automatically regenerate upon wallpaper change via Noctalia.
* **Zero Overhead**: Under 2.5ms prompt render time, native Wayland protocols, direct memory variable lookups.
