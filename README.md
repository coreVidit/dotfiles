# coreVidit's Dotfiles

> [!IMPORTANT]
> **Welcome!** To ensure a smooth and transparent setup, this repository includes an `install.sh` script that automates the deployment process. It acts as a safety-first bootstrap: it detects or installs an AUR helper, synchronizes all required system and AUR dependencies, automatically backs up any existing configuration folders to `.bak` (ensuring zero data loss), and establishes the correct symlinks. Whether you are new to Arch or a seasoned pro, the script provides a safe, reproducible setup without blindly overwriting your personal files.

---

## Visual Preview

<img src="assets/previews/preview_1.png" width="32%"> <img src="assets/previews/preview_2.png" width="32%"> <img src="assets/previews/preview_3.png" width="32%">
<img src="assets/previews/preview_4.png" width="32%"> <img src="assets/previews/preview_5.png" width="32%"> <img src="assets/previews/preview_6.png" width="32%">

### Extra Screenshots
<img src="assets/previews/preview_alt1.png" width="32%"> <img src="assets/previews/preview_alt2.png" width="32%"> <img src="assets/previews/preview_alt3.png" width="32%">

---

## Core Features

###  Keybind Helper
Never forget a shortcut again. Press `CTRL + SHIFT + SPACE` to summon an elegant, searchable `vicinae` menu displaying every single active keybind, perfectly parsed directly from your `keybinds.conf` descriptions.

###  Power Tools
- **OCR to Clipboard:** Extract text from any part of your screen instantly (`ALT + T`).
- **Google Lens Integration:** Select a screen region to reverse-image search the web (`ALT + I`).
- **WayClick Engine:** A lightweight, self-bootstrapping mechanical keyboard sound emulator.
- **Native Scratchpads:** Instant drop-down access to your Terminal, Spotify, and System Monitor using Hyprland's special workspaces.


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

## Essential Keybindings

| Action | Shortcut |
|---|---|
| **App Launcher** | `ALT + SPACE` |
| **View All Keybinds** | `CTRL + SHIFT + SPACE` |
| **Wlogout** | `ALT + TAB` |
| **Change Wallpaper** | `ALT + W` |
| **Change Waybar Style** | `ALT + B` |
| **Dropdown Terminal** | `ALT + 1` |
| **Audio Manager** | `ALT + 2` |
| **System Monitor** | `ALT + 3` |
| **Google Lens** | `ALT + I` |
| **OCR to Clipboard** | `ALT + T` |
| **Screenshot** | `SUPER + S` |


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

## Credits & Acknowledgements
- Massive thanks to [dusklinux](https://github.com/dusklinux/dusky) for the incredible **WayClick** program that powers the mechanical keyboard sounds!
- Massive credit to [elifouts](https://github.com/elifouts/dotfiles) — the entire dynamic theming system used here is directly from his setup! His work was a huge inspiration and forms the visual foundation of these dotfiles.

---
*Built for Arch Linux. Scraped together from various community dotfiles, meticulously pieced together, and enhanced with several custom features by Me for Me.*
