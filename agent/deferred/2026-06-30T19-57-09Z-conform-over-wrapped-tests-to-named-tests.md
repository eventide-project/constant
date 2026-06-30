# Conform over-wrapped single-assertion tests to directly-named tests

Per the context-only-for-local-instrumentation rule
(`agent/rules/2026-06-30T19-57-09Z-…`), an outcome that is a single assertion
over in-scope values should be a directly-named `test "…" do … end`, not a bare
`test` wrapped in a named `context`. Many existing Constant-class tests wrap a
lone `test` in a `context` while the explaining variable sits at the top of the
feature context — these are over-wrapped and should be flattened to named tests.

**Candidates (single-assertion outcomes whose explaining variable is at the top):**
`constant/module/full_name.rb`, `constant/module/name/*`,
`constant/module/namespace/*`, `constant/module/equality/*`,
`constant/literal/full_name/*`, `constant/literal/equality/*`,
`constant/literal/constants.rb`, `constant/literal/defined_predicate.rb`,
`constant/defined_predicate/**`, and the `build/` outcomes. Keep a `context`
only where the outcome derives a local explaining variable or adds a local
`comment`/`detail` (e.g. the `define_constant.rb` style).

**Gated on:** a deliberate conforming pass — not urgent, and best done in one
sweep to keep the suite green and the diffs reviewable. Out of scope for the
restructure tasks in flight.

**Why:** the context-wrap carries no information when it only holds a bare test;
flattening keeps the structure honest and the trees shallower.

**How to apply:** for each candidate, move the name onto the `test` and drop the
`context` (keeping the top-of-context arrangement as is). Run the suite. Then
delete this file and add an `agent/log/` entry.
