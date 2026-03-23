---
name: planner
description: Create, critique, revise, and store implementation plans under .local/docs/plans for the current branch. Use this when the user wants a reusable written plan artifact, not just an in-chat outline.
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash(mkdir -p *)
---

# Planner

Use this skill when the user wants a stored planning artifact for the current
branch.

## Modes

Ask the user which mode they want:

- create a new plan
- critique an existing plan
- revise an existing plan

## Create

1. Gather enough repo context before planning.
2. Clarify goal, success criteria, constraints, and important tradeoffs.
3. Write the plan artifact to:
   `./.local/docs/plans/{branch-with-slashes-replaced}/{NNNN}_PLAN.md`

   Determine `NNNN` by scanning the target branch directory for existing files
   matching `*_PLAN.md` and incrementing the highest 4-digit prefix, starting at
   `0001`.

   Use the same number in the document title:

4. The plan must include:
   - problem statement
   - code references
   - approach
   - test and validation plan

## Critique

1. Read the existing `{NNNN}_PLAN.md`.
2. Review it as a staff engineer focused on security, maintainability, and
   extensibility.
3. Call out reused patterns that are already weak, not only new issues.
4. Write the critique to:
   `./.local/docs/plans/{branch-with-slashes-replaced}/{NNNN}_CRITIQUE.md`

   `NNNN` in `{NNNN}_CRITIQUE.md` is the same value as in `{NNNN}_PLAN.md` that
   is being critiqued

## Revise

1. Read the existing `{NNNN}_CRITIQUE.md`.
2. For each critique, provide a rebuttal if needed and rank it LOW, MEDIUM, or
   HIGH.
3. Walk through the critiques in order and ask the user whether to modify the
   plan for each one.
4. Update: `./.local/docs/plans/{branch-with-slashes-replaced}/{NNNN}_PLAN.md`

   `NNNN` in `{NNNN}_PLAN.md` is the same value as in `{NNNN}_CRITIQUE.md`

## Rules

- Keep plans implementation-ready.
- Prefer concrete decisions over open-ended brainstorming.
- Store the artifact in the repo before concluding the task.
