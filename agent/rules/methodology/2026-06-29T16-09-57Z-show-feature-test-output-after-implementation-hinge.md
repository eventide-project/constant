# After any implementation hinge, show the test output for the current feature

Every time an implementation hinge (hinge 4 of the cycle) is satisfied — the just-accepted implementation is written and the suite run — **show the test output for the current feature**, without being asked. Not just the single outcome's test: run and display the **whole feature's** tests (every outcome built so far for the unit under development), so the human sees the feature's accumulated behavior at each implementation step.

Run the feature's tests with verbose output (`D=on`) so the context tree, `comment`/`detail` narration, and pass/fail are visible, and show that output in the same turn as reporting the implementation.

**Why:** the implementation hinge is where solubility is judged, and solubility is judged against behavior, not code. Showing the *feature's* output — all its outcomes together — keeps the growing efferent contract in view as it accumulates, so the human deliberates the new outcome in the context of the ones already established rather than in isolation. Surfacing it automatically keeps the loop's load-bearing artifact present without the human asking each turn.

**How to apply:** after writing an accepted implementation and running the suite, run the current feature's test file(s) with `D=on` and include that output in the turn that reports the implementation, then hand over the solubility gate. This sharpens the show-the-test-after-implementing rule (`agent/rules/methodology/2026-06-27T23-28-32Z-show-the-test-after-implementing.md`) — that rule shows the just-satisfied test; this one requires the **feature's full test output** at **every** implementation hinge. Related: the hinge-cycle rule, the human-in-the-loop rule, and the one-outcome-at-a-time rule.
