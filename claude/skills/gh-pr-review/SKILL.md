---
name: gh-pr-review
description: review a pull-requested hosted on github
user-invocable: true
context: fork
agent: Explore
allowed-tools: Bash(gh *), Read, Grep, Glob, Bash(git-town *), Bash(git *), Bash(mkdir -p *)
---

1. View the pull-request using
   ```bash
   gh pr view $ARGUMENTS[0]
   ```
2. Gather the following information
   - git remote
   - pull-request
     - author
     - title
     - diff

   Using this information, validate that the current working directory has the
   same git remote pointing to the pull-request. If we do NOT have the git
   remote belonging to this pull-request, fail error and let the user know that
   this skill cannot be used.
3. Check out the pull-request and examine it locally
   ```bash
   gh pr checkout $ARGUMENTS[0]
   ```
4. Using either the lsp tool or grep, find related code and tests that may
   interact with this diff. Note: not every pull-request may have an associated
   test change.
5. If diff is more than 75 lines of code (not including tests), prepare a
   sequence diagram of the change.
6. Check that the following directory path exists
   `./.local.docs/reviews/{pull_request_number}_{git_branch_name_with_forward_slashes_replaced_with_underscore}/`
7. Write your review here
   `./.local.docs/reviews/{pull_request_number}_{git_branch_name_with_forward_slashes_replaced_with_underscore}/REVIEW.md`

   With the following format:

   ```md
   ## Context

   Pull-Request: {url of pull-request}

   Pull-Request Title: {title of pull-request}

   Pull-Request Author: {pull-request author username}

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
