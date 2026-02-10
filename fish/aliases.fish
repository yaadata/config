abbr -a gt git-town

function naptime
    pmset sleepnow
end

function git_town_toggle
    # Check current abbreviation value
    if abbr -q gt; and string match -q "*git-town_development*" (abbr -s | grep "^gt " | cut -d' ' -f2-)
        abbr -e gt
        abbr -a gt git-town
        echo "now running \"production\" version"
    else if test -n "$GIT_TOWN_DEVELOPMENT_PATH"
        abbr -e gt
        abbr -a gt "$GIT_TOWN_DEVELOPMENT_PATH/git-town_development"
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
abbr gta "git-town append"
abbr gtb "git-town branch"
abbr gth "git-town hack"
abbr gts "git-town sync"
abbr gtS "git-town switch"
abbr gtss "git-town sync -s"
abbr gtu "git-town up"
abbr gtd "git-town down"
abbr gtdel "git-town delete"


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
abbr gplla git_pull_all
abbr gpll "git pull --rebase"
abbr greb "git rebase"
abbr grebn 'git rebase -i HEAD~n'
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

function vi
    nvim $argv
end

# containers and infra
abbr k "kubectl"
# kubectl abbreviations for fish shell

# Execute a kubectl command against all namespaces
abbr kca 'kubectl --all-namespaces'

# Apply a YML file
abbr kaf 'kubectl apply -f'

# Drop into an interactive terminal on a container
abbr keti 'kubectl exec -t -i'

# Manage configuration quickly to switch contexts between local, dev ad staging.
abbr kcuc 'kubectl config use-context'
abbr kcsc 'kubectl config set-context'
abbr kcdc 'kubectl config delete-context'
abbr kccc 'kubectl config current-context'

# List all contexts
abbr kcgc 'kubectl config get-contexts'

# General abbreviations
abbr kdel 'kubectl delete'
abbr kdelf 'kubectl delete -f'
abbr kge 'kubectl get events --sort-by=".lastTimestamp"'
abbr kgew 'kubectl get events --sort-by=".lastTimestamp" --watch'

# Pod management.
abbr kgp 'kubectl get pods'
abbr kgpl 'kubectl get pods -l'
abbr kgpn 'kubectl get pods -n'
abbr kgpsl 'kubectl get pods --show-labels'
abbr kgpa 'kubectl get pods --all-namespaces'
abbr kgpw 'kubectl get pods --watch'
abbr kgpwide 'kubectl get pods -o wide'
abbr kep 'kubectl edit pods'
abbr kdp 'kubectl describe pods'
abbr kdelp 'kubectl delete pods'
abbr kgpall 'kubectl get pods --all-namespaces -o wide'

# Service management.
abbr kgs 'kubectl get svc'
abbr kgsa 'kubectl get svc --all-namespaces'
abbr kgsw 'kubectl get svc --watch'
abbr kgswide 'kubectl get svc -o wide'
abbr kes 'kubectl edit svc'
abbr kds 'kubectl describe svc'
abbr kdels 'kubectl delete svc'

# Ingress management
abbr kgi 'kubectl get ingress'
abbr kgia 'kubectl get ingress --all-namespaces'
abbr kei 'kubectl edit ingress'
abbr kdi 'kubectl describe ingress'
abbr kdeli 'kubectl delete ingress'

# Namespace management
abbr kgns 'kubectl get namespaces'
abbr kens 'kubectl edit namespace'
abbr kdns 'kubectl describe namespace'
abbr kdelns 'kubectl delete namespace'
abbr kcn 'kubectl config set-context --current --namespace'

# ConfigMap management
abbr kgcm 'kubectl get configmaps'
abbr kgcma 'kubectl get configmaps --all-namespaces'
abbr kecm 'kubectl edit configmap'
abbr kdcm 'kubectl describe configmap'
abbr kdelcm 'kubectl delete configmap'

