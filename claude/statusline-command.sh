#!/bin/bash

# Read JSON input from stdin 
input=$(cat)

# Debug: write input to temp file
echo "$input" > /tmp/statusline-debug.json

# Extract current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

# Extract context usage from JSON (Claude Code uses context_window.used_percentage)
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Build status line parts
parts=()

# Git branch (if in a git repo)
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "HEAD")
    parts+=("$(printf '\033[35m⎇ %s\033[0m' "$branch")")
fi

# Time
current_time=$(date +"%I:%M:%S %p")
parts+=("$(printf '🕙 %s' "$current_time")")

# Context usage progress bar
bar_width=10
filled=$((context_pct * bar_width / 100))
empty=$((bar_width - filled))
bar=$(printf '%*s' "$filled" '' | tr ' ' '█')$(printf '%*s' "$empty" '' | tr ' ' '░')
parts+=("$(printf '\033[33mContext [%s] %d%%\033[0m' "$bar" "$context_pct")")

# Join all parts with " | " separator
IFS=' | '
printf "%s\n" "${parts[*]}"
