# "Status report" prints a fixed six-part report

When the human asks for a **status report** (or "project status"), produce a report with these six parts, in this order:

1. **Task plan table** — the active plan's tasks as a table: number, task, status (done / next / pending), and a terse note. Mark the next task. Include the out-of-sequence extras already built.
2. **Deferred work table** — the items under `agent/deferred/`: name, date, kind (chore vs. open design question), one-line gist. These are parked, off the task line.
3. **Memory-retired note** — a short explanation that the auto-memory system is retired for this project; durable context lives in-repo under `agent/`, committed to git. (See the retire-repo-memory decision.)
4. **Agent-directory orientation** — a basic map of `agent/` (`rules/`, `log/`, `plans/`, `design/`, `observations/`, `deferred/`, `sessions/`) and how to work with it: rules are enforceable conventions; the log is title-only ISO-8601-UTC decision entries; a rule typically pairs with a log entry; plans hold the task checklist; deferred holds parked work.
5. **Recent flows of work** — a brief of the recent direction, drawn from the latest log/commit entries (a few lines, not an exhaustive list).
6. **Test suite** — run the suite and report the count and pass/fail line, plus the suite's **context tree two levels deep, rendered hierarchically**: each distinct **top-level context** (the outermost TestBench context block — e.g. `Constant`, `Define Constant`, `Import Constant`) as a tree root, with its distinct **second-level contexts** (e.g. under `Constant`: `Build`, `Name`, `Namespace`, `Full Name`, `Equality`, `Defined Predicate`) indented as its branches. Use an indented tree (e.g. a fenced block with `├─`/`└─` branches), not an inline list. Stop at two levels — do not descend into the per-assertion contexts below.

Keep each part tight. Read current state before printing — do not report stale task counts, suite numbers, contexts, or deferred items from memory.

**Why:** A status report is a recurring request with a known shape; fixing the format makes the report repeatable and complete, and steers reading toward the in-repo sources of truth rather than recollection.

**How to apply:** On a status-report request, render the six parts above from current files (`agent/plans/`, `agent/deferred/`, `agent/log/`, git). Confirm the suite count and the two-level context tree by running the suite rather than asserting them. The two levels are the outer two indentation levels of the output (the unindented name under each `Running …` line, and the names indented one step beneath it); the authoritative source if the output is ambiguous is the first two nesting depths of `context "…"` declarations in the test files. Exclude comment and assertion lines.
