---
name: git-town
description: Use Git Town CLI for branch and stack management in stacked-branch workflows with concise command lookup, safe execution guidance, and per-command how-to references. Trigger when users ask to manage branches or stacks, which git-town command to run, how to run a specific git town command, or how to recover/continue git-town operations.
---

# Git Town Command Skill

Use this skill to map intent to a command. Verify the command to use and then
run the command

## Workflow

1. Identify the target command from the command index below.
2. Open the linked `how-to-*.md` file in this same directory for execution
   steps.
3. Share all flag options with the user when proposing a command
4. Prefer `--help` and `--dry-run` (when available) before running high-impact
   operations.
5. Execute the command in a terminal. If conflicts interrupt a command, use
   `git town continue`, `git town skip`, or `git town undo` as appropriate.

## Command Index

- `append`: The append command creates a new feature branch with the given name
  as a direct child of the current branch and brings over all uncommitted
  changes to the new branch. See [how-to-append.md](how-to-append.md).
- `branch`: The branch command is Git Town's equivalent of the git branch
  command. It displays the local branch hierarchy, and the types of all branches
  except for main and feature branches. See
  [how-to-branch.md](how-to-branch.md).
- `commit`: The commit command takes the currently staged changes and commits
  them into a different branch in your stack, then synchronizes the result back
  into your current branch. See [how-to-commit.md](how-to-commit.md).
- `completions`: The completions command outputs shell scripts that enable
  auto-completion for Git Town in Bash, Fish, PowerShell, or Zsh. See
  [how-to-completions.md](how-to-completions.md).
- `compress`: The compress command squashes all commits on a branch into a
  single commit. See [how-to-compress.md](how-to-compress.md).
- `config get-parent`: The config get-parent command outputs the parent branch
  of the current or given branch. See
  [how-to-config-get-parent.md](how-to-config-get-parent.md).
- `config remove`: The config remove command removes all Git Town related
  configuration from the current Git repository. See
  [how-to-config-remove.md](how-to-config-remove.md).
- `config`: The config command displays and updates the local Git Town
  configuration. See [how-to-config.md](how-to-config.md).
- `continue`: When a Git Town command encounters a problem that it cannot
  resolve, for example a merge conflict, it stops to give the user an
  opportunity to resolve the issue. See
  [how-to-continue.md](how-to-continue.md).
- `contribute`: The contribute command makes some of your branches contribution
  branches. See [how-to-contribute.md](how-to-contribute.md).
- `delete`: The delete command deletes the given branch from the local and if
  possible the remote repository, removes commits of deleted branches from their
  descendents (unless when using the merge sync strategy), and updates... See
  [how-to-delete.md](how-to-delete.md).
- `detach`: The detach command removes the current branch from the stack it is
  in and makes it a stand-alone top-level branch that ships directly into your
  main branch. See [how-to-detach.md](how-to-detach.md).
- `diff-parent`: The diff-parent command displays the changes made on a feature
  branch, i.e. the diff between the current branch and its parent branch. See
  [how-to-diff-parent.md](how-to-diff-parent.md).
- `down`: The down command moves one position down in the current stack by
  switching to the parent of the current branch. See
  [how-to-down.md](how-to-down.md).
- `feature`: The feature command makes some of your branches feature branches.
  See [how-to-feature.md](how-to-feature.md).
- `hack`: The hack command ("let's start hacking") creates a new feature branch
  with the given name off the main branch and brings all uncommitted changes
  over to it. See [how-to-hack.md](how-to-hack.md).
- `help`: The help command displays detailed information about each Git Town
  command. See [how-to-help.md](how-to-help.md).
- `init`: The init command launches Git Town's setup assistant. The setup
  assistant walks you through all configuration options for Git Town and gives
  you a chance to adjust them. See [how-to-init.md](how-to-init.md).
- `merge`: The merge command merges the current branch into the branch ahead of
  it in the current stack. See [how-to-merge.md](how-to-merge.md).
- `observe`: The observe command makes some of your branches observed branches.
  See [how-to-observe.md](how-to-observe.md).
- `offline`: The offline configuration command displays or changes Git Town's
  offline mode. Git Town skips all network operations in offline mode. See
  [how-to-offline.md](how-to-offline.md).
- `park`: The park command parks some of your branches. See
  [how-to-park.md](how-to-park.md).
- `prepend`: The prepend command creates a new feature branch as the parent of
  the current branch. It does that by inserting the new feature branch between
  the current feature branch and it's existing parent. See
  [how-to-prepend.md](how-to-prepend.md).
- `propose`: The propose command helps create a new pull request (also known as
  merge request) for the current feature branch. See
  [how-to-propose.md](how-to-propose.md).
- `prototype`: The prototype command marks some of your branches as prototype
  branches. See [how-to-prototype.md](how-to-prototype.md).
- `rename`: The rename command renames the current branch and its tracking
  branch. The branch to rename must be fully synced. See
  [how-to-rename.md](how-to-rename.md).
- `repo`: The repo command ("show me the repository") opens the homepage of the
  current repository in your browser. See [how-to-repo.md](how-to-repo.md).
- `runlog`: Git Town records the SHA of all local and remote branches before and
  after each command runs into an immutable, append-only log file called the
  runlog. See [how-to-runlog.md](how-to-runlog.md).
- `set-parent`: The set-parent command moves a branch and all its children below
  another branch. See [how-to-set-parent.md](how-to-set-parent.md).
- `ship`: The recommended way to merge your feature branches is to use the web
  UI or merge queue of your code hosting service, as you would normally do. See
  [how-to-ship.md](how-to-ship.md).
- `skip`: The skip command allows to skip a Git branch with merge conflicts when
  syncing all feature branches. See [how-to-skip.md](how-to-skip.md).
- `status reset`: The status reset command deletes the persisted runstate. This
  is only needed if the runstate is corrupted and causes Git Town to crash. See
  [how-to-status-reset.md](how-to-status-reset.md).
- `status show`: The status show command displays Git Town's runstate, i.e.
  detailed information about the currently suspended or previously executed Git
  Town command, including its path on the filesystem. See
  [how-to-status-show.md](how-to-status-show.md).
- `status`: The status command indicates whether Git Town has encountered a
  merge conflict and which commands you can run to continue, skip, or undo it.
  See [how-to-status.md](how-to-status.md).
- `swap`: The swap command switches the position of the current branch with the
  branch ahead of it in the current stack, i.e. moves the current branch one
  position forward in the stack. See [how-to-swap.md](how-to-swap.md).
- `switch`: The switch command displays the branch hierarchy on your machine and
  allows switching the current Git workspace to another local Git branch using
  VIM motion commands. See [how-to-switch.md](how-to-switch.md).
- `sync`: The sync command ("synchronize this branch") updates your local Git
  workspace with what happened in the rest of the repository. See
  [how-to-sync.md](how-to-sync.md).
- `undo`: The undo command reverts the last fully executed Git Town command. It
  performs the opposite activities that the last command did and leaves your
  repository in the state it was before you ran the problematic command. See
  [how-to-undo.md](how-to-undo.md).
- `up`: The up command moves one position up in the current stack by switching
  to a child of the current branch. See [how-to-up.md](how-to-up.md).
- `walk`: The walk command ("walking the branch hierarchy") executes a given
  command for each feature branch. See [how-to-walk.md](how-to-walk.md).
