#!/bin/bash

choice=$(printf "hyprland\nanimations\nautostart\nenv\ninput\nkeybinds\nlayout\nmisc\nmonitors\nprograms\nvisuals\nwindowrule\nworkspacerules" | rofi -dmenu -p "Hyprland")

case "$choice" in
  hyprland)
    kitty nvim ~/.config/hypr/hyprland.conf
    ;;
  animations)
    kitty nvim ~/dotfiles/hypr/animations.conf
    ;;
  autostart)
    kitty nvim ~/dotfiles/hypr/source/autostart.conf
    ;;
  env)
    kitty nvim ~/dotfiles/hypr/source/env.conf
    ;;
  input)
    kitty nvim ~/dotfiles/hypr/source/input.conf
    ;;
  keybinds)
    kitty nvim ~/dotfiles/hypr/source/keybinds.conf
    ;;
  layout)
    kitty nvim ~/dotfiles/hypr/source/layout.conf
    ;;
  misc)
    kitty nvim ~/dotfiles/hypr/source/misc.conf
    ;;
  monitors)
    kitty nvim ~/dotfiles/hypr/source/monitors.conf
    ;;
  programs)
    kitty nvim ~/dotfiles/hypr/source/programs.conf
    ;;
  visuals)
    kitty nvim ~/dotfiles/hypr/source/visuals.conf
    ;;
  windowrule)
    kitty nvim ~/dotfiles/hypr/source/windowrule.conf
    ;;
  workspacerules)
    kitty nvim ~/dotfiles/hypr/source/workspacerule.conf
    ;;
  *)
    echo "Hi"
esac
  
