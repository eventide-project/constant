# At the assertion hinge, show the actuation together with the assertion

When presenting the assertion hinge (hinge 2 of the cycle), show the **actuation and the assertion together** — not the assertion alone. The assertion examines what the actuation produced; it can only be judged against the call that yields the value under test.

**Why:** An assertion in isolation (`assert(namespace == other_namespace)`) doesn't reveal what is being checked or whether it witnesses the outcome — that depends entirely on the actuation that produced the value. Showing the call alongside the assertion lets the human judge the pair: does *this* assertion, on the result of *this* actuation, establish the outcome? This is the same impulse as the controls hinge showing the actuation — **the actuation is the anchor shown at every downstream hinge** (assertion, controls), because each is meaningful only in relation to the call.

**How to apply:** At hinge 2, render the actuation (bound to its explaining variable) followed by the assertion's explaining variables and the `test` block — the call and the check as one block. The actuation was settled at hinge 1; here it is shown for context, not re-decided. Related: the hinge-cycle rule, the controls-hinge-shows-actuation rule (`agent/rules/2026-06-28T16-27-41Z-controls-hinge-shows-actuation.md`), and the test-block-is-assertion-only rule.
