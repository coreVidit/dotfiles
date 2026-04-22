#!/usr/bin/env bash
# =============================================================================
# 📦 ARCH DOTFILES INSTALLER (coreVidit)
# =============================================================================
# Target: Arch Linux & Arch-based distributions
# WARNING: This script will back up existing configs in ~/.config with timestamps.
# =============================================================================

set -euo pipefail

# Auto-detect the dotfiles directory even if cloned elsewhere
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# --- Helper Functions ---
detect_aur_helper() {
    if command -v paru &>/dev/null; then
        echo "paru"
    elif command -v yay &>/dev/null; then
        echo "yay"
    else
        echo ""
    fi
}

# 🛑STAGE 0: PRE-FLIGHT CHECK
echo "======================================="
echo "🔍 STAGE 0: Pre-Flight Check"
echo "======================================="

# Checking for Snapper (Ultimate Undo Button)
if command -v snapper &>/dev/null; then
    echo "💾 Snapper detected! (Btrfs Snapshot Support)"
    echo "   Would you like to create a pre-installation snapshot?"
    echo "   (Recommended for fresh installations as a safe restore point)"
    read -p "   Create snapshot? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Creating snapshot..."
        sudo snapper create --description "Before coreVidit dotfiles installation" || echo "⚠️  Failed to create snapshot, proceeding anyway..."
    else
        echo "⏭ Skipping snapshot."
    fi
fi

if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ "$ID" != "arch" ]] && [[ "${ID_LIKE:-}" != *"arch"* ]]; then
        echo "❌ ERROR: This script is only for Arch-based distros. Detected: $ID"
        exit 1
    fi
    echo "✅ OS Check Passed: $PRETTY_NAME"
else
    echo "❌ ERROR: /etc/os-release not found. Unknown distribution."
    exit 1
fi

# 🚀 Speed up Pacman (Performance Hack)
echo "⚡ Optimizing Pacman (Parallel Downloads & Color)..."
if grep -q "^#ParallelDownloads" /etc/pacman.conf; then
    sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
fi
if grep -q "^#Color" /etc/pacman.conf; then
    sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
fi
grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

echo "⚡ Checking for Chaotic AUR (Pre-compiled AUR packages for faster install)..."
if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    echo "   Chaotic AUR not found. Would you like to add it to speed up AUR package installation?"
    read -p "   Add Chaotic AUR? (Y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo "Installing Chaotic AUR keyring and mirrorlist..."
        sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com || \
        sudo pacman-key --recv-key 3056513887B78AEB --keyserver keys.openpgp.org || \
        sudo pacman-key --recv-key 3056513887B78AEB --keyserver hkps://keyserver.ubuntu.com
        sudo pacman-key --lsign-key 3056513887B78AEB
        sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
        sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
        
        echo "Appending to /etc/pacman.conf..."
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
        sudo pacman -Sy
        echo "✅ Chaotic AUR configured."
    else
        echo "⏭️  Skipping Chaotic AUR."
    fi
else
    echo "✅ Chaotic AUR is already configured."
fi

echo "======================================="
echo "🔥 STARTING INSTALLATION"
echo "======================================="
echo "⚠️  Existing configs in ~/.config will be backed up with timestamps."
echo "───────────────────────────────────────"

# 📦 STAGE 1: AUR HELPER & DEPENDENCIES
echo ""
echo "======================================="
echo "📦 STAGE 1: AUR Helper & Dependencies"
echo "======================================="

AUR_HELPER=$(detect_aur_helper)

if [[ -z "$AUR_HELPER" ]]; then
    echo "🔎 No AUR helper detected (paru or yay)."
    echo "   Would you like to install one now?"
    PS3="Please enter your choice (1-3): "
    options=("paru" "yay" "Skip AUR installation")
    select opt in "${options[@]}"; do
        case $opt in
            "paru"|"yay")
                echo "🚀 Installing $opt..."
                sudo pacman -S --needed --noconfirm base-devel git
                rm -rf "/tmp/$opt"
                git clone "https://aur.archlinux.org/$opt.git" "/tmp/$opt"
                (cd "/tmp/$opt" && makepkg -si --noconfirm)
                AUR_HELPER="$opt"
                break
                ;;
            "Skip AUR installation")
                echo "⏭️  Skipping AUR setup. (AUR packages will not be installed)"
                AUR_HELPER=""
                break
                ;;
            *) echo "❌ Invalid option $REPLY";;
        esac
    done
else
    echo "✅ AUR Helper detected: $AUR_HELPER"
fi

