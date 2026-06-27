# Reconcile the test-convention rules with the unnamed-`test` form

The namespace tests (`test/automated/constant/namespace/{nested,top_level}.rb`) were simplified to actuate the subject once, capture the return value in an explaining variable, and assert it in a single **unnamed** `test` block — with no inner outcome `context`. This departs from three existing rules that assume a named outcome context per assertion:

- `agent/rules/2026-06-20T18-13-51Z-tdd-test-structure.md` — "one inner `context` per outcome", outcome title states the outcome.
- `agent/rules/2026-06-26T21-27-24Z-test-name-is-prefix.md` — governs how an outcome context is named ("Is …" only for value-equals-comparator); moot when there is no named context.
- `agent/rules/2026-06-26T21-38-52Z-test-context-nesting-mirrors-folders.md` — ends "in the outcome context(s)".

**Gated on:** the current `Constant#namespace` TDD task being settled (red test driving the method into existence, then green).

**Why:** the simplified form was a deliberate, user-directed choice for these single-outcome cases, but it now sits in tension with the written rules. The rules and the code should not disagree; one of them has to move. Whether the unnamed-`test` form is the new norm for single-outcome files, an allowed alternative, or specific to this case is itself the open question — not yet decided.

**How to apply:** once the namespace task is done, decide the scope of the unnamed-`test` form and update the affected rules accordingly (amend the test-structure rule, and note the interaction in the test-name and folder-mirroring rules), with a matching `agent/log/` entry. Then delete this file.
