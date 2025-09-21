function gt
    git-town $argv
end

function naptime
    pmset sleepnow
end

function git_town_toggle
    # Check current alias value using Fish's functions -v
    if functions -q gt; and string match -q "*git-town_development*" (functions gt)
        alias gt='git-town'
        echo "now running \"production\" version"
    else if test -n "$GIT_TOWN_DEVELOPMENT_PATH"
        alias gt="$GIT_TOWN_DEVELOPMENT_PATH/git-town_development"
        echo "now running \"local\" version"
    else
        echo "Error: GIT_TOWN_DEVELOPMENT_PATH is not set"
        return 1
    end
end

function toggle_git_town_lineage
    set current_value (git config git-town.proposals-show-lineage 2>/dev/null)

    if test -n "$current_value"
        # Config is set, so unset it
        git config --unset git-town.proposals-show-lineage
        echo "Unsetting git-town.proposals-show-lineage (was: $current_value)"
    else
        # Config is not set, so set it to 'cli'
        git config git-town.proposals-show-lineage cli
        echo "Setting git-town.proposals-show-lineage=cli"
    end
end

# git abbr
abbr gta "gt append"
abbr gtb "gt branch"
abbr gth "gt hack"
abbr gts "gt sync"
abbr gtS "gt switch"
abbr gtss "gt sync -s"
abbr gtu "gt up"
abbr gtd "gt down"

abbr gtt git_town_toggle
abbr gl toggle_git_town_lineage
abbr ga "git add"
abbr gaa "git add ."
abbr gaaa "git add --all"
abbr gau "git add --update"
abbr gb "git branch"
abbr gbd "git branch --delete"
abbr gc "git commit"
abbr gcm "git commit -S --message"
abbr gcmas "git commit --amend -S"
abbr gcmam "git commit --amend -m"
abbr gcf "git commit --fixup"
abbr gco "git checkout"
abbr gcob "git checkout -b"
abbr gcom "git checkout main"
abbr gcos "git checkout staging"
abbr gcod "git checkout develop"
abbr gd "git diff"
abbr gda "git diff HEAD"
abbr gfap "git fetch --all --prune"
abbr gi "git init"
abbr glg "git log --graph --oneline --decorate --all"
abbr gld 'git log --pretty=format:"%h %ad %s" --date=short --all'
abbr gm "git merge --no-ff"
abbr gma "git merge --abort"
abbr gmc "git merge --continue"
abbr gp "git push"
abbr gpfl "git push --force-with-lease"
abbr gpo "git push origin"
abbr gpll "git pull --rebase"
abbr greb "git rebase"
abbr grebi "git rebase -i"
abbr grv "git remote -v"
abbr gs "git status"
abbr gss "git status --short"
abbr gst "git stash"
abbr gsta "git stash apply"
abbr gstd "git stash drop"
abbr gstl "git stash list"
abbr gstp "git stash pop"
abbr gsts "git stash save"
abbr gclean 'git branch | grep -vE "main|dev" | xargs git branch -D'
abbr dash "gh dash"

# vim
function vim
    nvim $argv
end
