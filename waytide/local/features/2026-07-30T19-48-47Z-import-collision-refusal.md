# Feature — Import collision refusal

## Intent

`Constant::Import.()` reads every constant an origin module owns and assigns each one
onto the destination with no check, so a name already defined there is silently
replaced. The caller names an **origin module**, not a list of names, so they cannot see
the collision coming and the only signal is Ruby's own warning.

Two parts, built together:

- **Refuse the collision.** Before each assignment, test whether the destination already
  defines that name directly and raise `Constant::Error` naming the constant, the origin,
  and the destination.
- **Take selection keywords.** With collisions refused, the use site needs a way to
  resolve one deliberately — `import EnvVar, except: :Log`, or the more conservative
  `import EnvVar, only: [:Controls, :Error]`, where the imported surface is declared
  rather than inferred so a constant added to the origin later cannot silently appear.
  Both keyword names are proposals, not settled; they are a naming decision for the
  hinges.

Refusal alone leaves the failing use site with no way forward; the keywords alone leave
the silent overwrite in place for everyone who does not yet know to reach for them.

The feature originates in the deferred item
`2026-07-30T19-22-38Z-import-refuses-a-colliding-constant.md`, which is deleted and
logged when this feature concludes.

## Setup

- **State:** Completed
- **Upstream branch:** `master`
- **Feature branch:** `feature/import-collision-refusal`
- **Base:** `3ae681a8581f140dc621a80f24d9d5cd994f7750` on `master`
- **Working location:** Branch only — this working tree switched to the feature branch,
  and switches back to `master` at the conclusion.

## Settled before building

**The prior `Define` decision does not govern `Import`.** The 3 July coverage audit held
that `Define` behaves exactly as Ruby's `const_set` — overwrite plus warning — so there
is no library policy to protect and a redefinition test would test Ruby rather than the
library. That decision produced the `do-not-test-the-platform` rule, and it reads as
though it already answers this feature's question. It does not.

The 3 July decision rests on `Define` being a transparent pass-through: its whole body is
a `nil`-default and the `const_set`. That antecedent is false for `Import`, which already
carries policy of its own — it refuses top-level inclusion, refuses a destination that
already includes the origin, normalizes a non-module destination to its class, and fixes
`inherit` to `false`. A unit that already refuses twice is not one whose behavior is the
platform's, and the collision refusal sits in the same method as one of those refusals,
raising the same error class.

The asymmetry the deferred item names is kept as the reason transparency suited `Define`:
a `Define` caller **names the one constant**, so Ruby's overwrite semantics are their own
choice made with the name in hand, while an `Import` caller names a module and receives
assignments they never enumerated.

Recorded at `waytide/local/log/2026-07-30T19-48-47Z-define-transparency-does-not-govern-import.md`.

**What follows for testing.** Once the guard exists it is library policy, so
`do-not-test-the-platform` requires it be tested — that rule's contrast clause, not an
exception to it. Because it is new behavior being designed, a contained red is available.

## Boundary to state during the design

On the `alias:` path, `target` is a **fresh module** built by `Define`, so imported names
can never collide there and the refusal is inert. `Define.(alias_name, destination)`
itself will still silently replace an existing constant at `alias_name` — a genuine
`Define` call with the caller naming the constant, so the 3 July decision does cover it.
The design states this deliberately rather than inheriting it silently.

## Progress

- **The refusal is built and covered.** `test/automated/import_constant/collision.rb`,
  outcome named `Fails` under a `When the destination already defines the constant`
  context.
- **`except:` is built and covered.** `test/automated/import_constant/except/except.rb`, two
  outcomes: `Excluded constant is not imported` and `Constants that are not excluded are
  imported`.
- **`only:` is built and covered.** `test/automated/import_constant/only/only.rb`, two
  outcomes: `Constants that are not included in the only: list are not imported` and
  `Constants in the only: list are imported`. It is a **declaration** rather than a filter —
  a name it gives that the origin does not own raises, covered by
  `only/undefined.rb`. That refusal was written at the implementation hinge ahead of a test
  and was covered as coverage rather than designed, green on arrival.
- **The remaining-collision property is covered.** A collision among the names a keyword did
  *not* remove still raises — `except/collision.rb` and `only/collision.rb`. This is the
  property the filter-first implementation was chosen for, and until these existed an
  implementation that applied the filtering after the check, or that let either keyword
  disable the check outright, would have passed the suite.

## Confirmations

- **Thu Jul 30 2026 at 12:48:47 PM PT** — the `Define` reconciliation settled: the prior
  decision does not govern `Import`, on the ground that its transparency antecedent fails
  there. The feature proceeds.
- **Thu Jul 30 2026 at 12:48:47 PM PT** — working location chosen at initiation: **branch
  only**.
- **Thu Jul 30 2026 at 3:22:00 PM PT** — the remaining-collision coverage is sequenced
  after `only:` rather than designed now or deferred past the feature.
- **Thu Jul 30 2026 at 6:11:37 PM PT** — the feature is concluded as **Completed** and
  integrated into `master`.

## Conclusion

**Completed** — integrated into `master` on Thu Jul 30 2026 at 6:11:37 PM PT, the 13
commits fast-forwarding since `master` was an ancestor of the branch. Verified before
integrating: every commit on the branch ran the suite, and the suite passed at **114 tests**
immediately before the merge, from 104 when the feature began.

`Constant::Import` refuses four conditions, each covered — a name the destination already
defines; a name in `only:` the origin does not own; a name in both `only:` and `except:`;
and a name still colliding after either keyword narrowed the set.

**The originating deferred item is deleted**, its resolution recorded at
`waytide/local/log/2026-07-31T01-08-49Z-import-collision-refusal-is-carried-out.md`. Both
keyword names it proposed were adopted; the two further refusals were not anticipated by it.

**Three deferred items were registered during the feature and were gated on it.** They
become actionable now: conforming the `Import` and `Define` test controls to the
module-variable suffix rule; whether a name the destination **inherits** should collide,
which is silent today and untested; and renaming the nine `"Is an error"` tests to
`"Fails"`. The last two overlap on `already_included.rb` and `alias.rb`.

**One convention was stated and deliberately not recorded here** — that a feature's normal
path and its exception paths belong in separate test files. It was applied throughout and
printed in Waytide rule format for placement in the testing package rather than in this
project's local rules.

**What is not settled by this feature:** `env-var` pull request #3 merges either after
adopting the keyword or before it with the two warning lines accepted for the interim. That
call is the engineer's.

## Design record

The feature's design — each pass's hinge, the options put to the developer, and the
decision — is recorded in its loop record,
`waytide/local/loops/2026-07-30T20-27-23Z-import-collision-refusal.md`, in nineteen passes.
Passes 0 through 5 were written live; 6 through 18 were written at the close and are marked
as such.

## What is waiting on it

`env-var` pull request #3 is open and blocked on the outcome. It merges either after this
change is integrated and its `test_init.rb` adopts the keyword, or before it with the two
warning lines accepted for the interim. That call is the engineer's and has not been
made.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 12:48:47 PM PT
Changed by Scott Bellware on Thu Jul 30 2026 at 3:22:00 PM PT
Changed by Scott Bellware on Thu Jul 30 2026 at 4:02:18 PM PT
Changed by Scott Bellware on Thu Jul 30 2026 at 6:11:37 PM PT
