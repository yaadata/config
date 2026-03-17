---
name: code-comment
description: Add or improve code comments and documentation for functions, methods, or complex blocks. Use this when the user wants code explained inline, doc comments added, or existing comments tightened without repeating what the code already says.
---

# Code Comment

Use this skill when the user wants documentation comments or brief explanatory
comments added to code.

## Workflow

1. Inspect the target code and nearby symbols before writing anything.
2. Follow the language's normal documentation style.
3. Use direct, accessible language and avoid repetition.
4. If the function or method name already communicates what the comment would
   say, do not add a comment. Tell the user no change is needed.
5. If documenting a function or method, ask: `Should I include an example usage
   snippet in the documentation comment?`
6. If the user wants an example, keep it short and realistic.

## Writing Rules

- Prefer comments that explain intent, constraints, side effects, invariants, or
  tricky behavior.
- Do not add comments that simply restate the code.
- Keep comments concise.
- Mention the documentation style you are using when reporting the change.
