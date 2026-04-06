#!/bin/bash

# Cache file to make the UI instant
CACHE="/tmp/ext_brightness_val"
[ ! -f "$CACHE" ] && echo "50" > "$CACHE"

CURRENT=$(cat "$CACHE")

# Step by 10%
if [ "$1" == "up" ]; then
    NEW=$((CURRENT + 5))
    [ $NEW -gt 100 ] && NEW=100
else
    NEW=$((CURRENT - 5))
    [ $NEW -lt 0 ] && NEW=0
fi

# Save the new value for next time
echo "$NEW" > "$CACHE"

# Convert 0-100 to 0.0-1.0 for SwayOSD
OSD_VAL=$(awk -v n=$NEW 'BEGIN {printf "%.2f", n/100}')

# 1. Update the OSD slider INSTANTLY
swayosd-client --monitor HDMI-A-1 --custom-progress "$OSD_VAL"

# 2. Update the hardware in the background (no lag!)
ddcutil setvcp 10 "$NEW" &
