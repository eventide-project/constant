# "Work status" prints a fixed five-part report

When the human asks for **work status** (or "project status"), produce a report with these five parts, in this order:

1. **Task plan table** — the active plan's tasks as a table: number, task, status (done / next / pending), and a terse note. Mark the next task. Include the out-of-sequence extras already built.
2. **Deferred work table** — the items under `agent/deferred/`: name, date, kind (chore vs. open design question), one-line gist. These are parked, off the task line.
3. **Memory-retired note** — a short explanation that the auto-memory system is retired for this project; durable context lives in-repo under `agent/`, committed to git. (See the retire-repo-memory decision.)
4. **Agent-directory orientation** — a basic map of `agent/` (`rules/`, `log/`, `plans/`, `design/`, `observations/`, `deferred/`, `sessions/`) and how to work with it: rules are enforceable conventions; the log is title-only ISO-8601-UTC decision entries; a rule typically pairs with a log entry; plans hold the task checklist; deferred holds parked work.
5. **Recent flows of work** — a brief of the recent direction, drawn from the latest log/commit entries (a few lines, not an exhaustive list).

Keep each part tight. Read current state before printing — do not report stale task counts, suite numbers, or deferred items from memory.

**Why:** "Work status" is a recurring request with a known shape; fixing the format makes the report repeatable and complete, and steers reading toward the in-repo sources of truth rather than recollection.

**How to apply:** On a work-status request, render the five parts above from current files (`agent/plans/`, `agent/deferred/`, `agent/log/`, git). Confirm the suite count from the latest log or by running tests rather than asserting it.
