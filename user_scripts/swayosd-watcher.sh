#!/bin/bash

# Function to get the current volume and mute status as a single string
get_vol_state() {
    # This returns something like "Volume: 0.50" or "Volume: 0.50 [MUTED]"
    wpctl get-volume @DEFAULT_AUDIO_SINK@
}

# Initialize the 'last known' state
LAST_STATE=$(get_vol_state)

# Monitor sink changes
pactl subscribe | grep --line-buffered "Event 'change' on sink" | while read -r _; do
    # Get the current state now that a change happened
    CURRENT_STATE=$(get_vol_state)

    # Only trigger SwayOSD if the volume or mute status actually moved
    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        swayosd-client --output-volume +0
        LAST_STATE="$CURRENT_STATE"
    fi
done