# Dependency Lists
PACMAN_DEPS=(
    "hyprland" "hyprlock" "hypridle" "hyprpicker" "uwsm" "xdg-desktop-portal-hyprland"
    "waybar" "swaync" "kitty" "fish" "starship" "neovim" "yazi" "nemo" "pipewire" 
    "pipewire-pulse" "pipewire-audio" "wireplumber" "playerctl" "pulsemixer" 
    "pavucontrol" "grim" "slurp" "swappy" "wl-clipboard" "blueman" "networkmanager" 
     "ddcutil" "tesseract" "tesseract-data-eng" "imagemagick" 
    "jq" "curl" "xdg-utils" "libnotify" "pacman-contrib" "htop" "uv" "otf-hermit-nerd" 
    "noto-fonts-emoji" "eza" "imv" "zathura" "zathura-pdf-poppler"
)

AUR_DEPS=(
    "swayosd"               # On-screen display
    "awww"                  # Wallpaper daemon
    "bibata-cursor-theme"   # Cursors
    "hyprpolkitagent"       # Polkit
    "python-pywal16"        # Pywal16
    "python-pywalfox"       # Browser theming
    "otf-codenewroman-nerd" # Main Font
    "wlogout"               # Logout menu
    "vicinae"               # App Launcher
    "spotify-launcher"      # Spotify
    "spicetify"             # Spicetify
)

echo ""
echo "───────────────────────────────────────"
echo "📦 Checking system packages..."
MISSING_PACMAN=()
for pkg in "${PACMAN_DEPS[@]}"; do
    if ! pacman -Qq "$pkg" &>/dev/null; then
        MISSING_PACMAN+=("$pkg")
    fi
done

