#!/bin/bash

choice=$(printf "hyprland\nhyprlock\nrofi\nwaybar" | rofi -dmenu -p "Edit config")

case "$choice" in
  hyprland)
    ~/user_scripts/hyprland_config_select.sh;;
  hyprlock)
    kitty nvim ~/dotfiles/hypr/hyprlock.conf;;
  waybar)
    ~/user_scripts/waybar_config_select.sh;;
  rofi)
    ~/user_scripts/rofi_config_select.sh;;
  *)
    exit
    ;;
esac
