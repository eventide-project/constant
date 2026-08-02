# Session — The import refusals and the vocabulary that carried them (Sat Aug 1 2026 17:38)

The session opened on a single deferred item — `Constant::Import` silently replacing a
constant that already existed at its destination — and closed three days later with five
refusals built, six features concluded and integrated, the test suite's control vocabulary
conformed, the installed Waytide packages refreshed, a rule amended and published upstream,
and the README rewritten twice. The deferred queue began with one item, grew to four, and
ended empty.

The arc was not planned. Each feature surfaced the next, and most of the session's turns
were the engineer redirecting a design that was about to go wrong.

## A framing note

This is the communicable record — the guided tour, written to be read by a person. It is
**not** the source of truth. The durable records are the binding rules
(`waytide/system/`, `waytide/local/rules/`), the decision log (`waytide/local/log/`), the
feature records (`waytide/local/features/`), and the loop records (`waytide/local/loops/`).
This narrative points to them and preserves the reasoning behind each fork; where it and a
durable record disagree, the durable record is right.

## 1. The item, and the decision that had to be settled before it

The deferred item `import-refuses-a-colliding-constant` came out of a pull request in
`env-var`, where `import EnvVar` replaced the top-level `Log` class that `evt-log` defines.
Two warning lines, easily missed, and afterward plain `Log` in that process meant something
different. Twenty-two Eventide libraries define `class Log < ::Log`, so every one of them
reaches the same collision the moment its suite adopts a top-level import.

The item flagged something to settle first: a prior decision held that `Constant::Define`
behaves exactly as Ruby's `const_set` — overwrite plus warning — so there is no library
policy to protect. That decision produced the **do-not-test-the-platform** rule, and it
reads as though it already forbids this feature.

It does not, and the reason is narrower than the item's own. The 3 July decision rests on
`Define` being a **transparent pass-through** — its whole body is a `nil`-default and the
`const_set`. That antecedent is false for `Import`, which already refuses top-level
inclusion, refuses a destination that already includes the origin, coerces a non-module
destination to its class, and fixes `inherit` to `false`. A unit that already refuses twice
is not one whose behavior is the platform's.

Recorded at `2026-07-30T19-48-47Z-define-transparency-does-not-govern-import`.

## 2. The refusal, and the first redirection

The collision refusal was designed through the hinges. At the observation hinge the question
was whether the test should also read that the destination was left untouched — which would
have forced the guard to check every name before assigning any.

The engineer answered by originating rather than selecting: *if the actuation raises, the
raise is terminal; if someone rescues the error, they get what they get in an inconsistent
state.* The library owes no all-or-nothing guarantee. The observation became the raise alone.

The implementation still checks every name before assigning any — chosen at the
implementation hinge for a different reason, that one set of names then governs both the
check and the assignment and they cannot disagree.

## 3. The precondition, coined mid-design

Designing the `except:` test produced a muddle, and the engineer named it: *an except test
that is asserting that the collision is included.* Two scenarios had been conflated —
excluding a name, and using exclusion to get past a refusal.

The fix was a construct Waytide had no word for. The engineer introduced it:

> A precondition is a bare assert or refute that isn't a named test, but it is a condition
> that can be expressed so that it is understood by the reader.

The actuation goes inside `refute_raises` with no `test` block. TestBench was checked and
behaves as the form needs: a satisfied precondition adds nothing to the test count, a failed
one reports `no tests, 1 failure`, exits non-zero, and the outcomes below it do not run.

Recorded as an observation rather than a rule, having been applied once. It came back later
in the session as a system rule, materially changed — see section 9.

## 4. Two keywords, and the shape of each test

`except:` and `only:` were named as a pair, over `exclude:`/`select:`, because `include:` is
unusable in a library where `include` means module inclusion and `Import` already raises
`already includes`.

The engineer shaped both tests, twice each. For `except:`: first *prove that the excluded
constant is NOT defined in the destination*, then *the destination control should have the
collision constant in it, and prove that the excluded constant is not imported over it —
that proof is that the destination's inner constant is not the same constant as the source
being imported.*