if (( ${#MISSING_PACMAN[@]} > 0 )); then
    echo "🚀 Installing: ${MISSING_PACMAN[*]}"
    sudo pacman -S --needed --noconfirm "${MISSING_PACMAN[@]}"
fi

if [[ -n "$AUR_HELPER" ]]; then
    echo ""
    echo "───────────────────────────────────────"
    echo "📦 Checking AUR packages via $AUR_HELPER..."
    MISSING_AUR=()
    for pkg in "${AUR_DEPS[@]}"; do
        if ! pacman -Qq "$pkg" &>/dev/null; then
            MISSING_AUR+=("$pkg")
        fi
    done
    if (( ${#MISSING_AUR[@]} > 0 )); then
        echo "🚀 Installing AUR dependencies: ${MISSING_AUR[*]}"
        "$AUR_HELPER" -S --needed --noconfirm "${MISSING_AUR[@]}"
    fi
fi

# ⚙️ STAGE 2: SYSTEM CONFIGURATION
echo ""
echo "======================================="
echo "⚙️  STAGE 2: System Configuration"
echo "======================================="

# User Groups
echo "👥 Checking user groups (input, video, i2c)..."
MISSING_GROUPS=()
for grp in input video i2c; do
    if ! id -nG "$USER" | grep -qw "$grp"; then
        MISSING_GROUPS+=("$grp")
    fi
done

if (( ${#MISSING_GROUPS[@]} > 0 )); then
    echo "👥 Adding user to missing groups: ${MISSING_GROUPS[*]}..."
    for grp in "${MISSING_GROUPS[@]}"; do
        getent group "$grp" >/dev/null || sudo groupadd "$grp"
        sudo usermod -aG "$grp" "$USER"
    done
else
    echo "✅ User is already in all required groups."
fi

# i2c Hardening (for DDC/Brightness Control)
if [ ! -f /etc/modules-load.d/i2c.conf ]; then
    echo "💾 Enabling i2c-dev module auto-load..."
    echo "i2c-dev" | sudo tee /etc/modules-load.d/i2c.conf > /dev/null
else
    echo "✅ i2c-dev module auto-load is already configured."
fi

# Default Shell
FISH_PATH=$(which fish 2>/dev/null || echo "/usr/bin/fish")
if [[ "$SHELL" != *"/fish" ]]; then
    echo "🐟 Changing default shell to Fish..."
    if ! grep -qx "$FISH_PATH" /etc/shells; then
        echo "📝 Adding $FISH_PATH to /etc/shells..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
    fi
    chsh -s "$FISH_PATH" || echo "⚠️  Failed to change shell. Manual action: chsh -s $FISH_PATH"
else
    echo "✅ Shell is already Fish."
fi

# 🔗 STAGE 3: HARDENED SYMLINKS & BACKUPS
echo ""
echo "======================================="
echo "🔗 STAGE 3: Hardened Symlinks & Backups"
echo "======================================="

shopt -s dotglob
for item in "$DOTFILES_DIR"/*; do
    basename=$(basename "$item")

    # Filter out script itself and other meta files
    if [[ "$basename" == "install.sh" ]] || \
       [[ "$basename" == "." ]] || \
       [[ "$basename" == ".." ]] || \
       [[ "$basename" == "README.md" ]] || \
       [[ "$basename" == ".git" ]] || \
       [[ "$basename" == "user_scripts" ]] || \
       [[ "$basename" == "LICENSE" ]] || \
       [[ "$basename" == "desktop.jpg" ]]; then
        continue
    fi

    # Determine if it belongs in ~/.config or ~/ root
    if [[ "$basename" == .* ]]; then
        TARGET="$HOME/$basename"
    else
        TARGET="$CONFIG_DIR/$basename"
    fi
    
    # Backup logic with timestamps to prevent overwrites
    if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        if [ ! -L "$TARGET" ]; then
            TIMESTAMP=$(date +%Y%m%d_%H%M%S)
            echo "    📦 Backing up: $basename -> ${basename}.bak.$TIMESTAMP"
            mv "$TARGET" "${TARGET}.bak.$TIMESTAMP"
        else
            # Existing symlink: just remove it
            rm "$TARGET"
        fi
    fi

    mkdir -p "$(dirname "$TARGET")"
    echo "    🔗 Linking: $item -> $TARGET"
    ln -sf "$item" "$TARGET"
done
shopt -u dotglob

# Handle user_scripts separately
USER_SCRIPTS_TARGET="$HOME/user_scripts"
if [ -e "$USER_SCRIPTS_TARGET" ] || [ -L "$USER_SCRIPTS_TARGET" ]; then
    if [ ! -L "$USER_SCRIPTS_TARGET" ]; then
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        echo "    📦 Backing up: ~/user_scripts -> ~/user_scripts.bak.$TIMESTAMP"
        mv "$USER_SCRIPTS_TARGET" "${USER_SCRIPTS_TARGET}.bak.$TIMESTAMP"
    else
        rm "$USER_SCRIPTS_TARGET"
    fi
fi
echo "    🔗 Linking: $DOTFILES_DIR/user_scripts -> $USER_SCRIPTS_TARGET"
ln -sf "$DOTFILES_DIR/user_scripts" "$USER_SCRIPTS_TARGET"

# 🔑 STAGE 4: PERMISSIONS & DEFAULTS
echo ""
echo "======================================="
echo "🔑 STAGE 4: Permissions & Defaults"
echo "======================================="

echo "🔓 Automating script permissions (recursively)..."
find "$DOTFILES_DIR" -name "*.sh" -exec chmod +x {} +

# Default theme mode: Rice Mode (asilent)
if [[ ! -L "$CONFIG_DIR/hypr/source/theme_active.conf" ]]; then
    echo "🎨 Setting 'Asilent' (Rice Mode) as the initial theme..."
    mkdir -p "$CONFIG_DIR/hypr/source"
    ln -sf "$DOTFILES_DIR/hypr/source/theme_asilent.conf" "$CONFIG_DIR/hypr/source/theme_active.conf"
fi

# 🖼️ STAGE 5: THEME INITIALIZATION
echo ""
echo "======================================="
echo "🖼️  STAGE 5: Theme Initialization"
echo "======================================="

WALLPAPER_DIR="$HOME/wallpapers"
[ ! -d "$WALLPAPER_DIR" ] && mkdir -p "$WALLPAPER_DIR"

if [ -f "$DOTFILES_DIR/desktop.jpg" ] && [ ! -f "$HOME/.cache/wal/colors.sh" ]; then
    echo "📸 Fresh install detected. Setting up initial wallpaper/colors..."
    cp "$DOTFILES_DIR/desktop.jpg" "$WALLPAPER_DIR/desktop.jpg"
    
    if command -v awww &>/dev/null && command -v wal &>/dev/null; then
        echo "🎨 Generating colors (pywal)..."
        pgrep -x "awww-daemon" &>/dev/null || awww-daemon &>/dev/null & 
        sleep 1
        awww img "$WALLPAPER_DIR/desktop.jpg" --transition-type grow &>/dev/null || true
        wal -i "$WALLPAPER_DIR/desktop.jpg" -n --cols16 &>/dev/null || true
        
        echo "🔄 Reloading components..."
        [ -f "$HOME/.cache/wal/colors-kitty.conf" ] && cat "$HOME/.cache/wal/colors-kitty.conf" > "$HOME/.config/kitty/current-theme.conf"
        command -v swaync-client &>/dev/null && swaync-client --reload-css &>/dev/null || true
        command -v pywalfox &>/dev/null && pywalfox update &>/dev/null || true
        pkill swayosd-server || true
        swayosd-server &>/dev/null &
    fi
else
    echo "✅ Theme/Wallpaper already exists or desktop.jpg is missing. Skipping initial setup."
fi

# 🎉 STAGE 6: FINALE
echo ""
echo "======================================="
echo "🎉 STAGE 6: FINALE"
echo "======================================="
echo "✅ INSTALLATION COMPLETE!"
echo ""
echo "🚀 NEXT STEPS:"
echo "1. Please reboot your system (Crucial for shell,kernel module and group changes!)."
echo "2. After reboot run ~/user_scripts/wayclick/dusky_wayclick.sh --setup once in a terminal to finish Python setup."
echo "3. Use Alt+W to swap wallpapers and verify themes."
echo ""
