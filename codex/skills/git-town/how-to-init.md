# How to run `git town init`

## Command

`git town init`

## What it does

The init command launches Git Town's setup assistant. The setup assistant walks
you through all configuration options for Git Town and gives you a chance to
adjust them.

## Syntax

```bash
git town init [-h | --help] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town init --help`.
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
git town init
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/init.md
