#!/usr/bin/env bash
# =============================================================================
# 📦 ARCH DOTFILES INSTALLER (coreVidit)
# =============================================================================
# Target: Arch Linux & Arch-based distributions
# WARNING: This script will move existing configs in ~/.config to [folder].bak
# =============================================================================

set -euo pipefail

# Auto-detect the dotfiles directory even if cloned elsewhere
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# 🛑 1. SYSTEM CHECK
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ "$ID" != "arch" ]] && [[ "${ID_LIKE:-}" != *"arch"* ]]; then
        echo "❌ ERROR: This script is designed for Arch Linux or Arch-based distros only."
        exit 1
    fi
else
    echo "❌ ERROR: /etc/os-release not found. Unknown distribution."
    exit 1
fi

echo "======================================="
echo "🔥 STARTING INSTALLATION"
echo "======================================="
echo "⚠️  Existing configs in ~/.config will be backed up as .bak"
echo "───────────────────────────────────────"

# 📦 2. AUR HELPER DETECTION / INSTALLATION
detect_aur_helper() {
    if command -v paru &>/dev/null; then
        echo "paru"
    elif command -v yay &>/dev/null; then
        echo "yay"
    else
        echo ""
    fi
}

AUR_HELPER=$(detect_aur_helper)

if [[ -z "$AUR_HELPER" ]]; then
    echo ""
    echo "📦 No AUR helper found (paru or yay)."
    echo "   Which one would you like to install?"
    PS3="Please enter your choice (1-3): "
    options=("paru" "yay" "Skip AUR installation")
    select opt in "${options[@]}"; do
        case $opt in
            "paru"|"yay")
                echo "🚀 Installing $opt..."
                sudo pacman -S --needed --noconfirm base-devel git
                # Ensure /tmp/ is clean
                rm -rf "/tmp/$opt"
                git clone "https://aur.archlinux.org/$opt.git" "/tmp/$opt"
                (cd "/tmp/$opt" && makepkg -si --noconfirm)
                AUR_HELPER="$opt"
                break
                ;;
            "Skip AUR installation")
                echo "⏭️  Skipping AUR setup. AUR packages will not be installed."
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
fi

# =============================================================================
# DEPENDENCY LISTS
# =============================================================================

# --- Pacman packages ---
PACMAN_DEPS=(
    "hyprland" "hyprlock" "hypridle" "hyprpicker" "uwsm" "xdg-desktop-portal-hyprland"
    "waybar" "swaync" "kitty" "fish" "starship" "neovim" "rofi" "wlogout"
    "yazi" "nemo" "pipewire" "pipewire-pulse" "pipewire-audio" "wireplumber"
    "playerctl" "pulsemixer" "pavucontrol" "grim" "slurp" "swappy" "wl-clipboard"
    "blueman" "networkmanager" "python-pywal" "cava" "ddcutil" "tesseract"
    "tesseract-data-eng" "imagemagick" "jq" "curl" "xdg-utils" "libnotify"
    "pacman-contrib" "htop" "uv" "otf-hermit-nerd" "noto-fonts-emoji"
)

# --- AUR packages ---
AUR_DEPS=(
    "swayosd-git"           # On-screen display
    "awww"                  # Wallpaper daemon
    "bibata-cursor-theme"   # Cursors
    "hyprpolkit"            # Polkit
    "python-pywalfox"       # Browser theming
    "otf-codenewroman-nerd" # Main Font
)

# =============================================================================
# INSTALLATION
# =============================================================================

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
        echo "🚀 Installing: ${MISSING_AUR[*]}"
        "$AUR_HELPER" -S --needed --noconfirm "${MISSING_AUR[@]}"
    fi
fi

# =============================================================================
# SYMLINKING
# =============================================================================

echo ""
echo "───────────────────────────────────────"
echo "🔗 Setting up symlinks..."

