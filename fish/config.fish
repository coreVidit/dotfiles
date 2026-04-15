if status is-interactive
# Commands to run in interactive sessions can go here
set -gx EDITOR nvim
set -gx VISUAL nvim

# Autostart Hyprland on tty1
if status is-login
    if test (tty) = "/dev/tty1"
        exec start-hyprland
    end
end


starship init fish | source
end

fish_add_path /home/vdt/.spicetify
