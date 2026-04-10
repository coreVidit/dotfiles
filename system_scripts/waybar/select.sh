#!/bin/bash
WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config"
ASSETS="$WAYBAR_DIR/assets"
THEMES="$WAYBAR_DIR/themes"
menu() {
    find "${ASSETS}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \)
}
main() {
    choice=$(menu | vicinae dmenu -p "  Select Waybar (Scroll with Arrows)")
    [ -z "$choice" ] && exit
    
    selected_name=$(basename "$choice" .png)
    
    case "$selected_name" in
        "main")     theme="default" ;;
        "line")     theme="line" ;;
        "zen")      theme="zen" ;;
        "experimental") theme="experimental" ;;
        *)          echo "Unknown theme: $selected_name"; exit 1 ;;
    esac

    echo "Applying $theme theme..."
    cat "$THEMES/$theme/style-${theme/default/default}.css" > "$STYLECSS"
    cat "$THEMES/$theme/config-${theme/default/default}" > "$CONFIG"
    
    pkill waybar
    waybar &

}
main
