# coreVidit's Dotfiles

> [!IMPORTANT]
> **Welcome!** To ensure a smooth and transparent setup, this repository includes an `install.sh` script that automates the deployment process. It acts as a safety-first bootstrap: it detects or installs an AUR helper, synchronizes all required system and AUR dependencies, automatically backs up any existing configuration folders to `.bak` (ensuring zero data loss), and establishes the correct symlinks. Whether you are new to Arch or a seasoned pro, the script provides a safe, reproducible setup without blindly overwriting your personal files.

---

## Core Features

### Modular Architecture
Unlike monolithic configs, this setup uses a **source-based hierarchy**. Settings for visuals, keybinds, programs, and input are all split into separate files in `hypr/source/`. This makes tweaking components incredibly easy without breaking the system.

### Instant Global Theming
The installer is smart. It doesn't just copy files—it initializes your system:
- **Dynamic Palettes:** Automatically generates `pywal` palettes based on your wallpaper.
- **Universal Sync:** Instantly syncs colors across your Terminal (Kitty), Status Bar (Waybar), Notifications (SwayNC), and Browser (Pywalfox).
- **No Manual Setup:** Run the installer, and your entire desktop is themed immediately.

### Dynamic Keybind Helper
Never forget a shortcut again. Press `CTRL + SHIFT + SPACE` to summon an elegant, searchable `vicinae` menu displaying every single active keybind, perfectly parsed directly from your `keybinds.conf` descriptions.

### Integrated Power Tools
- **OCR to Clipboard:** Extract text from any part of your screen instantly (`ALT + T`).
- **Google Lens Integration:** Select a screen region to reverse-image search the web (`ALT + I`).
- **WayClick Engine:** A lightweight, self-bootstrapping mechanical keyboard sound emulator.
- **Native Scratchpads:** Instant drop-down access to your Terminal, Spotify, and System Monitor using Hyprland's special workspaces.

---

## Repository Structure

| Component | Description |
|---|---|
| `hypr/` | Core window manager logic, modular configs, locker, and idler. |
| `waybar/` | Dynamic status bar featuring multiple switchable themes (Zen, Line, Default). |
| `system_scripts/` | Core OS integrations: Keybind parsers, SwayOSD watchers, and UI switchers. |
| `user_scripts/` | Daily power tools: OCR, Image Search, EDP toggles, and Wayclick. |
| `vicinae/` | Fast, lightweight Wayland application launcher and menu provider. |
| `swaync/` | Notification center styles and layout settings. |

---

## Installation

### 1. Clone the Repository
We strongly recommend cloning directly to `~/dotfiles` to ensure all hardcoded script paths function perfectly.
```bash
git clone https://github.com/coreVidit/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 2. Run the Installer
```bash
bash install.sh
```

**What the installer does:**
- Detects or installs an AUR Helper (`paru` or `yay`).
- Installs all missing Pacman and AUR dependencies.
- Safely backs up existing configurations to `*.bak`.
- Hardens system permissions and initializes the UI daemon.

---

## Essential Keybindings

| Action | Shortcut |
|---|---|
| **App Launcher** | `ALT + SPACE` |
| **View All Keybinds** | `CTRL + SHIFT + SPACE` |
| **Lock Screen** | `SUPER + M` |
| **Change Wallpaper** | `ALT + W` |
| **Change Waybar Theme** | `ALT + B` |
| **Dropdown Terminal** | `ALT + 1` |
| **Audio Manager** | `ALT + 2` |
| **System Monitor** | `ALT + 3` |
| **Google Lens** | `ALT + I` |
| **OCR to Clipboard** | `ALT + T` |

> [!TIP]  
> Press `CTRL + SHIFT + SPACE` anywhere in the OS to pull up the dynamic keybind helper for a complete list!

---

## Post-Installation & Troubleshooting

### WayClick Setup (Keyboard Sounds)
You must run the WayClick script once in a terminal to finish its automated Python environment setup:
```bash
~/user_scripts/wayclick/dusky_wayclick.sh
```
*(Ensure you rebooted after running `install.sh` so your user is properly added to the `input` group!)*

### Firefox Theme Integration
For Firefox to automatically theme itself to your wallpaper:
1. Install the [Pywalfox Add-on](https://addons.mozilla.org/en-US/firefox/addon/pywalfox/).
2. Open its settings and click **Fetch Pywal Colors** once to establish the initial connection.

### Hardware Keys (Volume/Brightness)
Standard laptop function keys (`F2`, `F3`, `F6`, etc.) are mapped to `swayosd-client`. If your laptop uses different keys, simply open `hypr/source/keybinds.conf` and update the bindings at the bottom of the file.

---
*Built for Arch Linux. Tailored for maximum flow state.*
