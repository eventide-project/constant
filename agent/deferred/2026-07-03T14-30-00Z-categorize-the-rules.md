# Separate the rules into categories, and establish the category taxonomy

`agent/rules/` has grown to a large **flat, chronologically-prefixed list** (62
files and counting). The rules span distinct *kinds* of guidance, and would be far
easier to navigate — and to apply the right rules to the right activity — if they
were grouped by category.

**First, establish the categories** (a design decision in its own right; settle it
with the developer before sorting anything). Candidate categories, from what the
current rules cover — a starting point, **not** the final set:

- **Terminology / lexicon** — the de-slang, name-literally rules: verified (not
  green), install packages (not vendor), control (not arrange/fixture), convey (not
  thread), protect (not guard), actuation (not call), scenario (not arm), increment
  (not cut), name-literally-not-by-analogy.
- **TDD / methodology** — the hinge cycle, human-in-the-loop, first-turn,
  actuation-gate options, one-outcome-at-a-time, TDD-designs-vs-coverage-protects,
  hinges-gate-a-test's-design.
- **TestBench / test-writing conventions** — test-block-is-assertion-only,
  assert-raises "Is an error", context-only-for-local-instrumentation, the
  `control_` prefix, namespace-variable suffix, folder-mirroring, single-case-file
  naming, string-outputs / permissive-inputs.
- **Commands** — test tree, next deferred item, status/lib/test reports.
- **Library / code conventions** — build-constructor-normalizes / new-is-strict,
  optional-params-default-in-body, do-not-default-a-delegated-argument.
- **Agent / process** — agent-file-names-use-iso8601-utc-prefix, loop records.

(Some rules may span two categories; decide whether a rule lives in one primary
category or is cross-listed.)

**Open questions to settle when taken up:**
- **How categories are represented** — subdirectories under `agent/rules/`
  (e.g. `rules/terminology/`), a `category:` field in each rule's body/frontmatter
  plus an index, a filename category segment, or an index document that groups the
  flat list. Each has trade-offs; subdirectories change paths.
- **The UTC-datetime prefix** — keep it (per the agent-file-names rule) within
  whatever category representation is chosen.
- **Cross-references** — rules cite each other, and logs/design cite rules by path;
  if categorization moves/renames files, repoint every reference (as the
  agent-file-name conformance pass did), and verify no dangling references remain.

**Why:** 62 flat files are hard to scan and hard to reason about as a system;
categories make the corpus navigable and make it clear which rules govern which
activity (e.g. terminology vs test-writing vs TDD).

**How to apply:** settle the taxonomy with the developer; assign each existing rule
to a category; represent the categories (per the chosen scheme); repoint any
references. Naming/organization only — no behavior, no test impact. Delete this
file and add an `agent/log/` entry.
