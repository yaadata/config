
function __starship_profile_args
    if set -q __starship_prompt_profile; and test -n "$__starship_prompt_profile"
        printf '%s\n' --profile "$__starship_prompt_profile"
    end
end

function starship_transient_prompt_func
    starship prompt --profile operations $argv
end

set -g starship_transience_enabled 1

function toggle_starship_operations_profile
    if set -q __starship_prompt_profile; and test "$__starship_prompt_profile" = operations
        set -e __starship_prompt_profile
        echo "Starship operations profile disabled"
    else
        set -gx __starship_prompt_profile operations
        echo "Starship operations profile enabled"
    end

    commandline -f repaint 2>/dev/null
end

function toggle_starship_transience
    if test "$starship_transience_enabled" = 1
        disable_transience
        set -g starship_transience_enabled 0
        echo "Starship transience disabled"
    else
        enable_transience
        set -g starship_transience_enabled 1
        echo "Starship transience enabled"
    end
end

starship init fish | source

function fish_prompt
    switch "$fish_key_bindings"
        case fish_hybrid_key_bindings fish_vi_key_bindings fish_helix_key_bindings
            set STARSHIP_KEYMAP "$fish_bind_mode"
        case '*'
            set STARSHIP_KEYMAP insert
    end

    set STARSHIP_CMD_PIPESTATUS $pipestatus
    set STARSHIP_CMD_STATUS $status
    set STARSHIP_DURATION "$CMD_DURATION$cmd_duration"

    __starship_set_job_count

    if contains -- --final-rendering $argv; or test "$TRANSIENT" = "1"
        if test "$TRANSIENT" = "1"
            set -g TRANSIENT 0
            printf \e\[0J
        end

        if type -q starship_transient_prompt_func
            starship_transient_prompt_func --terminal-width="$COLUMNS" --status=$STARSHIP_CMD_STATUS --pipestatus="$STARSHIP_CMD_PIPESTATUS" --keymap=$STARSHIP_KEYMAP --cmd-duration=$STARSHIP_DURATION --jobs=$STARSHIP_JOBS
        else
            printf "\e[1;32m❯\e[0m "
        end
    else
        starship prompt (__starship_profile_args) --terminal-width="$COLUMNS" --status=$STARSHIP_CMD_STATUS --pipestatus="$STARSHIP_CMD_PIPESTATUS" --keymap=$STARSHIP_KEYMAP --cmd-duration=$STARSHIP_DURATION --jobs=$STARSHIP_JOBS
    end
end

enable_transience
