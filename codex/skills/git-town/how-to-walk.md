# How to run `git town walk`

## Command

`git town walk`

## What it does

The walk command ("walking the branch hierarchy") executes a given command for
each feature branch.

## Syntax

```bash
git town walk [<command and arguments>] [-a | --all] [--dry-run] [-h | --help] [-s | --stack] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town walk --help`.
3. Preview the operation with `--dry-run` when supported.
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `-a`
- `--all`
- `--dry-run`
- `-h`
- `--help`
- `-s`
- `--stack`
- `-v`

## Example

```bash
# Replace sample values as needed for your repository
git town walk --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/walk.md
