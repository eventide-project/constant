# Loop record — Import collision refusal

`Constant::Import.()` assigned every constant an origin module owns onto the destination
with no check, so a name already defined there was silently replaced. This records the
passes that designed the refusal and the two selection keywords that let a use site resolve
a collision deliberately. The feature's lifecycle is
`waytide/local/features/2026-07-30T19-48-47Z-import-collision-refusal.md`.

Passes 0 through 5 designed the refusal and were written live. Passes 6 through 18 were
written at the feature's close from the session, so they are lossier than the first six —
the decisions and the substance of each chat are recorded, but not every intermediate
wording.

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

Deferred to the feature's close, per the first-turn rule. Settled in pass 17 below.

# The `except:` keyword

## Pass 6 — actuation, the keyword's name

**Hinge** — what the keyword is called. It has to work as a **pair**, since the second
keyword follows.

**Options** — `except:` / `only:`, or `exclude:` / `select:`.

**Decision / chat** — **`except:` / `only:`**. `Hash#except` is core Ruby and `only:` is
widely used for the same filtering. `exclude:` would naturally pair with `include:`, which
is unusable here — `include` means module inclusion in this exact context, and `Import`
already raises `already includes` — so it would have to pair with something mismatched.

## Pass 7 — the signature

**Hinge** — whether the keyword is declared or read out of `**kwargs`, as `alias` is.

**Options** — declare all the keywords and drop `**kwargs`; declare `except:` and keep
`**kwargs`; or `kwargs[:except]`, uniform with `alias`.

**Decision / chat** — the developer asked **why `alias` uses `kwargs` at all**, which had
been copied without examination. Testing established that `alias:` **can** be declared as a
parameter and the local is created, but `alias` cannot be **read** in the body — it is a
Ruby keyword, and `p alias` is a syntax error. Reaching it needs
`binding.local_variable_get(:alias)`. That is the whole reason for `**kwargs`, and it does
not extend to `except:`. **Declared `except:`, kept `**kwargs`.** The cost, stated at the
gate and accepted: while `**kwargs` remains, a misspelled keyword is still swallowed rather
than raising `ArgumentError`.

## Pass 8 — observation, and the precondition

**Hinge** — what the test reads about the outcome.

**Options** — the first pass at this was **wrong and was rejected**: it compared the
destination's constant against a control named for the collision, in a test about
exclusion, and the developer identified it as self-contradictory — *"an except test that is
asserting that the collision is included"*. The muddle was two scenarios conflated:
excluding a name, and using exclusion to get past a refusal. Re-put as that choice.

**Decision / chat** — the developer **originated the form**: the actuation is wrapped in
`refute_raises` with **no `test` block** — a **precondition**, a bare assertion stating a
condition the outcomes rest on rather than an outcome of its own. Waytide had no such
concept. Verified that TestBench treats it as intended: a satisfied precondition adds
nothing to the test count, a failed one reports `no tests, 1 failure`, exits non-zero, and
the outcomes below it do not run. Recorded as
`waytide/local/observations/2026-07-30T20-47-54Z-a-precondition-is-a-bare-assertion-that-is-not-a-test.md`,
an observation rather than a rule, having been applied once.

The scenario then moved twice more, both times on the developer's direction. First to
excluding a name the destination does not have and proving it absent. Then to the final
form: **the destination carries the colliding constant, and the proof is that the
destination's inner constant is not the same constant as the origin's** — the excluded
constant was not imported over it.

Not gated: `Constant::Error` is raised from more than one site in a single execution path,
so `assert-error-message-only-as-sole-discriminator` requires the message wherever one of
these tests asserts a raise.

## Pass 9 — controls

**Hinge** — whether the excluded name is written as a String or a Symbol.

**Options** — either. The developer asked **whether a Symbol would exercise the
String-to-Symbol coercion** — it would not; `Module#constants` returns Symbols, so a Symbol
control matches directly and nothing normalizes. They then drew a distinction the earlier
framing had blurred: a String control **exercises** the normalization, in that the path
executes and the test fails if it breaks, which is not the same as **covering** it, which
would be a test whose subject is the name forms.

The developer then asked **what the suite's norm is**. Counted: **70 String name controls
against 2 Symbol**, and both Symbol cases are deliberate — `coerce/namespace_name/symbol.rb`
is the Symbol counterpart to its `string.rb` sibling. So a Symbol appears only where the
Symbol form is itself the subject.

**Decision / chat** — **String**, following the norm.

## Pass 10 — implementation

**Hinge** — how `except:` removes the names.

**Options** — subtract them from the name set before anything reads it, or test each name
against the exclusions inside both the check loop and the assignment loop.

**Decision / chat** — **filter the set first.** One set of names then governs both the
collision check and the assignment, so they cannot disagree; the alternative writes the
exclusion twice and leaves the `map` yielding `nil` for skipped names. `Array()` carries
both a single name and a list, and the absent case; `to_sym` normalizes against what
`Module#constants` returns.

## Pass 11 — a rule-scope detour

**Hinge** — whether the module-variable suffix rule reaches `Import`, whose
`origin_constant` and `destination_constant` hold raw modules while the rule reserves
`_constant` for `Constant` instances.

**Options** — the rule reaches it and needs a fourth form for a constant of unknown kind;
narrow the rule to where three forms coexist; or the rule reaches it as written.

