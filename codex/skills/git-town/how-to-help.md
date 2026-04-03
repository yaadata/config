# How to run `git town help`

## Command

`git town help`

## What it does

The help command displays detailed information about each Git Town command.

## Syntax

```bash
git town help [-h | --help]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town help --help`.
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

## Example

```bash
# Replace sample values as needed for your repository
git town help
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/help.md
