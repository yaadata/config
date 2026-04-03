# How to run `git town switch`

## Command

`git town switch`

## What it does

The switch command displays the branch hierarchy on your machine and allows
switching the current Git workspace to another local Git branch using VIM motion
commands.

## Syntax

```bash
git town switch [<branch-name-regex>...] [-a | --all] [(-d | --display-types) <type>] [-h | --help] [-m | --merge] [(-o | --order) <asc|desc>] [--(no)-stash] [(-t | --type) <name>] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town switch --help`.
3. Skip dry-run (this command does not advertise `--dry-run` in the command
   summary).
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `-a`
- `--all`
- `-d <branch-types>`
- `--display-types <branch-types>`
- `-h`
- `--help`
- `-m`
- `--merge`

## Example

```bash
# Replace sample values as needed for your repository
git town switch
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/switch.md
