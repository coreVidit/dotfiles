#!/bin/bash
# wallpaper_switcher.sh - Optimized Wallust-based switcher

WALLS_DIR="$HOME/wallpapers"

# 1. Select wallpaper using Rofi
# (Note: Using find to get filenames, then passing to rofi for a clean list)
SELECTED_WALL=$(find "$WALLS_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -printf "%f\n" | rofi -dmenu -p "Select Wallpaper" -i)

if [ -n "$SELECTED_WALL" ]; then
    FULL_PATH="$WALLS_DIR/$SELECTED_WALL"
    
    # 2. Run Wallust (This updates ~/.cache/wal/colors.json and everything else)
    wallust run "$FULL_PATH"
    
    # 3. Set wallpaper using awww with the WAVE transition
    if command -v awww >/dev/null 2>&1; then
        awww img "$FULL_PATH" --transition-type wave --transition-duration 0.5
    fi
    
    # 4. Cache the wallpaper for Hyprlock and wlogout
    cp "$FULL_PATH" ~/.cache/current_wallpaper.png

    # 5. Update Firefox (Pywalfox)
    if command -v pywalfox >/dev/null 2>&1; then
        pywalfox update
    fi

    # 6. Reload SwayNC Notifications
    if command -v swaync-client >/dev/null 2>&1; then
        swaync-client --reload-css
    fi

    # 7. Refresh SwayOSD
    if pgrep swayosd-server >/dev/null; then
        pkill swayosd-server
        swayosd-server &
    fi
    
    # 8. Reload Kitty (Touch config to force reload of 'include' file)
    if [ -f ~/.config/kitty/kitty.conf ]; then
        touch ~/.config/kitty/kitty.conf
    fi

    # 9. Optional: Update Cava Visualizer
    CAVA_CONFIG="$HOME/.config/cava/config"
    if [ -f "$CAVA_CONFIG" ] && command -v jq >/dev/null 2>&1; then
        COLOR1=$(jq -r '.colors.color2' ~/.cache/wal/colors.json)
        COLOR2=$(jq -r '.colors.color3' ~/.cache/wal/colors.json)
        sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$COLOR1'/" "$CAVA_CONFIG"
        sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$COLOR2'/" "$CAVA_CONFIG"
        pkill -USR2 cava 2>/dev/null
    fi
    
    echo "Wallpaper and Theme updated successfully!"
fi
