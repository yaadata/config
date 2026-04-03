# How to run `git town completions`

## Command

`git town completions`

## What it does

The completions command outputs shell scripts that enable auto-completion for
Git Town in Bash, Fish, PowerShell, or Zsh.

## Syntax

```bash
git town completions (bash|fish|powershell|zsh) [-h | --help] [--no-descriptions]
```

## Steps

1. Confirm your repository state with `git status` and branch context with
   `git branch --show-current`.
2. Inspect command-specific flags with `git town completions --help`.
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
- `--no-descriptions`

## Example

```bash
# Replace sample values as needed for your repository
git town completions zsh
```

## Source

Upstream command documentation:
https://github.com/git-town/git-town/blob/main/website/src/commands/completions.md
