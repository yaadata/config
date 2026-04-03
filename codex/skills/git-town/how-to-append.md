# How to run `git town append`

## Command

`git town append`

## What it does

The append command creates a new feature branch with the given name as a direct
child of the current branch and brings over all uncommitted changes to the new
branch.

## Syntax

```bash
git town append <branch-name> [--(no)-auto-resolve] [-b | --beam] [-c | --commit] [-d | --(no)-detached] [--dry-run] [-h | --help] [(-m | --message) <message>] [--propose] [-p | --prototype] [--(no)-push] [--(no)-stash] [--(no)-sync] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town append --help`.
3. Preview the operation with `--dry-run` when supported.
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `--auto-resolve`
- `--no-auto-resolve`
- `-b`
- `--beam`
- `-c`
- `--commit`
- `-d`
- `--detached`

## Example

```bash
# Replace sample values as needed for your repository
git town append feature-2 --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/append.md
