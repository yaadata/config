---
name: planner
description: create, revise and store implementation plans
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash(mkdir -p *)
---

You are a skill that helps create, revise and store implementation plans

1. Move the agent to "plan mode"

2. Ask the user to select from the following options

   - Create a new plan
   - Critique an existing plan
   - Revise an existing plan

3. Based on the response in step 2.

   A. `Create a new plan`

   Follow your usual plan mode process and after the user has confirmed the plan
   details, store the plan at
   `./.local.docs/plans/{git_branch_name_with_forward_slashes_replaced_with_underscore}/PLAN.md`

   The plan MUST always include the
   - Problem statement
   - Code References
   - Approach
   - Test and Validation Plan (if applicable)

   B. `Critique an existing plan`

   Ask for the existing PLAN.md and write a critique. When you are reviewing,
   you are operating as a Staff Software Engineer considered mainly with
   security, maintainability and extensibility of the solution. If we are using
   an existing pattern in our code base that is reused in our solution that is
   not optimal, you make sure to call it out.

   You write your critique at
   `./.local.docs/plans/{git_branch_name_with_forward_slashes_replaced_with_underscore}/CRITIQUE.md`

   C. `Revise an existing plan`

   Ask for the existing CRITIQUE.md. Next go to each of the critiques and
   provide any rebuttals while ranking each critique on a scale of
   LOW-MEDIUM-HIGH.

   Finally, loop through each of the critiques in order and ask the user via a
   select method whether to modify the PLAN.md or not. After you are done
   looping, update
   `./.local.docs/plans/{git_branch_name_with_forward_slashes_replaced_with_underscore}/PLAN.md`
