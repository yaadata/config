# How to run `git town prepend`

## Command

`git town prepend`

## What it does

The prepend command creates a new feature branch as the parent of the current
branch. It does that by inserting the new feature branch between the current
feature branch and it's existing parent.

## Syntax

```bash
git town prepend [<branch-name>...] [--(no)-auto-resolve] [-b | --beam] [--body <string>] [-c | --commit] [-d | --(no)-detached] [--dry-run] [-h | --help] [(-m | --message) <message>] [--propose] [-p | --prototype] [--(no)-push] [--(no)-stash] [--(no)-sync] [(-t | --title) <text>] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town prepend --help`.
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
- `--body <string>`
- `-c`
- `--commit`
- `-d`

## Example

```bash
# Replace sample values as needed for your repository
git town prepend --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/prepend.md
