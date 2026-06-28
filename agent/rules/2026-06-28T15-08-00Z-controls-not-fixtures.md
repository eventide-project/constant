# Say "controls", never "fixtures"

The example constants a test is built from — and the `Controls::Constant` helpers that build them (`lib/constant/controls/`) — are **controls**. Never call them "fixtures."

**Why:** "Fixture" is imported xUnit jargon; this ecosystem's vocabulary is **controls** (Eventide / TestBench). Holding to the one term keeps the rules, prose, and dialogue consistent with the code and the AGENTS.md description ("Controls — the TestBench helpers that build example constants for tests"). The word "fixture" was also already rejected once, as a candidate handle for "mechanical."

**How to apply:** In prose, rules, logs, commit messages, and dialogue, say **controls** for the test helpers and the example constants they produce (or "example constants" for the produced values specifically). Never "fixture(s)." Related: the `control_` test-variable prefix rule, and the name-literally-not-by-analogy rule.
