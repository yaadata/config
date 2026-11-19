#!/usr/bin/env bash
# Smart "o" for lazygit localBranches panel.
#
#   PR exists           -> open it in the browser
#   no PR, checked out  -> create one in the browser (lazygit's default o)
#   no PR, other branch -> say so, do nothing
#
# github.com remotes go through gh, everything else (forgejo/codeberg/gitea) through fj.

set -uo pipefail

branch="${1:-$(git rev-parse --abbrev-ref HEAD)}"
current="$(git rev-parse --abbrev-ref HEAD)"
remote="$(git remote get-url origin 2>/dev/null)" || { echo "No origin remote." >&2; exit 1; }

case "$remote" in
  *github.com*) forge=gh ;;
  *)            forge=fj ;;
esac

if [ "$forge" = gh ]; then
  url="$(gh pr list --head "$branch" --state all --limit 1 --json url --jq '.[0].url')"
  if [ -n "$url" ]; then
    echo "PR: $url"
    gh pr view "$url" --web
    exit
  fi
else
  # fj can't filter by branch, so match the branch's commit against refs/pull/*/head.
  sha="$(git ls-remote origin "refs/heads/$branch" | cut -f1)"
  [ -n "$sha" ] || sha="$(git rev-parse HEAD)"
  num="$(git ls-remote origin 'refs/pull/*/head' | awk -v s="$sha" '$1 == s' | head -1 | sed -E 's#.*refs/pull/([0-9]+)/head#\1#')"
  if [ -n "$num" ]; then
    echo "PR: #$num"
    fj pr browse "$num"
    exit
  fi
fi

if [ "$branch" = "$current" ]; then
  echo "No PR for '$branch' -> creating one"
  "$forge" pr create --web
else
  echo "No PR for '$branch'. Check it out first to create one."
fi
