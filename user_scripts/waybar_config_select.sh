#!/bin/bash
choice=$(printf "config\nstyle" | rofi -dmenu -p "Waybar-")

case "$choice" in
  config) 
    choice2=$(printf "main\nline\nzen\nexperimental" | rofi -dmenu -p "Configs")
    case "$choice2" in
      main)
        kitty nvim ~/dotfiles/waybar/themes/default/config-default;;
      line)
        kitty nvim ~/dotfiles/waybar/themes/line/config-line;;
      zen)
        kitty nvim ~/dotfiles/waybar/themes/zen/config-zen;;
      experimental)
        kitty nvim ~/dotfiles/waybar/themes/experimental/config-experimental;;
    esac;;  
  style)
    choice3=$(printf "main\nline\nzen\nexperimental" | rofi -dmenu -p "Styles")
    case "$choice3" in
      main)
        kitty nvim ~/dotfiles/waybar/themes/default/style-default.css;;
      line)
        kitty nvim ~/dotfiles/waybar/themes/line/style-line.css;;
      zen)
        kitty nvim ~/dotfiles/waybar/themes/zen/style-zen.css;;
      experimental)
        kitty nvim ~/dotfiles/waybar/themes/experimental/style-experimental.css;;
    esac
esac

