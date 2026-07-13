# Conform live "efferent-oriented design" references to Design By Efferent (DBE)

Sweep the **active** artifacts that still name the methodology "efferent-oriented design" (or lean on "TDD"/"development" as its name) and conform them to **Design By Efferent** / **DBE**, per the new terminology rule (`agent/rules/terminology/2026-07-13T20-50-37Z-design-by-efferent.md`).

Known live occurrences of "efferent-oriented" (from a grep at record time):
- `agent/rules/methodology/2026-06-20T18-07-21Z-tdd-as-design-tool.md`
- `agent/rules/methodology/2026-07-03T16-00-00Z-first-implementation-may-run-a-contained-red-green-loop.md`

Also re-grep at conform time for `efferent-oriented` across `agent/` and `README.md`, and check the design docs and observations for the retired name. **Historical records keep their words** — do not rewrite `agent/log/` entries or session transcripts (e.g. the `categorized-rules-into-subdirectories` log that mentions the term); conform only rules, observations, design docs, and README prose that speak in the present.

Scope note: conform the retired *name* "efferent-oriented design" → DBE. Do **not** mass-rename every "TDD" mention — TDD is the genus DBE belongs to; only the methodology's *name* changed. The lexicon term `efferent` is unaffected.

**Gated on:** nothing in flight — actionable whenever a terminology pass is spent.

**Why:** the DBE naming decision was recorded going-forward (rule + log now), with the broad prose conformance deliberately deferred so it doesn't interrupt other work.

**How to apply:** make the edits, verify no live artifact still names the methodology "efferent-oriented design," commit, and delete this file with an `agent/log/` entry recording the sweep. Related: the DBE rule and its log `agent/log/2026-07-13T20-50-37Z-name-methodology-design-by-efferent.md`.
