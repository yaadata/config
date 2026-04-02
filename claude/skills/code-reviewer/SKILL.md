---
name: code-reviewer
description: Perform focused code review when the user provides file selections and line ranges. Use for review requests that require reading selected code with surrounding context, then evaluating language semantics, code structure, correctness risks, and security issues.
user-invocable: true
allowed-tools: Read, Grep, Glob
---

# Code Reviewer

Use the provided file paths and line ranges as the primary review scope.

## Review Workflow

1. Parse selections exactly as given (file + range).
2. Load surrounding context around each range before judging behavior.
3. Expand beyond the immediate range when needed:
   - imports and type definitions
   - called/calling functions
   - nearby state mutations and error handling
   - config/constants that affect runtime behavior
4. Analyze in this order:
   - language/runtime semantics
   - correctness and regression risk
   - structure/readability/maintainability
   - security and abuse paths
5. Report findings first, ordered by severity.
6. Include precise file and line references for every finding.
7. State assumptions and unknowns explicitly when context is incomplete.

## Context Expansion Rules

- Do not review the selected lines in isolation.
- Read enough surrounding code to understand data flow and control flow.
- Trace tainted or user-controlled inputs through validation, storage, and output sinks.
- Verify boundary behavior: nil/null, empty input, large input, error paths, concurrency, and retries/timeouts where relevant.
- Prefer concrete evidence in code over style preferences.

## Finding Quality Bar

Only report findings that are actionable and defensible.

Each finding must include:
- severity (`critical`, `high`, `medium`, `low`)
- what is wrong
- why it is risky
- where it is (file + line)
- minimal fix direction

If no issues are found, say so explicitly and list residual risks or test gaps.

## Security Checklist

Always check for:
- injection risks (SQL/command/template/path)
- authn/authz gaps and privilege escalation
- unsafe deserialization/parsing
- sensitive data exposure in logs/errors/responses
- insecure defaults and secret handling
- race conditions and TOCTOU where applicable
- SSRF/open redirect/file traversal for network/file features
- denial-of-service vectors (unbounded loops, memory, expensive queries)

## Output Format

1. Findings (highest severity first)
2. Open questions / assumptions
3. Brief summary of overall risk
