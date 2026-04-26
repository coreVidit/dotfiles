#!/usr/bin/env bash
# =============================================================================
# toggle_mode.sh — Hyprland System Profile Cycler
# =============================================================================
# Profiles:
#   Asilent (Rice)   : Everything is ON (Waybar, SwayNC, Wallpaper, Visuals)
#   Silent (Gaming)  : Waybar OFF, SwayNC DND ON, Wallpaper OFF, Visuals OFF
#   Void (Minimal)   : Waybar OFF, SwayNC OFF, Wallpaper OFF, Visuals OFF
# =============================================================================

set -euo pipefail

ACTIVE_LINK="$HOME/.config/hypr/source/theme_active.conf"
THEMES_DIR="$HOME/dotfiles/hypr/source"

# We strictly order our 3 modes.
PROFILES=("asilent" "silent" "void")

apply_profile() {
    local profile="$1"
    local theme_file="$THEMES_DIR/theme_${profile}.conf"

    if [[ ! -f "$theme_file" ]]; then
        # Use hyprctl notify as fallback if swaync is dead
        hyprctl notify 3 3000 "rgb(ff0000)" "Profile Error: Missing $theme_file"
        exit 1
    fi

    # Link the theme
    ln -sf "$theme_file" "$ACTIVE_LINK"

    # Manage services based on profile
    case "$profile" in
        asilent)
            # 1. Wallpaper
            (pgrep -x awww-daemon >/dev/null || awww-daemon &>/dev/null &
            sleep 0.5 && awww restore &>/dev/null || true) &
            
            # 2. Status Bar
            # Stop Void waybar if running, then start default
            (if pgrep -f "waybar -c.*/void/" >/dev/null; then
                pkill -f "waybar -c.*/void/" || true
                sleep 0.2
            fi
            pgrep -x waybar >/dev/null || waybar &>/dev/null &) &
            
            # 3. Notifications
            (pgrep -x swaync >/dev/null || swaync &>/dev/null &
            sleep 0.5 && swaync-client -df &>/dev/null || true) &  # DND off
            
            # 4. App Theming

            
            # Restore Pywal (awww restore usually does this, but wal -R acts as a fallback)
            (wal -R -q 2>/dev/null || true
            cp ~/.cache/wal/colors-kitty.conf ~/.config/kitty/current-theme.conf 2>/dev/null || true) &
            
            # 5. Power Management
            pgrep -x hypridle >/dev/null || hypridle &>/dev/null &
            
            notify-send -t 2000 "System Profile" "Switched to Asilent (Rice Mode)" || true
            hyprctl notify 1 2000 "rgb(a6adc8)" "Profile: Asilent (Rice Mode)"
            ;;
            
        silent)
            # 1. Kill Wallpaper (saves VRAM)
            pkill -x awww || true
            pkill -x awww-daemon || true
            
            # 2. Kill Status Bar
            pkill waybar || true
            pkill -f "waybar -c.*/void/" || true
            
            # 3. Notifications (Keep alive, but DND ON)
            (pgrep -x swaync >/dev/null || swaync &>/dev/null &
            sleep 0.5 && swaync-client -dn &>/dev/null || true) &  # DND on
            
            # 4. App Theming (Minimal Pywal)
            (wal -q --theme base16-grayscale 2>/dev/null || true
            cp ~/.cache/wal/colors-kitty.conf ~/.config/kitty/current-theme.conf 2>/dev/null || true) &
            
            # 5. Power Management (Prevent screen sleep while gaming)
            pkill -x hypridle || true
            
            # notify-send gets swallowed by DND, so hyprctl notify is required here
            hyprctl notify 1 2000 "rgb(a6adc8)" "Profile: Silent (Gaming Mode)"
            ;;
            
        void)
            # 1. Kill Wallpaper
            pkill -x awww || true
            pkill -x awww-daemon || true
            
            # 2. Minimal Status Bar (Void config)
            pkill waybar || true
            pkill -f "waybar -c.*/void/" || true
            waybar -c "$HOME/.config/waybar/themes/void/config-void" -s "$HOME/.config/waybar/themes/void/style-void.css" &>/dev/null &
            
            # 3. Kill Notifications completely
            pkill -x swaync || true
            
            # 4. App Theming (Minimal Pywal)
            (wal -q --theme base16-grayscale 2>/dev/null || true
            cp ~/.cache/wal/colors-kitty.conf ~/.config/kitty/current-theme.conf 2>/dev/null || true) &
            
            # 5. Power Management (Prevent screen sleep)
            pkill -x hypridle || true
            
            # Swaync is dead, only hyprctl notify works
            hyprctl notify 1 2000 "rgb(a6adc8)" "Profile: Void (Minimal Mode)"
            ;;
            
        *)
            hyprctl notify 1 2000 "rgb(a6adc8)" "Profile: ${profile^}"
            ;;
    esac

    # Reload Hyprland visual config
    hyprctl reload &>/dev/null || true
}

# --- Handle --list ---
if [[ "${1:-}" == "--list" ]]; then
    echo "Available profiles: ${PROFILES[*]}"
    exit 0
fi

# --- Handle --set <name> ---
if [[ "${1:-}" == "--set" ]]; then
    target_name="${2:-}"
    apply_profile "$target_name"
    exit 0
fi

# --- Default: cycle to next profile ---
CURRENT=$(readlink "$ACTIVE_LINK" 2>/dev/null || echo "")
current_base=$(basename "$CURRENT" .conf 2>/dev/null || echo "")
current_profile="${current_base#theme_}"

current_idx=-1
for i in "${!PROFILES[@]}"; do
    if [[ "${PROFILES[$i]}" == "$current_profile" ]]; then
        current_idx=$i
        break
    fi
done

# Next profile (wraps around)
next_idx=$(( (current_idx + 1) % ${#PROFILES[@]} ))
apply_profile "${PROFILES[$next_idx]}"
