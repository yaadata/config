if test -f ~/.config/fish/private.fish
    source ~/.config/fish/private.fish
end
source ~/.config/fish/env.fish
source ~/.config/fish/aliases.fish
source ~/.config/fish/paths.fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
git-town completions fish | source
rbenv init - | source
