#!/bin/bash

# --- Configuration ---
INTERNAL="eDP-1"
EXTERNAL="HDMI-A-1"
MONITOR_CONF="$HOME/dotfiles/hypr/source/monitors.conf"
LAST_APPLIED=""

while true; do
    # 1. Atomic Snapshot of the world
    MONITORS=$(hyprctl monitors)
    # head -n1 handles potential ghost lid entries
    LID_STATE=$(awk '{print $2}' /proc/acpi/button/lid/*/state 2>/dev/null | head -n1)
    [ -z "$LID_STATE" ] && LID_STATE="open"

    # 2. Logic Check (UNIX-style 1/0 semantics)
    echo "$MONITORS" | grep -q "$EXTERNAL" && EXT_CONN=1 || EXT_CONN=0
    echo "$MONITORS" | grep -q "$INTERNAL" && INT_ACT=1 || INT_ACT=0

    # 3. Determine Desired State
    if [ "$LID_STATE" = "closed" ] && [ "$EXT_CONN" -eq 1 ]; then
        DESIRED="disabled"
    else
        DESIRED="enabled"
    fi

    # 4. Reconcile only if Actual != Desired AND we haven't already fixed it
    if [ "$DESIRED" != "$LAST_APPLIED" ]; then
        # Check if we actually need to send a command to Hyprland
        if [ "$DESIRED" = "disabled" ] && [ "$INT_ACT" -eq 1 ]; then
            hyprctl keyword monitor "$INTERNAL, disable"
            LAST_APPLIED="disabled"
        elif [ "$DESIRED" = "enabled" ] && [ "$INT_ACT" -eq 0 ]; then
            hyprctl keyword source "$MONITOR_CONF"
            LAST_APPLIED="enabled"
        fi
    fi

    sleep 2
done
