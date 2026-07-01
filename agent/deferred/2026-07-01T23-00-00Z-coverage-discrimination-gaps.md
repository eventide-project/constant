# Coverage-gap audit: mutations that pass the suite but are defective

The suite is strong on the happy path and value/identity outcomes, but does not
**discriminate** wherever behavior is conditional on an argument the tests hold
constant, incidental to the asserted value, or deeper than one step. Each item
below is a change that would keep the suite verified yet be genuinely defective —
i.e. a missing discriminating test. Distinct from the
`import-define-test-convention-audit` (which conforms *existing* tests to
conventions); this queues *new* tests to close discrimination gaps.

## Tier 1 — whole behaviors unverified

1. **`inherit` is completely untested.** No test passes `inherit:` at all. Ignoring
   it (hard-coding `false` or `true`), deleting the `inherit ||= false` coalescing,
   or not threading it through the nested-path recursion — all pass. Add a
   discriminating ancestor-resolution test (a constant reachable only via
   ancestry): default `false` does **not** resolve it, `inherit: true` does — for
   `#get` / `Constant.get`, `defined?`, `#constants`, and instance `#defined?`.
2. **Error messages are untested.** All 8 `assert_raises` check only the exception
   *class*. Add assertions on message content where it matters: the
   `Constant::Error` "not defined in …" messages (naming the correct segment /
   namespace), and the coercion `TypeError` `"can't convert nil into Constant"`
   (and the class-name form, `"can't convert Integer into Constant"`).
3. **`Constant::Define` need not create a module.** `define_constant.rb` only
   asserts the name is defined and the return `==` `const_get`. Since `const_set`
   accepts any value, `Define` could assign a String and still pass. Assert the
   result **is a module** (`instance_of?(::Module)` / `is_a?(::Module)`).

## Tier 2 — input and branch gaps

4. **Symbol name inputs** are unexercised for `get` / `defined?` / `Define` (see the
   sibling note in the string-outputs-permissive-inputs discussion). Add
   Symbol-input cases so a guard/coercion that broke Symbols would be caught.
5. **Non-nil un-coercible values.** `coerce/uncoercible.rb` tests only
   `Constant(nil)`. Add `Constant(42)` / `Constant(:sym)` — this also exercises the
   type guard's class-name message branch (never run today).
6. **`Constant.get` with a `Constant` as the namespace.** The
   `namespace.is_a?(Constant)` branch in `Constant.get` isn't exercised (tests pass
   a module or a name string). Add a case passing a `Constant` as the namespace.

## Tier 3 — depth and edge cases

7. **Only 2-segment paths are tested.** Every nested-path test uses `"A::B"`. Add a
   3+-segment path (`"A::B::C"`) so a mis-recursion beyond one level is caught.
8. **Redefinition in `Define`.** Defining an already-defined name is untested —
   pin the intended overwrite-vs-error behavior once decided.

**How to apply:** add the discriminating tests test-first (they should each fail
against a deliberately-mutated implementation, then pass against the real one),
prioritizing Tier 1. Keep the suite verified. Delete this file and add an
`agent/log/` entry when complete (or split into per-tier follow-ups if large).
