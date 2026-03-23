---
name: code-explorer
description: Explore a codebase from a specific file, document section, symbol, or directory path and explain how that area works. Use when the user wants architectural understanding, dependency tracing, call-flow analysis, wiring explanations, test-surface discovery, or a durable markdown exploration note for a codepath or subsystem.
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash(git *), Bash(rg *), Bash(mkdir -p *)
---

# Code Explorer

Inspect a focused area of a repository, trace the relevant codepath, and explain the result in a durable markdown note.

Prefer concrete evidence from local source, version control history, and symbol lookup over speculation.

## Workflow

1. Identify the exploration target: file, document section, symbol, or directory path.
2. Extract the user question, constraints, and expected outcome from the request.
3. Inspect the target directly before widening the search radius.
4. Traverse the codepath with fast local tools such as `rg`, `git grep`, `git log`, `git blame`, `fzf`, and available LSP or symbol-navigation features.
5. Trace dependencies, callers, callees, configuration, build targets, feature flags, and tests that materially affect the behavior.
6. Validate uncertain assumptions by finding similar local usage patterns or reading the dependency source locally.
7. If local source is insufficient and external lookup is available, consult authoritative upstream documentation or source for the dependency instead of guessing.
8. Write the exploration result to the required markdown artifact path.

## Exploration Rules

- Start narrow. Read the named file or directory before searching the whole repository.
- Prefer `rg` and symbol search for discovery. Use `git` commands when history or ownership clarifies intent.
- Follow execution flow, not just import graphs. Distinguish definition, wiring, runtime entrypoints, and side effects.
- Call out uncertainty explicitly. Do not present inferred behavior as confirmed behavior.
- Reuse nearby code as evidence when the exact target is unclear.
- Highlight boundaries between layers such as directory path, build tag, build target, generated code, framework glue, or external dependency code.
- Include test coverage only when it is relevant to the explored codepath.
- Keep the explanation accessible. Translate framework-specific or domain-specific details into plain language.

## Artifact Rules

Store every exploration note at:

`./.local/docs/exploration/{git-branch-with-slashes-replaced-by-underscores}/{NNNN}_exploration.md`

Determine `NNNN` by scanning the target branch directory for existing files matching `*_exploration.md` and incrementing the highest 4-digit prefix, starting at `0001`.

Use the same number in the document title:

`# {NNNN} - Title`

Choose a short, specific title based on the user question and explored area.

## Required Output Format

Always write the artifact in this shape:

```markdown
# {NNNN} - Title

## Context

### Background
<!-- User provided question, code references, and areas to focus -->

### Expected Outcomes
<!-- What the user wants to learn or decide -->

## Result

### Sequence Diagram
<!-- Include only when the exploration crosses more than 2 layers -->

### Explanation
<!-- Explain the flow and important details in accessible language -->

### Test Coverage
<!-- List relevant tests, gaps, or say none identified if applicable -->
```

## Sequence Diagram Rule

Add `### Sequence Diagram` when the exploration crosses more than 2 layers.

Treat a layer as any of:

- a distinct directory path boundary
- a build tag or build target boundary
- a framework or generated-code boundary
- a file whose explanation requires unpacking more than 100 lines of code

When a sequence diagram is not needed, keep the heading out of the artifact instead of adding an empty section.

## Explanation Guidance

- Explain the codepath in execution order.
- Name the important files, symbols, and configuration points.
- Connect the user question to the actual implementation.
- Separate confirmed facts from informed inferences.
- If a dependency or wiring point is unclear, cite similar local usage and continue searching until the assumption is reasonably validated.
- Mention alternative paths, guards, or feature flags when they change behavior.

## Test Coverage Guidance

- Include unit, integration, end-to-end, fixture, or snapshot tests that exercise the explored path.
- Mention notable coverage gaps if the behavior appears untested.
- If no meaningful tests apply, say so briefly.

## Practical Commands

Prefer commands and tools like:

- `rg` or `git grep` to find symbols, strings, and config
- `rg --files` plus `fzf` to narrow to files quickly
- `git log`, `git blame`, and `git show` to recover intent or regressions
- local LSP navigation for definitions, references, implementations, and type info

Adapt to the repo. Use the fastest local tool that answers the current question with the least noise.
