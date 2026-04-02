#!/usr/bin/env bash

# Paths
SOURCE_DIR="$HOME/dotfiles/hypr/source"
ACTIVE_THEME="$SOURCE_DIR/theme_active.conf"
ASILENT_THEME="theme_asilent.conf"
SILENT_THEME="theme_silent.conf"

# Ensure the source directory exists
mkdir -p "$SOURCE_DIR"

# Check current target of the symlink (returns nothing if it doesn't exist)
CURRENT_TARGET=$(readlink "$ACTIVE_THEME")

if [[ "$CURRENT_TARGET" == *"$SILENT_THEME" ]]; then
    # Currently silent, switch to asilent (rice mode)
    ln -sf "$SOURCE_DIR/$ASILENT_THEME" "$ACTIVE_THEME"
    notify-send -t 2000 "Hyprland Mode" "Switched to (Asilent) Rice Mode"
else
    # Currently asilent (or missing), switch to silent (performance mode)
    ln -sf "$SOURCE_DIR/$SILENT_THEME" "$ACTIVE_THEME"
    notify-send -t 2000 "Hyprland Mode" "Switched to (Silent) Performance Mode"
fi

# Reload Hyprland to apply the new active theme override
hyprctl reload
