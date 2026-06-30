# Conform "Raises when …" error tests to the "Is an error" + condition-context form

Per the assert-raises-test-named-is-an-error rule
(`agent/rules/2026-06-30T21-20-24Z-…`), an `assert_raises` test is named exactly
"Is an error", with the condition promoted to a wrapping `context` ("When …").

**Candidates** (existing error tests named "Raises when …" or with the
assert_raises inside a condition-named context):
`build/undefined.rb` ("Raises when the name is not defined in the namespace"),
`build/literal.rb`'s predecessor history, and the `import_constant` error tests
(`already_included/already_included.rb` "Raises error",
`import_constant/alias.rb` "Not defined"). Reshape each to
`context "When …" do test "Is an error" do assert_raises(...) … end end`.

**Gated on:** a deliberate conforming pass (best bundled with the
over-wrapped-tests conformance). Out of scope for the construction-interface work
in flight.

**Why:** uniform error-test naming ("Is an error") with the condition where
conditions belong (a context).

**How to apply:** reshape each candidate, run the suite, then delete this file and
add an `agent/log/` entry.
