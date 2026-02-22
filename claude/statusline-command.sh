#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract fields from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

parts=()

# Directory (basename, cyan — mirrors robbyrussell/starship directory style)
dir_name=$(basename "$cwd")
parts+=("$(printf '\033[36m%s\033[0m' "$dir_name")")

# Git branch (robbyrussell style: git:(branch) with dirty marker)
if git -C "$cwd" --no-optional-locks rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
    [ -z "$branch" ] && branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null || echo "HEAD")
    if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null || \
       ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
        dirty="$(printf ' \033[33m✗\033[0m')"
    else
        dirty=""
    fi
    parts+=("$(printf '\033[1;34mgit:(\033[0;31m%s\033[1;34m)\033[0m%s' "$branch" "$dirty")")
fi

# Time (mirrors starship time module)
current_time=$(date +"%r")
parts+=("$(printf '🕙 %s' "$current_time")")

# Model
if [ -n "$model" ]; then
    parts+=("$(printf '\033[2m%s\033[0m' "$model")")
fi

# Context usage progress bar
bar_width=10
filled=$((context_pct * bar_width / 100))
empty=$((bar_width - filled))
bar=$(printf '%*s' "$filled" '' | tr ' ' '█')$(printf '%*s' "$empty" '' | tr ' ' '░')
if [ "$context_pct" -ge 80 ]; then
    bar_color='\033[31m'
elif [ "$context_pct" -ge 50 ]; then
    bar_color='\033[33m'
else
    bar_color='\033[32m'
fi
parts+=("$(printf "${bar_color}[%s] %d%%\033[0m" "$bar" "$context_pct")")

# Join all parts with " | " separator
output=""
for part in "${parts[@]}"; do
    if [ -z "$output" ]; then
        output="$part"
    else
        output="$output | $part"
    fi
done

printf "%s\n" "$output"
