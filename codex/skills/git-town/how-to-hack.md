# How to run `git town hack`

## Command

`git town hack`

## What it does

The hack command ("let's start hacking") creates a new feature branch with the
given name off the main branch and brings all uncommitted changes over to it.

## Syntax

```bash
git town hack [<branch-name>...] [--(no)-auto-resolve] [-b | --beam] [-c | --commit] [-d | --(no)-detached] [--dry-run] [-h | --help] [(-m | --message) <message>] [--propose] [-p | --prototype] [--(no)-stash] [--(no)-sync] [-v | --verbose]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town hack --help`.
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
- `-b`
- `--beam`
- `-c`
- `--commit`
- `-d`
- `--detached`

## Example

```bash
# Replace sample values as needed for your repository
git town hack --dry-run
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/hack.md
