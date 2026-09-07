# context-mode — MANDATORY routing rules

You have context-mode MCP tools available. These rules are NOT optional — they
protect your context window from flooding. A single unrouted command can dump 56
KB into context and waste the entire session. Codex CLI does NOT have hooks, so
these instructions are your ONLY enforcement mechanism. Follow them strictly.

## BLOCKED commands — do NOT use these

### curl / wget — FORBIDDEN

Do NOT use `curl` or `wget` in any shell command. They dump raw HTTP responses
directly into your context window. Instead use:

- `mcp__context-mode__ctx_fetch_and_index(url, source)` to fetch and index web
  pages
- `mcp__context-mode__ctx_execute(language: "javascript", code: "const r = await fetch(...)")`
  to run HTTP calls in sandbox

### Inline HTTP — FORBIDDEN

Do NOT run inline HTTP calls via `node -e "fetch(..."`,
`python -c "requests.get(..."`, or similar patterns. They bypass the sandbox and
flood context. Instead use:

- `mcp__context-mode__ctx_execute(language, code)` to run HTTP calls in sandbox
  — only stdout enters context

### Direct web fetching — FORBIDDEN

Do NOT use any direct URL fetching tool. Raw HTML can exceed 100 KB. Instead
use:

- `mcp__context-mode__ctx_fetch_and_index(url, source)` then
  `mcp__context-mode__ctx_search(queries)` to query the indexed content

## REDIRECTED tools — use sandbox equivalents

### Shell (>20 lines output)

