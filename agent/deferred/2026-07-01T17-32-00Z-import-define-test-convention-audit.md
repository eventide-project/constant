# Convention audit of the older `Import` / `Define` test suite

The `test/automated/import_constant/` and `define` tests predate several
conventions settled during the `Constant` class work. Recent **targeted** passes
touched them (the control-comment "Control " prefix; the `assert_raises` →
"Is an error" form appears present), but no **deliberate full sweep** has been
done against the current convention set.

**Conventions to audit against (each test file):**
- Named tests over context-wrapping (context only for local instrumentation, or a
  "When …" condition).
- `assert_raises` test named exactly **"Is an error"**, condition promoted to a
  `context`.
- Control string values start with **"some"** (`"some string"`).
- Comment labels printing a control value carry the **"Control "** prefix.
- No **inline method-call arguments** — extract to locals.
- Optional arguments default to **nil**, coalesced in the body (and delegated args
  passed raw, not pre-defaulted).
- Test-block-is-a-single-assertion.
- `control_`-prefixed test variables; namespace-variable suffix rule.
- Folder-mirroring context nesting; single-case-feature file naming.

**Open questions:** none of substance — mechanical conformance plus judgment
where a context is genuinely carrying instrumentation.

**Gated on:** nothing.

**Why:** the newer `constant/` suite sets the house style; the older suite should
match so the whole test tree reads consistently.

**How to apply:** read each file, conform to the current conventions, keep the
suite green throughout. Delete this file and add an `agent/log/` entry (or a short
loop/observation note if it surfaces convention gaps).
