---
name: library
description: Save chat context into a Markdown library note under ./.local/docs/library using a numbered filename and frontmatter. Use when the user asks to save a result, save a chat, archive part of the conversation, or explicitly invokes /library with a description. Trigger on phrases such as "Save this result to the library" and "Save this chat to the library". If the requested source context is ambiguous, stop and ask the user to clarify whether the note should be based on the full chat, a subset of the chat, or a specific artifact.
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash(python3 *), Bash(mkdir -p *)
---

# Library

## Overview

Create a Markdown note at `./.local/docs/library/{NNNNN}_{short-description}.md`.
Use the user's requested context as the source material, then write a concise, reusable note with required frontmatter.

## Workflow

1. Determine whether the request explicitly targets the library.
2. Identify the source context.
3. If the source context is unclear, ask the user to clarify before writing anything.
4. Derive the title, short description, tags, and note body from the specified context.
5. Run `scripts/create_library_note.py` from the skill directory to create the file.
6. Tell the user which file was created.

## Clarify Ambiguity

Do not guess the source material.

Ask a short clarifying question when the user does not clearly specify one of these:

- the entire chat
- part of the chat
- a specific artifact in the chat

Examples that require clarification:

- "Save this to the library."
- "Use /library and write this up."

Examples that are clear enough to proceed:

- "Save this result to the library."
- "Save this chat to the library."
- "Use /library to save the error summary from the previous message."

## File Format

Write the note with YAML frontmatter followed by a Markdown body.

Required frontmatter fields:

- `number`: five-digit note number, for example `00001`
- `title`: human-readable title
- `date`: current date in `YYYY-MM-DD`
- `tags`: list of single-word tags
- `description`: short description used in the filename slug

The filename must follow:

```text
./.local/docs/library/{NNNNN}_{short-description}.md
```

Normalize `{short-description}` to lowercase hyphenated text.

## Content Guidance

Use the specified source context only.

Prefer this structure unless the source material demands a better shape:

```md
# {Title}

## Summary

Brief synthesis of the selected context.

## Details

Important supporting facts, decisions, or excerpts from the selected context.
```

Keep the note concise and useful for later retrieval. Do not add invented facts.

## Script

Use `scripts/create_library_note.py` to create the destination directory, pick the next number, generate the slug, and write the file.

Usage:

```bash
python3 ~/.config/claude/skills/library/scripts/create_library_note.py \
  --base-dir "$PWD" \
  --title "Note title" \
  --description "short description" \
  --tags "tag-one,tag-two" \
  --body-file /tmp/body.md
```

Guidelines:

- Pass `--base-dir "$PWD"` so the note is created under the current workspace.
- Put the body content in a temporary Markdown file, then pass it with `--body-file`.
- Keep each tag to a single word. Normalize whitespace and separators before passing tags.
- If the script reports an invalid tag or missing content, fix the input instead of bypassing the script.

## Explicit Invocation

The skill may be invoked directly with `/library`.

When the user invokes `/library`, require a description of what should be saved. If the description still does not identify the source context precisely enough, ask a clarifying question before creating the note.
