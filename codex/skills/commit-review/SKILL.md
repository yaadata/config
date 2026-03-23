---
name: commit-review
description: Review an uncommitted diff, staged diff, or specific commit and write a structured review file under .local/docs. Use this when the user wants a staff-level review of local changes before they are merged or submitted.
---

# Commit Review

Review local changes and store the review in the repo.

## Workflow

1. Ask the user which target to review:
   - uncommitted diff
   - staged diff
   - commit hash
2. If the user chooses a commit hash, show the last 5 commits as:
   `{HASH} "{top level commit message}"`
3. Gather the relevant diff with git.
4. Inspect related code and existing tests before writing the review.
5. If the diff is at least 75 non-test lines, include a sequence diagram
   section.
6. Write the review to:
   `./.local/docs/commit-review/{NNNN}_{short-hash-or-uncommitted}/REVIEW.md`

   Determine `NNNN` by checking the last file sorted in alpha-numerical order
   and increase the value by 1.

## Review Format

Use this exact structure:

```markdown
## Context

Commit: {commit hash or "uncommitted"}

Commit Message: {top level commit message}

Commit Author: {author}

## Review

### Sequence Diagram

<!-- Include only when the diff is at least 75 non-test lines -->

### Description

<!-- Describe the change and explain the sequence diagram if present -->

### Test Coverage

<!-- Describe tests that validate the change, including pre-existing tests -->

### Positives

<!-- Strengths of the change -->

### Negatives

<!-- Gaps in implementation, ranked by severity. Gaps are merge blockers -->

### Nits

<!-- Non-blocking feedback -->

## Verdict

<!-- Final verdict with references to the earlier sections -->
```

## Rules

- Use a code review mindset first: bugs, regressions, risk, and missing tests.
- Keep the review specific and actionable.
- Never overwrite an existing review directory; create the next 3-digit prefix.
