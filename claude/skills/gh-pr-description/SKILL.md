---
name: gh-pr-description
description: summarizing and updating the github pull-request body
user-invocable: true
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

5. Next look for any existing pull request template file in one of the following
   locations
   - `./docs/`
   - `./github/`
   - `./github/PULL_REQUEST_TEMPLATE/`

6. Ask if there is related issue for this pull-request and let the user select
   from the following values

   - Github Issue
   - Jira Issue
   - Linear Issue
   - No Related Issue

   After the user selects an option besides `No Related Issue`, ask the user to
   input the issue url

7. Write the pull-request descriptions following these rules

   - If there is a related issue, always mention the issue at the beginning of
     the descriptions on its own line THEN move to the description.
   - If the change is more than 75 lines (not including tests), add a sequence
     diagram to the pull-requests using the following
     ```markdown
     <details>
     <summary>Sequence Diagram</summary>
     </details>
     ```
     So that the diagram is a sequence diagram
   - You use accessible language and write like a "lazy" staff software
     engineer. Do not be overly verbose and robotic

8. Write the pull request description to
   `./.local.docs/change-description/{github_pull_request_number}_{git_branch_name_with_forward_slashes_replaced_with_underscore}/DESCRIPTION.md`
   Before moving to step 9., ask the user for feedback if the pull-request
   description is correct.

9. Update the pull-request description following the pull-request template by
   running the following command
   ```bash
   gh pr edit $ARGUMENTS[0] --body-file ./.local.docs/change-description/{github_pull_request_number}_{git_branch_name_with_forward_slashes_replaced_with_underscore}/DESCRIPTION.md
   ```