shopt -s dotglob
for item in "$DOTFILES_DIR"/*; do
    basename=$(basename "$item")

    if [[ "$basename" == "install.sh" ]] || \
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
    
    # Improved Backup Logic: Handle real files and real directories
    if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        if [ ! -L "$TARGET" ]; then
            echo "    📦 Backing up: $basename -> ${basename}.bak"
            mv "$TARGET" "${TARGET}.bak"
        else
            # Existing symlink: just remove it so we can create a new one
            rm "$TARGET"
        fi
    fi

    mkdir -p "$(dirname "$TARGET")"
    echo "    🔗 Linking: $item -> $TARGET"
    ln -sf "$item" "$TARGET"
done
shopt -u dotglob

# Separate handling for ~/user_scripts
USER_SCRIPTS_TARGET="$HOME/user_scripts"
if [ -e "$USER_SCRIPTS_TARGET" ] || [ -L "$USER_SCRIPTS_TARGET" ]; then
    if [ ! -L "$USER_SCRIPTS_TARGET" ]; then
        echo "    📦 Backing up: ~/user_scripts -> ~/user_scripts.bak"
        mv "$USER_SCRIPTS_TARGET" "${USER_SCRIPTS_TARGET}.bak"
    else
        rm "$USER_SCRIPTS_TARGET"
    fi
fi
echo "    🔗 Linking: $DOTFILES_DIR/user_scripts -> $USER_SCRIPTS_TARGET"
ln -sf "$DOTFILES_DIR/user_scripts" "$USER_SCRIPTS_TARGET"

# =============================================================================
# 🖼️ INITIAL WALLPAPER & THEME (Run only if no theme exists)
# =============================================================================

echo ""
echo "───────────────────────────────────────"
echo "🖼️  Checking initial wallpaper..."

WALLPAPER_DIR="$HOME/wallpapers"
[ ! -d "$WALLPAPER_DIR" ] && mkdir -p "$WALLPAPER_DIR"

if [ -f "$DOTFILES_DIR/desktop.jpg" ] && [ ! -f "$HOME/.cache/wal/colors.sh" ]; then
    echo "    📸 No existing theme found. Setting up default wallpaper..."
    cp "$DOTFILES_DIR/desktop.jpg" "$WALLPAPER_DIR/desktop.jpg"
    
    # Try to set the wallpaper and generate colors if the daemon is running
    if command -v awww &>/dev/null && command -v wal &>/dev/null; then
        echo "    🎨 Generating initial color palette (pywal)..."
        # We start the daemon if it's not running
        if ! pgrep -x "swww-daemon" &>/dev/null && ! pgrep -x "awww" &>/dev/null; then
            awww &>/dev/null & 
            sleep 1
        fi
        awww img "$WALLPAPER_DIR/desktop.jpg" --transition-type grow &>/dev/null || true
        wal -i "$WALLPAPER_DIR/desktop.jpg" -n --cols16 &>/dev/null || true
        
        # 🔄 Reload components to apply the new theme immediately
        echo "    🔄 Reloading components..."
        [ -f "$HOME/.cache/wal/colors-kitty.conf" ] && cat "$HOME/.cache/wal/colors-kitty.conf" > "$HOME/.config/kitty/current-theme.conf"
        command -v swaync-client &>/dev/null && swaync-client --reload-css &>/dev/null || true
        command -v pywalfox &>/dev/null && pywalfox update &>/dev/null || true
        if pgrep -x "swayosd-server" &>/dev/null; then
            pkill swayosd-server && swayosd-server &>/dev/null &
        fi
    fi
elif [ -f "$DOTFILES_DIR/desktop.jpg" ] && [ ! -f "$WALLPAPER_DIR/desktop.jpg" ]; then
    echo "    📸 Copying default wallpaper to $WALLPAPER_DIR (skipping theme setup)..."
    cp "$DOTFILES_DIR/desktop.jpg" "$WALLPAPER_DIR/desktop.jpg"
else
    echo "    ✅ Existing theme found or no default wallpaper. Skipping initial setup."
fi

echo ""
echo "======================================="
echo "✅ INSTALLATION COMPLETE! 🎉"
echo "======================================="
echo "1. Log out/in for group & cursor changes."
echo "2. Run base wayclick setup: ~/user_scripts/wayclick/dusky_wayclick.sh"
echo "3. Your initial wallpaper and colors are set! Use Alt+W to change them later."
echo ""
