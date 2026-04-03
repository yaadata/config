# How to run `git town propose`

## Command

`git town propose`

## What it does

The propose command helps create a new pull request (also known as merge
request) for the current feature branch.

## Syntax

```bash
git town propose [--(no)-auto-resolve] [(-b | --body) <text>] [(-f | --body-file) <path>] [--dry-run] [--headless] [-h | --help] [-s | --stack] [(-t | --title) <text>] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town propose --help`.
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
- `-b <text>`
- `--body <text>`
- `-f <path>`
- `--body-file <path>`
- `--dry-run`
- `--headless`

## Example

```bash
# Replace sample values as needed for your repository
git town propose --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/propose.md
