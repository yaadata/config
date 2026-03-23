---
name: gh-pr-description
description: Summarize a GitHub pull request, draft a PR body that matches the repo template, store it under .local/docs, and optionally update the PR with gh. Use this when the user wants a PR description created or refreshed from the actual diff.
user-invocable: true
allowed-tools: Bash(gh *), Read, Grep, Glob, Bash(git-town *), Bash(git *), Bash(mkdir -p *)
---

# GitHub PR Description

Draft and optionally publish a pull request description for a GitHub PR.

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
7. Look for a PR template in:
   - `./docs/`
   - `./github/`
   - `./github/PULL_REQUEST_TEMPLATE/`
8. Ask whether there is a related issue:
   - GitHub issue
   - Jira issue
   - Linear issue
   - no related issue
9. If there is a related issue, ask for the issue URL and place it on its own
   line at the top of the description.
10. If the diff is at least 75 non-test lines, add a collapsed sequence diagram
    section.
11. Write the draft to:
    `./.local/docs/change-description/{pr-number}_{branch-with-slashes-replaced}/DESCRIPTION.md`
12. Show the draft to the user and ask for feedback before updating the PR.
13. If the user approves, run:
    `gh pr edit <pr-number> --body-file <description-path>`

## Writing Rules

- Follow any discovered PR template.
- Write in accessible, concise staff-engineer language.
- Do not sound robotic.
- Keep the description grounded in the actual diff and tests.
