function git_pull_all
    echo "Fetching all remotes and pruning..."
    git fetch --all --prune

    for branch in (git branch --format='%(refname:short)')
        set upstream (git rev-parse --abbrev-ref "$branch@{upstream}" 2>/dev/null)
        if test -z "$upstream"
            echo "Skipping $branch (no upstream tracking branch)"
            continue
        end

        set local_sha (git rev-parse "$branch")
        set remote_sha (git rev-parse "$upstream")

        if test "$local_sha" = "$remote_sha"
            echo "$branch is already up to date."
            continue
        end

        read -P "Update $branch to match $upstream? [y/N] " confirm
        if test "$confirm" = y -o "$confirm" = Y
            set current (git branch --show-current)
            if test "$branch" = "$current"
                git merge --ff-only "$upstream"
            else
                git branch -f "$branch" "$upstream"
            end
            and echo "$branch updated."
            or echo "Failed to update $branch."
        else
            echo "Skipping $branch."
        end
    end
end
