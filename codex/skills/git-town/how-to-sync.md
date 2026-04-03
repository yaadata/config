# How to run `git town sync`

## Command

`git town sync`

## What it does

The sync command ("synchronize this branch") updates your local Git workspace
with what happened in the rest of the repository.

## Syntax

```bash
git town sync [-a | --all] [--(no)-auto-resolve] [-d | --(no)-detached] [--dry-run] [--gone] [-h | --help] [-p | --prune] [--(no)-push] [-s | --stack] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town sync --help`.
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
- `--auto-resolve`
- `--no-auto-resolve`
- `-d`
- `--detached`
- `--no-detached`
- `--dry-run`

## Example

```bash
# Replace sample values as needed for your repository
git town sync --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/sync.md