# Secret management
abbr kgsec 'kubectl get secret'
abbr kgseca 'kubectl get secret --all-namespaces'
abbr kdsec 'kubectl describe secret'
abbr kdelsec 'kubectl delete secret'

# Deployment management.
abbr kgd 'kubectl get deployment'
abbr kgda 'kubectl get deployment --all-namespaces'
abbr kgdw 'kubectl get deployment --watch'
abbr kgdwide 'kubectl get deployment -o wide'
abbr ked 'kubectl edit deployment'
abbr kdd 'kubectl describe deployment'
abbr kdeld 'kubectl delete deployment'
abbr ksd 'kubectl scale deployment'
abbr krsd 'kubectl rollout status deployment'

# Rollout management.
abbr kgrs 'kubectl get replicaset'
abbr kdrs 'kubectl describe replicaset'
abbr kers 'kubectl edit replicaset'
abbr krh 'kubectl rollout history'
abbr kru 'kubectl rollout undo'

# Statefulset management.
abbr kgss 'kubectl get statefulset'
abbr kgssa 'kubectl get statefulset --all-namespaces'
abbr kgssw 'kubectl get statefulset --watch'
abbr kgsswide 'kubectl get statefulset -o wide'
abbr kess 'kubectl edit statefulset'
abbr kdss 'kubectl describe statefulset'
abbr kdelss 'kubectl delete statefulset'
abbr ksss 'kubectl scale statefulset'
abbr krsss 'kubectl rollout status statefulset'

# Port forwarding
abbr kpf 'kubectl port-forward'

# Tools for accessing all information
abbr kga 'kubectl get all'
abbr kgaa 'kubectl get all --all-namespaces'

# Logs
abbr kl 'kubectl logs'
abbr kl1h 'kubectl logs --since 1h'
abbr kl1m 'kubectl logs --since 1m'
abbr kl1s 'kubectl logs --since 1s'
abbr klf 'kubectl logs -f'
abbr klf1h 'kubectl logs --since 1h -f'
abbr klf1m 'kubectl logs --since 1m -f'
abbr klf1s 'kubectl logs --since 1s -f'

# File copy
abbr kcp 'kubectl cp'

# Node Management
abbr kgno 'kubectl get nodes'
abbr kgnosl 'kubectl get nodes --show-labels'
abbr keno 'kubectl edit node'
abbr kdno 'kubectl describe node'
abbr kdelno 'kubectl delete node'

# PVC management.
abbr kgpvc 'kubectl get pvc'
abbr kgpvca 'kubectl get pvc --all-namespaces'
abbr kgpvcw 'kubectl get pvc --watch'
abbr kepvc 'kubectl edit pvc'
abbr kdpvc 'kubectl describe pvc'
abbr kdelpvc 'kubectl delete pvc'

# Service account management.
abbr kdsa 'kubectl describe sa'
abbr kdelsa 'kubectl delete sa'

# DaemonSet management.
abbr kgds 'kubectl get daemonset'
abbr kgdsa 'kubectl get daemonset --all-namespaces'
abbr kgdsw 'kubectl get daemonset --watch'
abbr keds 'kubectl edit daemonset'
abbr kdds 'kubectl describe daemonset'
abbr kdelds 'kubectl delete daemonset'

# CronJob management.
abbr kgcj 'kubectl get cronjob'
abbr kecj 'kubectl edit cronjob'
abbr kdcj 'kubectl describe cronjob'
abbr kdelcj 'kubectl delete cronjob'

# Job management.
abbr kgj 'kubectl get job'
abbr kej 'kubectl edit job'
abbr kdj 'kubectl describe job'
abbr kdelj 'kubectl delete job'

# Function to restart resources by setting REFRESHED_AT environment variable
function kres
    kubectl set env $argv REFRESHED_AT=(date +%Y%m%d%H%M%S)
end

# vault
abbr vl "vault login -method=oidc"
abbr vtl "vault token lookup"
