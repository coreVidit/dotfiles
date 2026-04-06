#!/bin/bash
WALLPAPER_DIR="$HOME/wallpapers/"
#I dont know what the fuck I am doing
menu() {
    find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}
main() {
    choice=$(menu | rofi -dmenu -p "Select Wallpaper:" -n)
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    awww img "$selected_wallpaper" --transition-type grow --transition-fps 60 --transition-duration .3
    wal -i "$selected_wallpaper" -n --cols16
    pkill swayosd-server
    swayosd-server &
    swaync-client --reload-css
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
    pywalfox update
    color1=$(awk 'match($0, /color2=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    color2=$(awk 'match($0, /color3=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    cava_config="$HOME/.config/cava/config"
    sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$cava_config"
    sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$cava_config"
    source ~/.cache/wal/colors.sh && cp -r "$wallpaper" ~/wallpapers/pywallpaper.jpg 
}
main