Shell is ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`,
`pip install`, and other short-output commands. For everything else, use:

- `mcp__context-mode__ctx_batch_execute(commands, queries)` — run multiple
  commands + search in ONE call
- `mcp__context-mode__ctx_execute(language: "shell", code: "...")` — run in
  sandbox, only stdout enters context

### File reading (for analysis)

If you are reading a file to **edit** it → reading is correct (edit needs
content in context). If you are reading to **analyze, explore, or summarize** →
use `mcp__context-mode__ctx_execute_file(path, language, code)` instead. Only
your printed summary enters context. The raw file stays in the sandbox.

### grep / search (large results)

Search results can flood context. Use
`mcp__context-mode__ctx_execute(language: "shell", code: "grep ...")` to run
searches in sandbox. Only your printed summary enters context.

## Tool selection hierarchy

1. **GATHER**: `mcp__context-mode__ctx_batch_execute(commands, queries)` —
   Primary tool. Runs all commands, auto-indexes output, returns search results.
   ONE call replaces 30+ individual calls.
2. **FOLLOW-UP**: `mcp__context-mode__ctx_search(queries: ["q1", "q2", ...])` —
   Query indexed content. Pass ALL questions as array in ONE call.
3. **PROCESSING**: `mcp__context-mode__ctx_execute(language, code)` |
   `mcp__context-mode__ctx_execute_file(path, language, code)` — Sandbox
   execution. Only stdout enters context.
4. **WEB**: `mcp__context-mode__ctx_fetch_and_index(url, source)` then
   `mcp__context-mode__ctx_search(queries)` — Fetch, chunk, index, query. Raw
   HTML never enters context.
5. **INDEX**: `mcp__context-mode__ctx_index(content, source)` — Store content in
   FTS5 knowledge base for later search.

## Output constraints

- Keep responses under 500 words.
- Write artifacts (code, configs, PRDs) to FILES — never return them as inline
  text. Return only: file path + 1-line description.
- When indexing content, use descriptive source labels so others can
  `search(source: "label")` later.

## ctx commands

| Command       | Action                                                                            |
| ------------- | --------------------------------------------------------------------------------- |
| `ctx stats`   | Call the `stats` MCP tool and display the full output verbatim                    |
| `ctx doctor`  | Call the `doctor` MCP tool, run the returned shell command, display as checklist  |
| `ctx upgrade` | Call the `upgrade` MCP tool, run the returned shell command, display as checklist |

## Communication and documentation

Use the `caveman:caveman` skill at **lite** intensity by default in every
conversation, unless I explicitly request another style.

Apply lite style to replies, progress updates, explanations, and documentation
you create or edit, including READMEs, technical notes, and code documentation.
Keep articles, complete sentences, and a professional tone. Remove filler and
repetition. Preserve technical detail, necessary uncertainty, and clear
reasoning.

This documentation preference overrides any skill boundary that would otherwise
exclude documentation from the style. Keep code, identifiers, commands, and
quoted errors unchanged. Follow required document templates. Expand explanations
when needed for clarity or safety.

If the skill is unavailable, follow these lite-style rules directly.

## Automatic subagent delegation

Always prefer spawning subagents wherever feasible. Make delegation the default
for concrete, bounded subtasks that can run independently alongside useful work
in the main thread, including work beyond the patterns below. Use the matching
configured agent for listed patterns and the closest suitable available agent
for other work. This is standing authorization to spawn subagents without asking
again. Match the work required, not incidental keywords. Preserve the exceptions
below for trivial or strictly sequential work, unavailable agents, and concurrency
limits; avoid redundant delegation. Adversarial reviews must still follow their
fresh-context rules.

| Work pattern                                                                                                | Agent                  |
| ----------------------------------------------------------------------------------------------------------- | ---------------------- |
| Find definitions, callers, symbol usages, or bounded code relationships.                                    | `code_crawler`         |
| Analyze subsystem relationships, data flow, design tradeoffs, or change impact.                             | `architecture_analyst` |
| Write or revise READMEs, Markdown documentation, Notion content, or PR descriptions from gathered evidence. | `documentation`        |
| Find or verify information on the public web, including authoritative documentation and source comparisons. | `web_researcher`       |
| Retrieve or summarize information from connected systems such as Notion, Linear, GitHub, Forgejo, or Slack. | `external_reader`      |
| Perform an adversarial review of correctness, assumptions, failure handling, or validation.                 | `adversarial_reviewer` |

- Use the matching `agent_type` and its configured model and reasoning settings.
  Agent definitions live in `agents/` and are registered in `config.toml`.
- Split independent questions across agents when useful. Reuse an existing agent
  for related follow-up work. Keep dependent steps sequential and respect the
  available concurrency limit.
- Give each agent the objective, relevant context, scope, constraints, and
  expected output. Request concise findings with file references or source links
  and unresolved questions.
- For edits, assign explicit file ownership. Tell the agent it shares the
  workspace, must preserve others' edits, and must accommodate concurrent
  changes.
- Continue separate useful work while the agent runs. Avoid duplicating its
  investigation. Review its output and integrate the result before reporting
  completion.
- Keep trivial work and tasks with no independent parallel subtask in the main
  thread. If the matching agent is unavailable, proceed locally and state the
  limitation briefly.
- Subagents inherit the context-mode routing rules, caveman lite style, and the
  user's edit and approval boundaries. Delegation does not authorize publishing,
  sending messages, or other actions beyond the user's request.

### Adversarial reviews

- Use `adversarial_reviewer` for adversarial review work; do not automatically
  add a review after every task.
- Always spawn a new instance with `fork_turns="none"`. Never reuse a reviewer,
  including for a repeat review after fixes. This overrides the general
  agent-reuse guidance.
- Provide factual requirements, acceptance criteria, review scope, target paths
  or revisions, and applicable operational constraints. Exclude conversation
  history, previous findings, proposed conclusions, and implementation defenses.
- Have the reviewer inspect the evidence independently. Require actionable
  findings with severity, file references or source links, and concrete failure
  scenarios. Reporting no findings is valid; do not invent defects to satisfy
  the adversarial role.
- Keep the review read-only and return findings to the main agent for
  assessment. Explicitly include context-mode routing, caveman lite style, and
  the user's edit and approval boundaries in the fresh task prompt.
- A clean run means fresh conversation context, not an isolated checkout. Shared
  workspace files remain visible. Do not consult prior review artifacts or
  session memories to reconstruct excluded context. Fresh context reduces
  inherited bias but does not guarantee an assumption-free review.
