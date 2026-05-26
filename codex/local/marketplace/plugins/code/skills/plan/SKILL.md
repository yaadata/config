---
name: plan
description: Create an exhaustive implementation plan for code changes. Use when the user invokes $code:plan or asks Codex to plan an implementation, design a change, or produce a reusable implementation plan artifact.
---

# Code Plan

Create a decision-complete implementation plan. This is a planning skill, not an implementation skill.

## Core Behavior

Act like `grill-me`:

- Explore the repo before asking questions.
- If a question can be answered from code, configs, docs, tests, or current git state, inspect those sources instead of asking.
- Ask one decision at a time.
- Use interactive selection for every decision when available.
- Provide a recommended answer with each decision.
- Continue until goal, success criteria, audience, scope, constraints, approach, interfaces, edge cases, tests, rollout, and implementation sequencing are settled.
- Do not produce the final plan until the design tree is resolved.

## Workflow

1. Confirm the requested plan is for implementation work. If the user is only asking for explanation or comments, use `$code:describe` or `$code:comment` instead.
2. Gather local context:
   - current branch and git status
   - relevant files, symbols, tests, docs, configuration, and existing patterns
   - prior plans only when directly relevant
3. Interview the user interactively:
   - goal and non-goals
   - success criteria
   - target audience and maintainers
   - constraints and compatibility requirements
   - implementation approach
   - public interfaces, schemas, commands, configuration, or user-visible behavior
   - failure modes, edge cases, migration needs, and rollout concerns
   - test and validation strategy
4. For large, risky, cross-cutting, or multi-subsystem changes, ask whether to include atomic commits.
5. When atomic commits are included, describe each commit with:
   - single purpose
   - expected files or areas
   - validation for that commit
   - review boundary
6. Present the completed plan in chat.
7. Ask the user to accept the plan.
8. Only after acceptance, write the artifact.
9. After the accepted artifact is written, ask interactively whether to invoke `$code:pair` for guided no-edit implementation.

## Artifact Timing

Do not write a plan artifact while the plan is still being developed.

Artifact generation happens only after:

1. the final plan has been presented to the user, and
2. the user explicitly accepts it.

If the active collaboration mode prevents file writes, present the final plan and defer artifact creation until the user exits that mode or asks to implement the accepted plan. After leaving that mode and writing the deferred artifact, always ask whether to invoke `$code:pair`.

## Pair Handoff

After writing an accepted plan artifact, ask one interactive decision:

- Invoke `$code:pair` for guided no-edit implementation
- Stop after writing the plan artifact

Use interactive selection when available. Recommend invoking `$code:pair`.

Do not invoke `$code:pair` silently. The handoff is optional, but the question is required after artifact creation, including when artifact creation was deferred until after Plan Mode.

## Artifact Path

Write accepted artifacts to:

`./.local/docs/code-plan/{branch-with-slashes-replaced}/{NNNN}_PLAN.md`

Determine `NNNN` by scanning that branch directory for existing files matching `*_PLAN.md` and incrementing the highest 4-digit prefix. Start at `0001`.

## Plan Format

The final plan should be concise but implementation-ready. Include:

- Summary
- Key changes
- Public interfaces or behavior changes
- Implementation sequence
- Atomic commits, when applicable
- Test and validation plan
- Assumptions and defaults chosen

Prefer concrete decisions over open-ended brainstorming. Record unresolved questions only if they intentionally remain out of scope.
