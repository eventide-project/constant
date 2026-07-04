# Say "control", not "arrange" or "fixture"

For the setup phase of a test — establishing the known, deterministic inputs
before the actuation — say **"control"** (the controls; controlling the inputs),
not **"arrange"**. Likewise the known input *values* themselves are **controls**
(or "control values"), not **"fixtures"** / "fixture values."

**Why:** the codebase's own term for a test's known inputs is a **control** — the
`control_`-prefixed variables, the `Controls` module, "control values." The setup
phase is where those controls are established, so it *is* the control of the test
in this domain's vocabulary. "Arrange" is imported Arrange/Act/Assert jargon the
reader has to map onto the domain's "control" concept; "control" keeps one term.
This also completes the triad in the domain's own words: the project already says
**actuation** (not call/act), so the phases read control → actuate → assert. Same
literal-naming discipline as the other lexicon rules (green → verified, vendor →
install packages, arm → scenario, cut → increment).

**On "fixture" specifically:** besides being imported xUnit jargon for test
inputs, "fixture" collides with TestBench's own `Fixture` — the context object
that provides `context` / `test` / `assert` / `comment` — so calling the control
values "fixtures" is doubly confusing. They are controls.

**How to apply:** in prose, comments, and docs, call the pre-actuation setup the
**control** of the test (never "arrange"), and its known input values the
**controls** / control values (never "fixtures"). Related: the `control_`
test-variable prefix rule, the actuation-not-call rule, and the other de-slang
lexicon rules.
