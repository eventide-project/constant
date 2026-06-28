# Say "actuation", never "call" (for the invocation of the unit under test)

The invocation of the unit under test — what the test actuates, the first efferent reference — is the **actuation**. Do not call it "the call," "the call shape," or "the call site." Say **actuation** (and "actuation shape"; use "use site" for where it is invoked, per the efferent rule).

**Why:** "Actuation" is the project's established noun for the invocation (the test *actuates* the unit); holding to it keeps the TDD vocabulary consistent and avoids the looser, mechanism-flavored "call." This **tightens** the efferent-not-caller rule, which had said "the call to the unit under test" was fine — that allowance is withdrawn: it is the actuation.

**How to apply:** In TDD prose, rules, logs, commit messages, and dialogue, say "actuation" for the invocation of the unit under test, "actuation shape" for its form, and "use site" for where it is invoked. (The verb "to call a method" in a pure-mechanism sense, and "call it X" meaning *name* it, are different uses and not covered.) Related: the efferent-not-caller rule (amended), the actuation-gate options-or-chat rule, the hinge-cycle rule, and the human-in-the-loop rule.
