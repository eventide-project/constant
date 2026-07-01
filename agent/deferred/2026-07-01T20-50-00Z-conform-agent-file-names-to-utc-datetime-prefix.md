# Conform existing `agent/**` file names to the ISO 8601 UTC datetime prefix

Per the rule `agent/rules/2026-07-01T20-40-00Z-agent-file-names-use-iso8601-utc-prefix.md`,
every file in an `agent/` subdirectory should carry a full
`YYYY-MM-DDTHH-MM-SSZ-<slug>.md` prefix (UTC). **18 files predate the rule** and
still use a date-only prefix (`YYYY-MM-DD-<slug>.md`):

- `loops/` — 11 files
- `plans/` — 2 (`2026-05-29-constant-class.md`, `2026-06-29-constant-literal-restructure.md`)
- `design/` — 2 (`2026-05-22-constant-class-design.md`, `2026-06-20-human-in-the-loop-tdd-design.md`)
- `experiments/` — 1 (`2026-06-26-name-feature-run-1.md`)
- `sessions/` — 1 (`2026-06-26-tdd-ai-and-the-humans-role.md`)

**Process:**
1. For each file, recover its creation time from git —
   `git log --diff-filter=A --format=%aI -- <path>` gives the add-commit's ISO
   timestamp; normalize to UTC and format as `YYYY-MM-DDTHH-MM-SSZ`. Fall back to
   `T00-00-00Z` only where git history is unavailable.
2. `git mv` each file to `<utc-datetime>-<existing-slug>.md`.
3. **Update every cross-reference.** Several `log/` entries and the design doc cite
   loop records (and each other) by path — e.g. "Loop record:
   `agent/loops/2026-07-01-nested-path-strings.md`". Grep for the old names across
   `agent/` (and anywhere else) and repoint them, or the citations break.
4. Verify: no remaining date-only prefixes under `agent/`, and no dangling path
   references to the old names.

**Why:** consistency and unambiguous chronological sorting across all agent
artifacts (the rule's rationale). Purely a naming/reference change — no behavior,
no test impact.

**How to apply:** carry out the four steps above; delete this file and add an
`agent/log/` entry (both already conforming to the prefix rule).
