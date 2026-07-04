# In TDD, use the term "efferent", never "caller"

In all TDD vocabulary, name the use-site perspective **efferent** — the view that conducts outward from the unit toward its use. Never call it "caller," "caller-side," "caller-first," or "caller's-eye." The test is the first *efferent reference* to the unit; the interface is designed from the *efferent side*; the view that discovers solubility is the *efferent view*.

**Why:** "Efferent" is the project's established term for designing a unit from the outside in — from the standpoint of what uses it. "Caller" is a looser, mechanism-flavored synonym the user does not want mixed in. Holding to one term keeps the TDD rules and prose consistent. ("Efferent in, efferent out.")

**How to apply:** When writing or describing TDD anywhere — rules, design docs, commit messages, decision-log entries, code comments, prose to the user — say "efferent." The invocation itself is the **actuation**, never "the call" (see the actuation-not-call rule, `agent/rules/terminology/2026-06-28T15-08-58Z-actuation-not-call.md`, which withdraws the earlier allowance of "the call to the unit under test"). It is the *perspective* word that is always "efferent," never "caller." Related: the TDD-as-design-tool rule and the actuation-not-call rule.
