# How to run `git town up`

## Command

`git town up`

## What it does

The up command moves one position up in the current stack by switching to a
child of the current branch.

## Syntax

```bash
git town up [(-d | --display-types) <type>] [-h | --help] [-m | --merge] [(-o | --order) <asc|desc>] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town up --help`.
3. Skip dry-run (this command does not advertise `--dry-run` in the command
   summary).
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `-d <branch-types>`
- `--display-types <branch-types>`
- `-h`
- `--help`
- `-m`
- `--merge`
- `-o <asc|desc>`
- `--order <asc|desc>`

## Example

```bash
# Replace sample values as needed for your repository
git town up
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/up.md
