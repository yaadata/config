function fcd --description "Change directory via fzf"
    set -l dir (find . -type d 2>/dev/null | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end
