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
| `Win + Tab` / `Alt + Tab` | Switch windows with thumbnail preview |
| `Shift + Alt + Tab` | Switch to previous window |
| `Win + Q` / `Alt + F4` | Close active window |
| `Win + F` | Toggle true fullscreen |
| `Win + P` | Pin active window (Toggle Always On Top) |
| `Win + D` | Minimize all windows / Show Desktop |
| `Win + Up` | Maximize window |
| `Win + Down` | Restore window (if maximized) / Minimize window |
| `Win + Left` | Snap window to left half |
| `Win + Right` | Snap window to right half |
| `Win + Shift + Left / Right` | Move active window to other display / monitor |

### 2. Applications & Tools

| Shortcut | Action |
| :--- | :--- |
| `Win + B` | Launch Web Browser (Brave) |
| `Win + E` | Open File Manager (Dolphin) |
| `Win + Enter` / `Win + T` / `Ctrl + Alt + T` | Open Terminal (Alacritty) |
| `Win + .` (Period) | Emoji Picker |
| `Ctrl + Shift + Esc` | Open Process Manager (btop) |
| `Win + Shift + S` / `Print` | Interactive region screenshot (Snipping Tool) |
| `Shift + Print` | Fullscreen screenshot |

### 3. System & Shell (Noctalia)

| Shortcut | Action |
| :--- | :--- |
| `Win + S` | Quick Audio & Sound Output switcher |
| `Win + R` | Reload Compositor & Desktop Shell live |
| `Win + C` | Toggle Caffeine (Keep screen awake) |
| `Win + I` | Toggle System Settings & Theme configuration |
| `Win + A` | Quick Settings & Control Center (Wi-Fi, Bluetooth) |
| `Win + N` | Notification Center |
| `Win + V` | Clipboard History Manager |
| `Win + L` | Lock screen |
| `Win + X` | Power & Session Menu (Shutdown, Reboot, Logout) |
| `Win + W` / `Win + Shift + W` | Next / Previous Wallpaper (Wallhaven automated cycling) |
| `Win + Ctrl + W` | Open current wallpaper source on Wallhaven |

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

