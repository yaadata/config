# How to run `git town diff-parent`

## Command

`git town diff-parent`

## What it does

The diff-parent command displays the changes made on a feature branch, i.e. the
diff between the current branch and its parent branch.

## Syntax

```bash
git town diff-parent [--diff-filter <value>] [-h | --help] [--name-only] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town diff-parent --help`.
3. Skip dry-run (this command does not advertise `--dry-run` in the command
   summary).
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `--diff-filter <value>`
- `-h`
- `--help`
- `--name-only`
- `-v`
- `--verbose`

## Example

```bash
# Replace sample values as needed for your repository
git town diff-parent
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/diff-parent.md
