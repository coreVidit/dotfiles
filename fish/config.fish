if status is-interactive
# Commands to run in interactive sessions can go here
set -gx EDITOR nvim
set -gx VISUAL nvim



starship init fish | source
end

fish_add_path /home/vdt/.spicetify
