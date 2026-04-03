# How to run `git town ship`

## Command

`git town ship`

## What it does

The recommended way to merge your feature branches is to use the web UI or merge
queue of your code hosting service, as you would normally do.

## Syntax

```bash
git town ship [<branch-name>] [--dry-run] [-h | --help] [--(no)-ignore-uncommitted] [(-m | --message) <text>] [(-f | --message-file) <path>] [(-s | --strategy) <name>] [-p | --to-parent] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town ship --help`.
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
- `--ignore-uncommitted`
- `--no-ignore-uncommitted`
- `-m <text>`
- `--message <text>`
- `-f <path>`

## Example

```bash
# Replace sample values as needed for your repository
git town ship --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/ship.md
