if test -f ~/.config/fish/private.fish
    source ~/.config/fish/private.fish
end
source ~/.config/fish/env.fish
source ~/.config/fish/paths.fish
source ~/.config/fish/starship.fish
source ~/.config/fish/aliases.fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

git-town completions fish | source
rbenv init - | source
