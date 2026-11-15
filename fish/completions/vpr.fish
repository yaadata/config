# Vite+ `vpr` (`vp run`) completions (https://viteplus.dev)
function __vpr_complete
    set -l tokens (builtin commandline --current-process --tokenize --cut-at-cursor)
    set -l current (builtin commandline --current-token)
    set -l args $tokens[2..]
    set -l translated vp
    if test (builtin count $args) -eq 0; and string match -qr '^-C' -- "$current"
        # Keep completing the global -C option until its value is finished.
    else if test (builtin count $args) -ge 1; and test "$args[1]" = "-C"
        set -a translated -C
        if test (builtin count $args) -ge 2
            set -a translated "$args[2]" run $args[3..]
        end
    else if test (builtin count $args) -ge 1; and string match -qr '^-C.+' -- "$args[1]"
        set -a translated "$args[1]" run $args[2..]
    else
        set -a translated run $args
    end
    VP_COMPLETE=fish command vp -- $translated $current
end
builtin complete -c vpr --keep-order --exclusive --arguments "(__vpr_complete)"
