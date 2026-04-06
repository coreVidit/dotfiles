#!/bin/bash

choice=$(printf "rofi\nfrosted-Glass" | rofi -dmenu -p "Rofi")

case "$choice" in
  rofi) 
    kitty nvim ~/dotfiles/rofi/config.rasi
  ;;
  frosted-Glass)
    kitty nvim ~/dotfiles/rofi/themes/frosted-glass.rasi
  ;;
  *)
    echo "Hi"
  ;;
esac

