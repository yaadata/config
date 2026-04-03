# How to run `git town set-parent`

## Command

`git town set-parent`

## What it does

The set-parent command moves a branch and all its children below another branch.

## Syntax

```bash
git town set-parent [<branch>] [--(no)-auto-resolve] [-h | --help] [--none] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town set-parent --help`.
3. Skip dry-run (this command does not advertise `--dry-run` in the command
   summary).
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `--auto-resolve`
- `--no-auto-resolve`
- `-h`
- `--help`
- `--none`
- `-v`
- `--verbose`

## Example

```bash
# Replace sample values as needed for your repository
git town set-parent
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/set-parent.md
