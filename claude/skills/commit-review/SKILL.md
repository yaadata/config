---
name: commit-review
description: review an uncommitted diff, staged diff or commits
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash(git-town *), Bash(git *), Bash(mkdir -p *)
---

1. Ask the user what they want to review from the following options
   - Uncommitted diff (unstaged)
   - Staged diff
   - Commit Hash

   If `Commit Hash` is selected, give the user the last 5 commits in the
   following format:

   `{HASH_0} "{Top Level Commit Message}"`

2. Use the builtin lsp (if there is any) and other tools to find related content
   to the diff.

3. Write the following review in the following format:

   ```markdown
   ## Context

   Commit: {Commit hash or "uncommited"}

   Commit Message: {Commit Message - Top Level}

   Commit Author: {Author}

   ## Review

   ### Sequence Diagram

   <!-- Include if Diff is greater than or equal to 75 lines (not including tests)-->

   ### Description

   <!-- Describe the change and explain the sequence diagram if there is one to provide more clarity-->

   ### Test Coverage

   <!-- If the change includes changes to code find existing tests prior to the pull-requests or in this pull-request that validates this change-->

   ### Positives

   <!-- Describe the strengths of this change-->

   ### Negatives

   <!-- Describe the gaps in implementation and rank them in severity. GAPS are merge blockers-->

   ### Nits

   <!-- Mention any nits that are non blocking to merging this change-->

   ## Verdict

   <!-- Give your final verdict and reference earlier parts of this document-->
   ```

4. Store the review at the following location

   `./.local.docs/commit-review/{3_digit_autoincrementing_starting_at_001}_{short form commit hash if there is one or "uncommited"}/REVIEW.md`
