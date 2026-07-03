# Coverage-gap audit: mutations that pass the suite but are defective

The suite is strong on the happy path and value/identity outcomes, but does not
**discriminate** wherever behavior is conditional on an argument the tests hold
constant, incidental to the asserted value, or deeper than one step. Each item
below is a change that would keep the suite verified yet be genuinely defective —
i.e. a missing discriminating test. Distinct from the
`import-define-test-convention-audit` (which conforms *existing* tests to
conventions); this queues *new* tests to close discrimination gaps.

## Tier 1 — whole behaviors unverified

1. **`inherit` — RESOLVED** (2026-07-03). Added `When inherit is true`/`false`
   discrimination pairs via a new `ancestor:` control on `Controls::Constant.example`
   (a constant reachable only via ancestry: resolvable/visible with `inherit: true`,
   absent with `inherit: false`), covering `Constant.get`, `Constant::Module#constants`,
   `#constant_names`, class-level `Constant.defined?`, and instance `#defined?`
   (module form). Green-on-arrival coverage. Log:
   `agent/log/2026-07-03T17-00-00Z-covered-inherit-conveyance-across-all-surfaces.md`.
2. **Error messages — RESOLVED** (2026-07-03). Reconsidered via a new
   sole-discriminator rule (assert message content only where the same error class is
   reachable from multiple sites in one execution path): reduced to the two `::`-path
   cases — `nested_undefined` (`Constant::Error` at the head vs the tail segment) and
   `nested_into_literal` (the module "not defined" site vs the literal "primitive
   value" `#get`) — where the message is the sole discriminator (commit `e8c651f`).
   The single-site coercion `TypeError` and `Literal#get` errors keep class-only
   assertions. Rule:
   `agent/rules/2026-07-03T18-00-00Z-assert-error-message-only-as-sole-discriminator.md`.
3. **`Constant::Define` — RESOLVED** (2026-07-03). Reconsidered rather than closed as
   written: instead of asserting `Define` is module-only, made `Define`
   **type-agnostic** — it takes an optional `constant_value` (default: a new module,
   preserving the `Import` alias-target path), so a literal can be defined. Tests
   reorganized into `define_constant/{module,literal}.rb`; the module-default case
   now asserts the result is a module (`instance_of?(::Module)`), closing the
   original gap. Log:
   `agent/log/2026-07-03T17-30-00Z-define-made-type-agnostic.md`.

## Tier 2 — input and branch gaps

4. **Symbol name inputs** are unexercised for `get` / `defined?` / `Define` (see the
   sibling note in the string-outputs-permissive-inputs discussion). Add
   Symbol-input cases so a guard/coercion that broke Symbols would be caught.
   *(Partial, 2026-07-03: the coercion's Symbol path is now covered and fixed —
   `coerce/namespace_name/symbol.rb`, commit `83e92be` — which exercises `get` with a
   Symbol transitively. Direct Symbol cases for `get` / `defined?` / `Define` remain.)*
5. **Non-nil un-coercible values — RESOLVED** (2026-07-03). Reconsidered: `Constant(42)`
   is behaviorally identical to `Constant(nil)` (same `else` branch), and its only
   distinct effect — the message's class-name arm — is a single-site `TypeError`, so
   per the sole-discriminator rule it is not worth asserting; no test added. The
   `Constant(:sym)` half instead surfaced a **defect**: the coercion accepted only
   Module/String, so `Constant(:sym, ns)` raised `TypeError` though `Constant.get`
   resolves Symbol names. Fixed (Symbol added to the guard), test-first, commit
   `83e92be` — see also item 4.
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
