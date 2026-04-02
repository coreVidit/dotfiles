#!/usr/bin/env bash

echo "Setting up universal dotfiles symlinks..."

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Iterate over everything inside ~/dotfiles
for item in "$DOTFILES_DIR"/*; do
    # Extract just the folder/file name (e.g., 'hypr', 'install.sh')
    basename=$(basename "$item")

    # Guard clause to skip non-config files like this script itself, or READMEs
    if [[ "$basename" == "install.sh" ]] || [[ "$basename" == "README.md" ]] || [[ "$basename" == ".git" ]]; then
        continue
    fi

    TARGET="$CONFIG_DIR/$basename"
    echo "Processing $basename..."

    # If the target exists and is a directory (and NOT a symlink)
    if [ -d "$TARGET" ] && [ ! -L "$TARGET" ]; then
        echo "  Backing up existing directory to ${TARGET}.bak"
        mv "$TARGET" "${TARGET}.bak"
    # If the target is a file or a dead symlink, remove it
    elif [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        echo "  Removing existing file/symlink at $TARGET"
        rm -f "$TARGET"
    fi

    # Ensure ~/.config exists just in case
    mkdir -p "$CONFIG_DIR"

    # Create the symlink
    echo "  Linking $item -> $TARGET"
    ln -sf "$item" "$TARGET"
done

echo "Done! 🎉"
