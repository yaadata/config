# How to run `git town branch`

## Command

`git town branch`

## What it does

The branch command is Git Town's equivalent of the git branch command. It
displays the local branch hierarchy, and the types of all branches except for
main and feature branches.

## Syntax

```bash
git town branch [(-d | --display-types) <branch-types>] [-h | --help] [(-o | --order) <asc|desc>] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town branch --help`.
3. Skip dry-run (this command does not advertise `--dry-run` in the command
   summary).
4. Run the command using required values (for example, branch names or
   messages).
5. If Git Town pauses due to conflicts, resolve conflicts and continue with
   `git town continue` (or `git town skip` / `git town undo`).
6. Verify final state with `git town status` and, when relevant,
   `git town branch`.

## Common flags

- `-d <branch-type>`
- `--display-types <branch-type>`
- `-h`
- `--help`
- `-o <asc|desc>`
- `--order <asc|desc>`
- `-v`
- `--verbose`

## Example

```bash
# Replace sample values as needed for your repository
git town branch
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/branch.md
