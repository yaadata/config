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

Default to concise, professional prose in replies, progress updates, explanations,
and documentation unless I request another style. Keep articles and complete
sentences. Remove filler, repetition, pleasantries, and unnecessary hedging.
Preserve technical detail, necessary uncertainty, and clear reasoning. Keep code,
identifiers, commands, and quoted errors unchanged. Follow required document
templates. Expand when clarity or safety requires it. Apply these rules directly;
do not load a style skill.

## Automatic subagent delegation

Default to delegation for bounded subtasks that can run alongside useful main-thread
work, including unlisted work. No permission needed. Match actual work to the listed
agent or closest suitable alternative, not keywords. Keep trivial or sequential
work local; respect concurrency limits. If unavailable, proceed locally and briefly
state the limitation.

| Work pattern                                                                                                | Agent                  |
| ----------------------------------------------------------------------------------------------------------- | ---------------------- |
| Find definitions, callers, symbol usages, or bounded code relationships.                                    | `code_crawler`         |
| Analyze subsystem relationships, data flow, design tradeoffs, or change impact.                             | `architecture_analyst` |
| Write or revise READMEs, Markdown documentation, Notion content, or PR descriptions from gathered evidence. | `documentation`        |
| Find or verify information on the public web, including authoritative documentation and source comparisons. | `web_researcher`       |
| Retrieve or summarize information from connected systems such as Notion, Linear, GitHub, Forgejo, or Slack. | `external_reader`      |
| Perform an adversarial review of correctness, assumptions, failure handling, or validation.                 | `adversarial_reviewer` |

- Use configured `agent_type`, model, and reasoning settings (`agents/`, `config.toml`).
- Parallelize independent questions; keep dependencies sequential. Reuse agents for
  related follow-ups except adversarial reviews.
- Provide objective, context, scope, constraints, and expected output: concise
  findings with references and unresolved questions.
- Assign file ownership for edits; require preserving and accommodating others'
  changes in the shared workspace.
- Continue separate useful work, avoid duplication, and assess and integrate results
  before reporting completion.
- Agents inherit context-mode routing, concise style, and user edit/approval
  boundaries. Delegation grants no additional publishing, messaging, or other authority.

### Adversarial reviews

- Do not add reviews automatically. Always use a new `adversarial_reviewer` with
  `fork_turns="none"`, including after fixes.
- Supply factual requirements, acceptance criteria, scope, paths/revisions, and
  operational constraints. Explicitly include routing, style, and user boundaries.
  Exclude history, prior findings, proposed conclusions, and implementation defenses;
  never reconstruct them from review artifacts or memories.
- Require independent, read-only inspection and actionable findings with severity,
  references, and concrete failure scenarios. No findings is valid; never invent
  defects. Return findings for main-agent assessment.
- Fresh context does not isolate shared files or eliminate assumptions.
