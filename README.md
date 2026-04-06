# dotfiles
My personal Hyprland rice on Arch Linux. Tailored for productivity, aesthetics, and workflow efficiency.

> [!CAUTION]
> **COMPATIBILITY**: Designed specifically for **Arch Linux** and Arch-based distributions.
> **WARNING**: The `install.sh` script is non-destructive for folders (it creates `.bak` backups), but it will replace existing configurations in `~/.config/` with symlinks. Use with care on established systems.

---

## 🛠️ Highlights
- **Modular Config**: Hyprland settings split into logically named components.
- **Dynamic Theming**: Powered by `pywal`. Colors follow your wallpaper across all apps.
- **Native Scratchpads**: Uses native Hyprland special workspaces instead of external daemons.
- **Intelligent Installer**: Handles dependencies, AUR helpers, and symlinking automatically.

---

## 📂 Repository Structure

| Folder | Description |
|---|---|
| `hypr/` | Hyprland, Hyprlock, and Hypridle configurations |
| `waybar/` | Status bar with multiple switchable themes |
| `user_scripts/` | Custom utility scripts (Brightness, OCR, Lens, etc.) |
| `wayclick/` | Mechanical keyboard sound emulator |
| `fish/` & `kitty/` | Shell and Terminal environments |
| `rofi/` & `swaync/` | Launcher and Notification Center |

---

## 🚀 Installation

### 1. Clone the repository
```bash
git clone https://github.com/coreVidit/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 2. Run the installer
```bash
bash install.sh
```

**The installer will:**
1. Check if you are on an Arch-based system.
2. **Bootstrap an AUR helper** (`paru` or `yay`) if you don't have one.
3. Install all required system and AUR dependencies.
4. Back up your existing `~/.config/` folders to `[folder].bak`.
5. Create symlinks for all configurations.

---

## 🏁 Post-Installation

**1. WayClick First Run**  
Run the script once in a terminal to build the Python environment and audio dependencies:
```bash
~/user_scripts/wayclick/dusky_wayclick.sh
```
After this, use **Alt+U** to toggle keyboard sounds.

**2. Generate Global Theme**  
Open the wallpaper picker and select an image to generate your first color palette. **Waybar may fail to start or look broken until you do this step**, as it depends on pywal colors in `~/.cache/wal/`.
- **Keys**: `Alt + W`

**3. Permissions**  
If WayClick or Brightness controls fail, ensure your user is in the correct groups:
```bash
sudo usermod -aG input,video,i2c $USER
```
*(Logout and back in required)*

---

## ⌨️ Common Keybinds

| Action | Keys |
|---|---|
| **Terminal** | `Super + Q` |
| **App Launcher** | `Alt + Space` |
| **Kill Window** | `Super + X` |
| **Lock Screen** | `Super + M` |
| **Wallpaper Picker** | `Alt + W` |
| **Waybar Theme** | `Alt + B` |
| **Google Lens** | `Alt + I` |
| **OCR to Clipboard** | `Alt + T` |
| **Toggle Trackpad** | `Alt + P` |
| **Toggle WayClick** | `Alt + U` |

*See `hypr/source/keybinds.conf` for the full list.*
