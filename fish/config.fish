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

# Keep the Homebrew inventory synchronized.
set -gx HOMEBREW_BREWFILE "$HOME/.config/Brewfile"
set -l brew_prefix "$HOMEBREW_PREFIX"
if test -z "$brew_prefix"
    if test -x /opt/homebrew/bin/brew
        set brew_prefix /opt/homebrew
    else if type -q brew
        set brew_prefix (brew --prefix 2>/dev/null)
    end
end
if test -n "$brew_prefix" -a -f "$brew_prefix/etc/brew-wrap.fish"
    source "$brew_prefix/etc/brew-wrap.fish"
end
