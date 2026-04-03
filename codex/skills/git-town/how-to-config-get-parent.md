# How to run `git town config get-parent`

## Command

`git town config get-parent`

## What it does

The config get-parent command outputs the parent branch of the current or given
branch.

## Syntax

```bash
git town config get-parent [<branch-name>] [-h | --help] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town config get-parent --help`.
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
- `-v`
- `--verbose`

## Example

```bash
# Replace sample values as needed for your repository
git town config get-parent
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/config-get-parent.md
