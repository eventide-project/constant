# The nine `test "Is an error"` tests are named `test "Fails"`

Every `assert_raises` test in the suite is named `"Is an error"`. Two binding rules call
for `"Fails"`:

- The testing package's **error-test-named-fails-condition-is-context** rule fixes the name
  as `"Fails"` (or `"Doesn't fail"`) and promotes the condition to a `context`.
- **test-name-is-prefix** reserves `"Is"` for a value-equals assertion, and lists a raised
  error among its counter-examples, pointing at the rule above.

`test/automated/import_constant/collision.rb` was named `"Fails"` on 2026-07-30 when the
question was reached during the `import-collision-refusal` feature, so the suite now
carries both spellings. This item removes the older one.

## Seven are a rename alone

Each already sits in a `When …` context, so only the test's name changes:

```
constant/literal/get.rb:17               When the name is not defined
constant/module/get/undefined.rb:15      When the name is not defined
constant/module/get/nested_undefined.rb:20   When the final segment is not defined
constant/module/get/nested_into_literal.rb:22  When a mid-path segment is a literal constant
constant/coerce/uncoercible.rb:8         When the value is not a module, a name, or a Constant
constant/get/undefined.rb:12             When the name is not defined in the namespace
constant/get/inherit.rb:26               When inherit is false
```

## Two need the condition decided first

**`import_constant/already_included/already_included.rb:19`** sits directly in
`context "Already Included"` with no condition context. `collision.rb` — the same kind of
refusal, in the same method — was given
`context "When the destination already includes the origin"`-style nesting, so the parallel
form is available and would make the two refusals read alike.

**`import_constant/alias.rb:117`** sits inside a dynamic `context inner_constant_name.inspect`,
under `context "Imported constants are not defined in the destination's root namespace"`.
The enclosing context states an **outcome**, not a condition, so `test "Fails"` beneath it
would read as a second outcome rather than as the failure of a stated condition. What that
context should become is a real decision, not a rename.

## Ordering against the other deferred item

`already_included.rb` and `alias.rb` are also in the file list of
`2026-07-30T21-28-46Z-import-test-controls-conform-to-the-suffix-rule`. Doing both in one
pass over `import_constant/` avoids touching those two files twice; doing them separately
keeps each diff to one convention. Either is fine, but decide before starting rather than
discovering the overlap partway.

**Gated on:** the `import-collision-refusal` feature. Two of the nine are in the directory
the feature is still adding tests to.

**Why:** the suite currently spells the same outcome two ways, which is worse than either
spelling alone — a reader cannot tell whether `"Is an error"` and `"Fails"` mark different
things. `"Is an error"` also misdescribes what it names: `"Is"` promises a value comparison
the assertion does not make, which is the specific defect test-name-is-prefix exists to
prevent.

**How to apply:** once the feature concludes, rename the seven, then settle the condition
context for `already_included.rb` and `alias.rb` before renaming those two. Run the suite —
the change is name-only and the count must not move. Then delete this file and record an
entry in `waytide/local/log/`. Related: the testing package's
error-test-named-fails-condition-is-context and test-name-is-prefix rules, the
context-only-for-local-instrumentation rule, and the deferred item
`2026-07-30T21-28-46Z-import-test-controls-conform-to-the-suffix-rule`.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 3:15:17 PM PT
