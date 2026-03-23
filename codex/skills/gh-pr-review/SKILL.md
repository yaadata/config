---
name: gh-pr-review
description: Review a GitHub pull request from gh, inspect related code and tests, and write a structured review file under .local/docs. Use this when the user wants an offline or pre-submit PR review grounded in the checked-out code.
---

# GitHub PR Review

Review a GitHub PR and store the review in the repo.

## Workflow

1. Read the PR with: `gh pr view <pr-number>`
2. Gather:
   - git remote
   - PR author
   - PR title
   - PR diff
3. Validate that the current repo remote matches the PR remote. If it does not,
   stop and explain that this skill cannot be used from this checkout.
4. Before any checkout, inspect the worktree. If local changes would be
   disturbed, stop and ask the user how to proceed.
5. Check out the PR locally with: `gh pr checkout <pr-number>`
6. Inspect related code and tests.
7. If the diff is at least 75 non-test lines, prepare a sequence diagram.
8. Write the review to:
   `./.local/docs/reviews/{pr-number}_{branch-with-slashes-replaced}/REVIEW.md`

## Review Format

Use this exact structure:

```markdown
## Context

Pull-Request: {url}

Pull-Request Title: {title}

Pull-Request Author: {author}

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

- Lead with findings, risks, and missing coverage.
- Keep the review grounded in the checked-out code, not only the patch view.
