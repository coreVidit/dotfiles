#!/usr/bin/env bash

CONFIG_FILE="$HOME/dotfiles/hypr/source/keybinds.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Keybinds file not found at $CONFIG_FILE"
    exit 1
fi

# Parse the keybinds using awk and format them nicely
keybinds=$(awk -F',' '
/^bind[a-z]*\s*=/ {
    # Extract the exact bind command (e.g., bind, binde, bindd, binded)
    match($0, /^bind[a-z]*/)
    bind_type = substr($0, RSTART, RLENGTH)
    
    # Remove the bind= part
    sub(/^bind[a-z]*\s*=\s*/, "", $0)
    
    mods=$1
    key=$2
    
    # If the bind type ends with "d", it contains a description
    has_desc = (bind_type ~ /d$/)
    
    if (has_desc) {
        desc=$3
        action=$4
        start_idx=5
    } else {
        desc=""
        action=$3
        start_idx=4
    }
    
    # Recreate the rest of the string for the command
    cmd=""
    for(i=start_idx; i<=NF; i++) {
        cmd = cmd $i (i==NF ? "" : ",")
    }
    
    # Clean up leading/trailing whitespace
    gsub(/^[ \t]+|[ \t]+$/, "", mods)
    gsub(/^[ \t]+|[ \t]+$/, "", key)
    gsub(/^[ \t]+|[ \t]+$/, "", action)
    gsub(/^[ \t]+|[ \t]+$/, "", cmd)
    gsub(/^[ \t]+|[ \t]+$/, "", desc)
    
    # Replace $mainMod with SUPER for readability
    gsub(/\$mainMod/, "SUPER", mods)
    
    # Determine what to display (Description if it exists, otherwise the raw command)
    if (desc != "") {
        display_text = desc
    } else {
        if (cmd == "") {
            display_text = action
        } else {
            display_text = action " " cmd
        }
    }
    
    # Only print valid keybinds
    if (key != "") {
        if (mods == "" || mods == "NONE") {
            kb = "[" key "]"
        } else {
            kb = "[" mods " + " key "]"
        }
        # Pad the description with spaces, then add a tab to push it to a tab-stop
        printf "%-35s\t%s\n", display_text, kb
    }
}
' "$CONFIG_FILE")

# Ensure vicinae is closed before opening a new one to prevent stacking
vicinae close || true

# Pass the parsed keybinds into vicinae dmenu
echo "$keybinds" | vicinae dmenu -p "⌨️  Keybinds:"
