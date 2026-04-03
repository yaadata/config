# How to run `git town rename`

## Command

`git town rename`

## What it does

The rename command renames the current branch and its tracking branch. The
branch to rename must be fully synced.

## Syntax

```bash
git town rename [<old-name>] <new-name> [--dry-run] [-f | --force] [-h | --help] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town rename --help`.
3. Preview the operation with `--dry-run` when supported.
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `--dry-run`
- `-f`
- `--force`
- `-h`
- `--help`
- `-v`
- `--verbose`

## Example

```bash
# Replace sample values as needed for your repository
git town rename renamed-branch --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/rename.md
