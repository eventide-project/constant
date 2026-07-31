# Feature — Error tests named Fails

## Intent

Every `assert_raises` test in the suite is named `"Is an error"` — all nine. Two binding
rules call for `"Fails"`:

- The testing package's **error-test-named-fails-condition-is-context** rule fixes the name
  as `"Fails"` (or `"Doesn't fail"`) and promotes the condition to a `context`.
- **test-name-is-prefix** reserves `"Is"` for a value-equals assertion, and lists a raised
  error among its counter-examples, pointing at the rule above.

`import_constant/collision.rb` was named `"Fails"` during the `import-collision-refusal`
feature, when the question was reached, so the suite carries both spellings. This feature
removes the older one.

The change is name-only. The suite's test count must not move.

The feature originates in the deferred item
`2026-07-30T22-15-17Z-error-tests-are-named-fails.md`, which is deleted and logged when
this feature concludes.

## Setup

- **State:** In flight
- **Upstream branch:** `master`
- **Feature branch:** `feature/error-tests-named-fails`
- **Base:** `b02a333c3a8dcb30c13571ccb560f6893bf331e0` on `master`
- **Working location:** Branch only — this working tree switched to the feature branch,
  and switches back to `master` at the conclusion.

## The nine, in two groups

**Seven are a rename alone.** Each already sits in a `When …` context, so only the test's
name changes:

```
constant/literal/get.rb:17                      When the name is not defined
constant/module/get/undefined.rb:15             When the name is not defined
constant/module/get/nested_undefined.rb:20      When the final segment is not defined
constant/module/get/nested_into_literal.rb:22   When a mid-path segment is a literal constant
constant/coerce/uncoercible.rb:8                When the value is not a module, a name, or a Constant
constant/get/undefined.rb:12                    When the name is not defined in the namespace
constant/get/inherit.rb:26                      When inherit is false
```

**Two need their condition settled first.**

`import_constant/already_included/already_included.rb:19` sits directly in
`context "Already Included"` with no condition context. `collision.rb` — the same kind of
refusal, in the same method — was given a `When the destination already defines the
constant` context, so the parallel form is available and would make the two refusals read
alike.

`import_constant/alias.rb:117` sits inside a dynamic `context inner_constant_name.inspect`,
under `context "Imported constants are not defined in the destination's root namespace"`.
That enclosing context states an **outcome**, not a condition, so `test "Fails"` beneath it
would read as a second outcome rather than as the failure of a stated condition. What that
context should become is a decision, not a rename.

## Confirmations

- **Thu Jul 30 2026 at 6:36:48 PM PT** — working location chosen at initiation: **branch
  only**.

## Design record

Recorded in this feature's loop record under `waytide/local/loops/`, added when the first
hinge is worked.

## Ordering against the other deferred items

`already_included.rb` and `alias.rb` also appear in the file list of
`2026-07-30T21-28-46Z-import-test-controls-conform-to-the-suffix-rule`. Whether the two
passes are combined or sequenced is decided before either starts, so those files are not
touched twice.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 6:36:48 PM PT
