if status is-interactive
# Commands to run in interactive sessions can go here
set -gx STARSHIP_CONFIG ~/.cache/wallust/starship.toml
starship init fish | source
end
