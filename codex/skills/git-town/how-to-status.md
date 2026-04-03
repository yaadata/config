# How to run `git town status`

## Command

`git town status`

## What it does

The status command indicates whether Git Town has encountered a merge conflict
and which commands you can run to continue, skip, or undo it.

## Syntax

```bash
git town status [-h | --help] [-p | --pending] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town status --help`.
3. Skip dry-run (this command does not advertise `--dry-run` in the command
   summary).
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `-h`
- `--help`
- `-p`
- `--pending`
- `-v`
- `--verbose`

## Example

```bash
# Replace sample values as needed for your repository
git town status
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/status.md