`only:` was settled as a **declaration** rather than a filter: a name it gives that the
origin does not own raises, because a caller who names a constant and does not receive it
has been told nothing. `except:` has no equivalent — excluding a name that is not there is
harmless. The asymmetry is deliberate.

A third refusal followed from a question the engineer asked: what happens when a constant is
named in both lists. It was importing nothing, silently. Now it raises.

## 5. A rule's scope, settled by the engineer in one line

The `Import` tests name raw modules `origin_constant` and `destination_constant`, while a
local rule reserves `_constant` for `Constant` instances. Working out whether the rule
reached the library's own locals took several turns and produced a fourth-form problem —
`import_constant` may hold a **literal constant** as readily as a module, and the rule has no
word for that.

The engineer dissolved it: **the rule governs test controls, not implementation locals.** The
fourth form was never needed. Recorded at
`2026-07-31T21-28-46Z-suffix-rule-governs-test-controls-only`.

## 6. Two conformance passes, and an overlap missed twice

Naming the collision test surfaced that **every `assert_raises` test in the suite was named
`"Is an error"`** — all nine — while two binding rules call for `"Fails"`. The new test took
`"Fails"` and the nine were deferred.

That pass then edited two files a rename pass would later edit again. Its own record had
carried a line asking for exactly that coordination, and the decision was never made. The
line was removed rather than left claiming a decision nobody made.

The overlap was missed a second time when a `source`-rename item was written against the
same identifiers as the test-controls item without either knowing about the other. That is
what produced a **sequencing item** — an item introducing no work of its own, naming only the
order the others run in. Its own target table then turned out to be wrong, caught by the
check it had itself asked for.

## 7. What the engineer's challenges killed and saved

Three of the session's turns changed what got built.

**A test that would have tested Ruby.** The literal-constants item proposed covering that
`Import` copies a literal. The engineer asked whether there is significant behavioral drift
between a module test and a literal test. There is none — the imported value is read,
written, and returned, and nothing branches on what it is. That test was killed.

**Then reframed into one worth writing.** *Consider a shallow test with just enough coverage
to prove that the literal and module constants are imported.* A different claim, and the
library's: `Import`'s **scope** is every constant the source owns, whatever kind, and
`constants(inherit)` is a selection that could have been narrowed to modules. It was
unprotected — a `select { … .is_a?(Module) }` passed the whole suite, confirmed by adding one
and watching only the literal outcome fail.

**A construct saved from a rule.** When the shipped precondition rule appeared to forbid the
`refute_raises` form, the engineer's answer was that *those are decisions made in terms of
the controls sent to the method.* The form stayed and the rule was amended.

## 8. The inherited name, and a mechanism that could not work

A name the destination reaches through an **ancestor** did not collide, and the import
shadowed it — with no error and, unlike the direct case, **no Ruby warning either**. The
quietest case was the one the refusal did not reach.

The design was settled on the item: a `shadow_inherited` parameter, defaulting to `false`.
The engineer rejected `inherit` as its name — the word already means *resolve through the
ancestry* on seven methods across the library. Naming it `shadow_inherited` settled a second
question by itself: it cannot be read as governing what gets imported, so the parameter is
destination-only.

**The item's stated mechanism was unbuildable, and checking it before building is the only
reason that was found.** It said the second argument to `const_defined?` changes. But
`const_defined?(name, true)` does not only search ancestors — it falls back to top-level
constants, so `Module.new.const_defined?(:String, true)` is true. A check written that way
would have refused importing any name that matches anything at top level, and `Object`
defines `Log` — **the fix would have broken the case the refusal exists for.** The check
walks `target.ancestors` instead.

## 9. The packages refreshed, and a rule that came back changed

Six packages moved. Both of this session's contributions returned in them — the
exceptional-paths rule as written, and the precondition, promoted to a system rule with a
**different framing**: a precondition documents a factor that *decides* the outcome and is
not visible in the script, most often hidden inside a control. Not the observation's framing,
so the observation was deleted rather than kept as a discovery record.

