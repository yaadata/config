# How to run `git town compress`

## Command

`git town compress`

## What it does

The compress command squashes all commits on a branch into a single commit.

## Syntax

```bash
git town compress [--dry-run] [-h | --help] [(-m | --message) <text>] [--no-verify] [-s | --stack] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town compress --help`.
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
- `-m <text>`
- `--message <text>`
- `--no-verify`
- `-s`
- `--stack`

## Example

```bash
# Replace sample values as needed for your repository
git town compress --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/compress.md
