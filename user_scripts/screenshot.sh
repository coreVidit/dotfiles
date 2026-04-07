#!/bin/bash

# Configuration
screenshot_dir="$HOME/Pictures/Screenshots"
temp_file="/tmp/screenshot_$(date +%s).png"

# Ensure screenshot directory exists
mkdir -p "$screenshot_dir"

# Capture a selection using slurp and grim
if ! grim -g "$(slurp)" "$temp_file"; then
    notify-send "Screenshot cancelled."
    exit 0
fi

# Open swappy for annotation/editing
# -f: input file, -o: output file (overwrite temp)
if command -v swappy >/dev/null 2>&1; then
    swappy -f "$temp_file" -o "$temp_file"
fi

# Basic rename dialog using zenity
default_name="screenshot_$(date +%Y%m%d_%H%M%S)"
file_name=$(zenity --entry --title="Save Screenshot" --text="Enter filename (without extension):" --entry-text="$default_name")

# If user cancels or provides empty name, fallback to default
if [ -z "$file_name" ]; then
    file_name="$default_name"
fi

# Move final image to Screenshots folder
final_path="$screenshot_dir/$file_name.png"
mv "$temp_file" "$final_path"

# Notify user
notify-send "Screenshot Saved" "Path: $final_path" -i "$final_path"

# Also copy to clipboard for convenience
if command -v wl-copy >/dev/null 2>&1; then
    cat "$final_path" | wl-copy --type image/png
    notify-send "Copied to Clipboard" "Image also copied to clipboard."
fi
