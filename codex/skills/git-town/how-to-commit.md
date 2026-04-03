# How to run `git town commit`

## Command

`git town commit`

## What it does

The commit command takes the currently staged changes and commits them into a
different branch in your stack, then synchronizes the result back into your
current branch.

## Syntax

```bash
git town commit [-d | --down uint] [--dry-run] [-h | --help] [(-m | --message) <text>] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town commit --help`.
3. Preview the operation with `--dry-run` when supported.
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `-d uint`
- `--down uint`
- `--dry-run`
- `-h`
- `--help`
- `-m <text>`
- `--message <text>`
- `-v`

## Example

```bash
# Replace sample values as needed for your repository
git town commit --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/commit.md
