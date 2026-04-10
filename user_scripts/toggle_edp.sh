#!/bin/bash

# Toggle script for eDP-1 display in Hyprland
STATUS=$(hyprctl monitors all -j | jq -r '.[] | select(.name == "eDP-1") | .disabled')

if [ "$STATUS" == "true" ]; then
    # Enabling the monitor. Adjust scale and position as needed.
    hyprctl keyword monitor eDP-1,preferred,auto,1.5
else
    # Disabling the monitor.
    hyprctl keyword monitor eDP-1,disable
fi