**Decision / chat** — the developer settled it directly: **the rule governs test controls,
not implementation locals**. That dissolves the fourth-form question —
`Import.call`'s `import_constant`, which may hold a **literal constant** as readily as a
module, is outside the rule. The rule gained a scope paragraph
(`waytide/local/log/2026-07-30T21-28-46Z-suffix-rule-governs-test-controls-only.md`), and
conforming the tests' own controls was registered as a deferred item rather than done here.

# The `only:` keyword

## Pass 12 — actuation, the keyword's contract

**Hinge** — what `only:` means when it names a constant the origin does not own. The two
keywords are asymmetric here: `except: :Nonexistent` excludes nothing and is harmless,
while `only: [:Nonexistent]` imports nothing when the caller asked for something specific.

**Options** — a **filter**, where the name is ignored, or a **declaration**, where it is
refused.

**Decision / chat** — **a declaration.** A caller who names a constant and does not get it
has been told nothing.

## Pass 13 — observation

**Hinge** — whether the destination pre-defines the name `only:` leaves out.

**Options** — it does, which additionally establishes that a name `only:` omits never
reaches the collision check; or the destination starts empty, proving only that the omitted
name never arrived.

**Decision / chat** — **the destination starts empty.** The interaction with the collision
refusal was covered separately in pass 16.

## Pass 14 — controls

**Hinge** — how many constants `only:` lists.

**Options** — one of two, mirroring the `except:` test, or two of three.

**Decision / chat** — **two of three.** The use site writes `only: [:Controls, :Error]`, so
the list form is what it will be given, and no test had exercised `Array()` on an actual
list.

## Pass 15 — implementation

**Hinge** — how `only:` narrows the set.

**Options** — intersect with the origin's own names, or take the listed names outright. The
refusal has already established that every listed name exists, so the two produce the same
set and differ only in the order the imported constants come back in.

**Decision / chat** — **intersect**, keeping the origin's own order as every other import
path does.

**The undefined-name refusal was written at this hinge, ahead of a test to drive it.** That
was surfaced rather than left, and the developer chose to **cover it as coverage** rather
than back it out and design it — green on arrival, which is correct when protecting
behavior rather than designing it (see the `tdd-designs-coverage-protects` rule). Its
placement was gated — `only/undefined.rb` beside `only/only.rb`, the normal path and the
exception path in separate files — and its controls were gated to the minimal form,
`only:` listing the undefined name alone.

**A convention was stated during this pass and not recorded.** The developer stated that a
feature's normal path and its exception paths belong in separate test files. It was applied
here and printed in Waytide rule format for the developer to place in the testing package
themselves, rather than written into this project.

## Pass 16 — the remaining-collision property

**Hinge** — that a collision among the names a keyword did **not** remove still refuses.
Nothing protected it: an implementation that applied the narrowing after the check, or that
let either keyword disable the check outright, would have passed the whole suite.

**Options** — design it when it was found, defer it past the feature, or sequence it after
`only:` so both keywords' identical cases are done together.

**Decision / chat** — **sequenced after `only:`**, then built as `except/collision.rb` and
`only/collision.rb`. `except.rb` moved into a folder to take its exception-path file.

## Pass 17 — naming

**Hinge** — the outcome names, deferred from pass 5.

**Options and decisions** — the collision test is **`Fails`** under a
**`When the destination already defines the constant`** context. That required settling a
conflict first: **every `assert_raises` test in the suite is named `"Is an error"`** — all
nine — while two binding rules call for `"Fails"`. The developer chose `"Fails"` for the new
test and **registered the nine as a deferred item** rather than conforming them here.

`except.rb`'s outcomes are **`Excluded constant is not imported`** and **`Constants that are
not excluded are imported`**. `only.rb`'s are **`Constants that are not included in the
only: list are not imported`** — **originated by the developer**, not selected from the
options — and **`Constants in the only: list are imported`**.

## Pass 18 — the conflicting-lists refusal

**Hinge** — the developer asked what happens when a constant is named in **both** lists.
Verified: `except:` won, by ordering alone. Where `only:` named that constant alone, the
caller declared a surface of one and received an import that did nothing, with no signal —
the same failure `only:`'s undefined-name refusal exists to prevent, reached by another
route.

**Options** — refuse `only:` and `except:` together outright; refuse a name appearing in
both; or keep the present behavior and cover it.

**Decision / chat** — **refuse a name in both lists.** The file name was dictated:
`only_and_except_conflict.rb`. Controls gated to the minimal form. Implementation gated to
normalizing **both** lists before either is applied, so neither keyword's validation depends
on the other being given. The developer also directed `.any?` in place of
`not … .empty?`, which was applied to the two identical constructs written earlier in the
same method.

## Outcome

`Constant::Import` refuses four distinct conditions, each covered: a name the destination
already defines; a name in `only:` that the origin does not own; a name in both `only:` and
`except:`; and a name still colliding after either keyword narrowed the set. `except:` and
`only:` narrow the origin's own names before the collision check reads them, each accepting
a single name or a list, as String or Symbol.

Tests: `import_constant/collision.rb`, `except/except.rb`, `except/collision.rb`,
`only/only.rb`, `only/collision.rb`, `only/undefined.rb`, and
`only_and_except_conflict.rb`. The full suite is **114 tests, all passing**, from 104 when
the feature began.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 1:27:23 PM PT
Changed by Scott Bellware on Thu Jul 30 2026 at 6:08:49 PM PT
