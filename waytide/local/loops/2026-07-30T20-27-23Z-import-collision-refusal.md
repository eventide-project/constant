# Loop record — Import collision refusal

`Constant::Import.()` assigned every constant an origin module owns onto the destination
with no check, so a name already defined there was silently replaced. This records the
passes that designed the refusal. The selection keywords — the feature's second half —
are not yet designed and will extend this record. The feature's lifecycle is
`waytide/local/features/2026-07-30T19-48-47Z-import-collision-refusal.md`.

## Pass 0 — the settlement before the hinges

**Hinge** — whether the 3 July `Define` decision governs `Import`. The audit held that
`Define` behaves exactly as Ruby's `const_set` — overwrite plus warning — so there is no
library policy to protect. That reasoning reads as though it already forbids this feature.

**Options** — the deferred item's asymmetry ground (a `Define` caller names the one
constant; an `Import` caller names a module); the antecedent-fails ground (`Define` is a
transparent pass-through, `Import` is not); or that the decision does govern and only the
keywords should be built.

**Decision / chat** — the developer asked to have the matter explained plainly before
choosing, and the explanation was rewritten from the ground up. Settled on the
antecedent-fails ground: `Import` already refuses top-level inclusion, refuses a
destination that already includes the origin, coerces a non-module destination to its
class, and fixes `inherit` to `false`. A unit that already refuses twice is not one whose
behavior is the platform's. The asymmetry is kept as the reason transparency suited
`Define`. Recorded at
`waytide/local/log/2026-07-30T19-48-47Z-define-transparency-does-not-govern-import.md`.

## Pass 1 — actuation

**Hinge** — which surface's actuation sets the cradle.

**Options** — the function `Constant::Import.(origin, destination)` with a plain
destination module; the refinement at top level against `Object`, reproducing the
`env-var` failure through a `Controls::Script` subprocess; or the function against
`Object` directly.

**Decision / chat** — the developer asked whether the surfaces are equivalent, and whether
the macro carries anything the function does not. Reading `lib/constant/import/macro.rb`
against the refinement in `lib/constant/import.rb` established that both are the same two
lines — pure delegation to `Import.()` with `self` as the destination and `**kwargs`
passed through — and that every policy lives in `Import.call`. What differs is attachment
and what `self` is: the macro is installed by `include` and refused at the top level, the
refinement is activated by `using` and reaches `Object` through `main`, and the non-module
destination coercion is dead code on the macro path. That finding narrowed the choice: a
check placed in `Import.call` is inherited by all three surfaces, so the candidates differ
only in which surface the test reads as. **Chose the function with a plain destination**,
at `test/automated/import_constant/collision/collision.rb`, beside
`already_included/already_included.rb` — the other refusal, tested through the function.

## Pass 2 — observation

**Hinge** — how much of the outcome the test reads.

**Options** — the raise alone, or the raise together with what the destination holds at the
clashing name afterward. The second forces the check to run over every name before any
assignment, so a refused import changes nothing; the first permits a check inside the
assignment loop.

**Decision / chat** — the developer originated the answer rather than selecting: *if the
actuation raises, the raise is terminal; if someone rescues the error, they get what they
get in an inconsistent state.* The library therefore owes no all-or-nothing guarantee at
the observation. **The raise alone.**

Not gated: the message is asserted rather than the class alone. `Import.call` already
raises `Constant::Error` for the already-included case, so two sites raise the same class
in one execution path — the condition under which
`assert-error-message-only-as-sole-discriminator` requires the message.

## Pass 3 — controls

**Hinge** — how many constants the origin owns.

**Options** — one, which clashes; or two, one of which clashes.

**Decision / chat** — the option descriptions were rejected twice as unreadable, once for
editorializing and once for jargon, and were rewritten in plain terms before the developer
could act on them. **Two, one of which clashes**: with a single constant the test cannot
tell whether the error names the right one, because there is nothing to pick out. `EnvVar`
owns three and clashes on one.

## Pass 4 — implementation

**Hinge** — where the check goes.

**Options** — immediately before each assignment (one pass, earlier names already
assigned when it raises), or over every name before any assignment (two passes, nothing
assigned when it raises).

**Decision / chat** — **before any assignment**, though pass 2 had established that
nothing observes the difference. Not gated: the check runs against `target` rather than
`destination_constant`, so an aliased import — whose `target` is a fresh module built by
`Define` — can never clash.

## Pass 5 — naming

Deferred to the feature's close, per the first-turn rule. The outcome's `test` block is
unnamed.

## Outcome

`lib/constant/import.rb` gains a loop over the origin's own constant names that raises
`Constant::Error` naming the constant, the destination, and the origin when the target
already defines that name directly. `test/automated/import_constant/collision/collision.rb`
covers it. The feature's 12 files run 34 tests, all passing; the full suite is 105 tests,
all passing.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 1:27:23 PM PT
