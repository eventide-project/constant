# "Test report" classifies the suite and prints the two-level context hierarchy

When the human asks for a **test report**, classify the automated suite (`test/automated/`) along the axes below, then print the context hierarchy two levels deep. **Re-derive everything from the current files** — read the tests and recompute membership and counts; do not report stale buckets from memory. The classification framework below is the discovered shape as of this rule's writing; the suite evolves (e.g. when the legacy `Import`/`Define` tests are conformed, the generation split narrows), so treat the axes as the lens and recompute what falls where.

Produce these sections, in order:

1. **Generations / styles** — the dominant split. The plan-driven `Constant`-class tests follow the recent conventions: one outcome per file, the actuation captured into a setup local, the `test` block assertion-only, no inline call arguments, `comment`-only instrumentation. The legacy `Import`/`Define` tests predate those conventions: multi-outcome files, loop-generated sub-contexts, actuation sometimes performed inside the assertion block, positional `inherit=true` idiom, `detail` as well as `comment`. State which files fall in each generation. The cleanest mechanical tell is **actuation placement** — captured in setup (new) vs. inside the `test`/`assert_raises` block (legacy).

2. **By area (subject under test)** — `Constant` class (`build/`, `equality/`, `name/`, `namespace/`, `full_name`, `defined_predicate`), `Constant::Define`, `Constant::Import` (core, `alias`, `already_included/*`, `macro/*`). Give the file count per area.

3. **By structural style** — single-outcome leaf (one capability, one assertion); multi-outcome with fan-out (a loop over inner-constant names generating one sub-context each — unique to the Import suite); multi-outcome flat (sibling outcomes, no loop).

4. **By assertion kind** — affirmative `assert`, refutation `refute`, error-raising `assert_raises`. Note the error taxonomies in play (`Constant::Error`, `Constant::Import::Error`, `NameError`).

5. **Other factors** — topology pairs (`top_level` vs `nested` for the same method), normal-path vs error outcomes (e.g. within `build/`), and controls usage (`Controls::Constant.example`, currently module-valued inner constants only).

6. **Context hierarchy, two levels deep** — the same hierarchical tree as the status report's test-suite part: each distinct top-level context with its distinct second-level contexts nested beneath, rendered as an indented tree (`├─`/`└─`). See `agent/rules/2026-06-29T06-41-55Z-status-report-format.md` for the rendering. Stop at two levels.

Keep each section tight.

**Why:** the suite has a discoverable structure worth surfacing on demand — most importantly the two coexisting test generations, which is the frame for the eventual `Import`/`Define` conformance work. Fixing the report's shape makes it repeatable and steers reading to the test files rather than recollection.

**How to apply:** on a test-report request, read `test/automated/` and render the six sections from current state. Confirm membership by reading the files (actuation placement, assertion kind, loop fan-out) rather than asserting it; derive the hierarchy from the first two nesting depths of the `context "…"` declarations.