The shipped rule appeared to forbid the session's three usages twice over — once by *"never
over the library's own decisions"*, once by requiring the predicate to read inline. On the
engineer's reading the usages stand, so the rule was amended: authored in the composite
repository, `report-direct-commits.sh` run clean, split from `system/testing`,
fast-forward confirmed against the component's head, published, and refreshed back down.

## 10. The README, twice

`Constant::Import` had grown five refusals and three keywords, and the README documented
`alias:` alone. It was brought current — and then reconsidered.

The first pass folded the raised conditions into each **Returns** paragraph, which is what
the document had always done. The engineer then reconsidered: a **Failures** section after
each parameters table. Applied throughout rather than to `Import` alone, and only where
something can fail — a section that cannot fail gains no heading.

Two facts got written down that had been nowhere, both surfaced by having to state the
conditions completely: that the refusal reaches the constant the import actually **writes
to**, so an aliased import does not collide with a name already on the destination; and that
Ruby emits no warning for shadowing an inherited constant, which is why that refusal is the
only signal there can be.

Every documented claim was run against the library rather than transcribed.

## Takeaways

- **A settled design can carry an unbuildable mechanism.** `shadow_inherited`'s design was
  right and its stated implementation would have broken the case it was for. Checking the
  mechanism before building is what caught it.
- **The premise is worth challenging before the work.** The literal-constants test was killed
  as a platform test and rebuilt as a scope test. Same subject, different claim, and only the
  second was worth writing.
- **Two items renaming the same identifier is not an unlikely accident.** It happened twice.
  What answers it is an item whose only content is the order.
- **A word carried unexamined becomes a defect.** "Refusals" was borrowed from a deferred
  item and used all session; the README says *raises*. Asking what it meant is what surfaced
  it.
- **Verify rather than assert, including one's own tooling.** BSD `sed` has no `\b`, so a
  bulk rename silently did nothing while reporting success. A timestamp supplied instead of
  read put a provenance footer out of order. Both were found by looking.

## Glossary

- **precondition** — a bare `assert` or `refute` that is not a test, documenting a factor
  that decides the outcome where the script does not express it. Coined here; promoted to a
  Waytide rule with a changed framing, then amended to admit the block form.
- **exceptional path** — the course through a raising case, as against the **normal path**.
  Never "exception path", now settled in the `language` vocabulary.
- **shadow_inherited** — `Import`'s keyword governing whether the import may shadow a name
  the destination reaches through an ancestor. Defaults to `false`.
- **scope**, of an import — which constants `Import` selects from the source: every one it
  owns, whatever kind. Distinct from what `const_set` does with them, which is the platform's.
- **Failures** — the README section, after a parameters table, stating the conditions that
  raise.
- **sequencing item** — a deferred item introducing no work, naming only the order others run
  in.

## Where the durable records live

**Ten decision-log entries**, `2026-07-30T19-48-47Z` through `2026-08-02T00-29-32Z`.

**Six feature records** under `waytide/local/features/` — `import-collision-refusal`,
`error-tests-named-fails`, `import-test-vocabulary`, `import-literal-constants`,
`import-shadow-inherited`, `import-readme` — each with **its loop record** under
`waytide/local/loops/`. The collision-refusal loop record runs nineteen passes and is the
fullest account of the session's design.

**One local rule amended** — `2026-06-28T17-11-02Z-namespace-variable-suffix`, which gained
its scope paragraph.

**One system rule amended and published** — the `testing` package's
`precondition-documents-deciding-factors-and-reads-inline`, in the composite at
`waytide/waytide` and split to `waytide/testing`.

**The code** — `lib/constant/import.rb`, and the tests under
`test/automated/import_constant/`. The suite moved from 104 tests to 119.

**The deferred queue is empty.**

## A closing note

The session's most useful turns were the ones where the engineer refused the framing rather
than answering the question. Three designs were wrong at the moment they were put up, and
each was corrected by a question rather than by a decision — *is there significant
behavioral drift*, *what does "refusals" mean*, *are those not decisions made in terms of the
controls*. The gates worked, but not by being answered.

---

Authored by Scott Bellware on Sat Aug 1 2026 at 5:38:21 PM PT
