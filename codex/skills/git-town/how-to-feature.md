# How to run `git town feature`

## Command

`git town feature`

## What it does

The feature command makes some of your branches feature branches.

## Syntax

```bash
git town feature [<branch-name>...] [-h | --help] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town feature --help`.
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
git town feature
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/feature.md
