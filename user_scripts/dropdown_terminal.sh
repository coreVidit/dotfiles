#!/bin/bash

# check if dropdown terminal exists
if hyprctl clients | grep -q "class: dropdown"; then
    # just toggle workspace
    hyprctl dispatch togglespecialworkspace term
else
    # spawn terminal
    kitty --class dropdown &

    # wait for it to appear
    sleep 0.15

    # move ONLY the dropdown terminal
    hyprctl dispatch movetoworkspace "special:term,class:^(dropdown)$"

fi
