# How to run `git town detach`

## Command

`git town detach`

## What it does

The detach command removes the current branch from the stack it is in and makes
it a stand-alone top-level branch that ships directly into your main branch.

## Syntax

```bash
git town detach [--dry-run] [-h | --help] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town detach --help`.
3. Preview the operation with `--dry-run` when supported.
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `--dry-run`
- `-h`
- `--help`
- `-v`
- `--verbose`

## Example

```bash
# Replace sample values as needed for your repository
git town detach --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/detach.md
