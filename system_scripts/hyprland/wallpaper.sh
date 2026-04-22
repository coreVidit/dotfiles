#!/bin/bash
WALLPAPER_DIR="$HOME/wallpapers/"
#I dont know what the fuck I am doing
menu() {
    find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \)
}
main() {
    choice=$(vicinae close || menu | vicinae dmenu -p "Select Wallpaper:" )
    selected_wallpaper=$(echo "$choice")
    [ -z "$selected_wallpaper" ] && exit
    awww img "$selected_wallpaper" --transition-type grow --transition-fps 60 --transition-duration .3
    wal -i "$selected_wallpaper" -n --cols16
	pkill waybar
    swaync-client --reload-css
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
    pywalfox update
    waybar &
    color1=$(awk 'match($0, /color2=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    color2=$(awk 'match($0, /color3=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    source ~/.cache/wal/colors.sh && cp -r "$wallpaper" ~/wallpapers/pywallpaper.jpg
    
}
main

