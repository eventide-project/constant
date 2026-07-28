# Session — The Constant class becomes a type model (Mon Jul 27 2026 23:16)

**Backfill.** This record is written after the fact, from the durable records, and
covers the work from **Sat 27 Jun 2026 through Fri 3 Jul 2026** — six working days
that follow directly from the session recorded in
`2026-06-26T20-44-05Z-tdd-ai-and-the-humans-role.md`. Its title carries the date it
was *written*, per the record-title-date-format rule; the period it narrates is the
one named here.

The `constant` library began the period with a `Constant` class that mediated a
Ruby module and answered questions about it, and ended with a `Constant` **mixin**
included by two subtypes — `Constant::Module` and `Constant::Literal` — reached
through a single class-level accessor, `Constant.get`. The restructure was not
planned at the outset; it was forced by a question the feature work surfaced. In
parallel, and taking up as much of the period as the code did, the design method
itself was built out: the hinge cycle grew from three hinges to five, a wave of
terminology rules retired imported jargon, and the test-writing conventions that
had been implicit were written down. The period closes with a coverage audit and a
whole-project review that emptied the deferred queue.

This document is the communicable record of that work: a chronological account of
what was asked and what was concluded at each step, with the settled vocabulary
defined as it arises. Pointers to the durable records — the decision log, the loop
records, the plans, the design document — are given throughout; this narrative is
the guided tour, those files are the source of truth.

> **Two notes on following the pointers.** First, everything under `agent/` at the
> time now lives under `waytide/local/` — the log, observations, plans, design,
> loops, experiments, and sessions moved there on 27 Jul 2026, and the rules moved
> into installed packages under `waytide/system/`. The log entries quoted below name
> their paths as they were written; the log is never reformatted. Second, this
> period predates the loop-record convention for part of its span: the five loop
> records dated `2026-06-29T19-13-01Z` are **backfills**, reconstructed after the
> fact and marked as such.

---

## 1. Where this picks up

The prior session had ended with the Name feature integrated on `master` and the
experiment recorded — 28 tests. `Constant` was a class holding a raw Ruby module,
with `#name`, `#full_name`, and an initializer reader. The plan
(`waytide/local/plans/2026-05-29T17-39-17Z-constant-class.md`) had Tasks 4 through 12
still open: namespace, equality, the `build` constructor, a definition predicate,
inner-constant queries, and documentation.

The first act of the period was infrastructural: `agent/deferred/` was established
for design changes deferred until the current task is done — one file per item,
datetime-stamped (`2026-06-27T19-51-34Z-establish-deferred-folder`). It becomes
load-bearing. Nearly every conformance pass and audit in this record was queued as
a deferred item first and worked later, and the period ends when the queue empties.

## 2. The loop grows a shape

Running underneath the whole period is the method's own construction. The prior
session had settled *why* the human is in the loop; this period settled *where the
loop stops*, and the shape it arrived at is the hinge cycle.

**The first gate is split.** The opening turn had been "write the test file"; it
became **the actuation plus an unnamed assert**, with naming the outcome context
demoted to a later gate (`2026-06-27T20-26-25Z-first-gate-actuation-and-unnamed-assert`).
Naming is deferred to the feature's close — outcomes develop unnamed, and the
closing naming step is the seam where the next feature starts
(`2026-06-27T20-26-25Z-naming-gate-trigger-new-feature`). A deferred item that had
recorded this as a *conflict* with the named-outcome rules was resolved as no
conflict at all: they are two different gates
(`2026-06-27T20-26-25Z-resolve-unnamed-test-form-reconciliation`).

**The actuation gate offers options or chat.** At the actuation gate the AI presents
candidate actuations; the human chooses one, or takes the escape and dictates or
discusses. This is Law 1 from the prior session — provoke origination, not mean-bias —
made operational, with the escape as the answer to the unreachable-option limit
(`2026-06-27T20-32-26Z-actuation-gate-options-or-chat`).

**One outcome at a time.** Recorded after over-running: five equality test files were
generated in one batch, which skips gates and hides pending mistakes. Advance one
outcome, stop at every gate (`2026-06-27T22-25-23Z-one-outcome-at-a-time-name-via-options`).

**Three hinges become four, then five.** The initial-implementation cycle was
settled as **actuation → assertion → controls → implementation**, each prompted
separately and accepted before the next, with "chat about this" always available and
no manufactured options (`2026-06-28T15-04-47Z-hinge-cycle`). The next day naming was
promoted to a hinge in its own right — a name that mis-describes what the assertion
establishes is a design error — making the cycle **actuation → assertion → controls →
implementation → naming** (`2026-06-29T00-48-03Z-hinge-five-naming`).

**What each hinge displays.** Three companion rules settled the presentation: the
actuation hinge shows the actuation inside its nested folder-mirroring contexts
(structural placement decided once, then elided); the assertion hinge shows the
assertion *together with* the actuation, since an assertion is meaningless without
the call that produced the value; the controls hinge shows controls together with
actuation and assertion, because controls are inert in isolation. The actuation is
the anchor carried into every downstream hinge
(`2026-06-28T16-29-13Z`, `2026-06-28T16-27-42Z`, `2026-06-28T16-27-41Z`).

**Green-on-arrival is named and dropped.** An outcome whose test passes the moment
it is written drives no design; the tell is a **no-op implementation hinge** — hinge 4
with nothing to write. It surfaced live, on the defaulted-namespace outcome, whose
test passed against code written earlier during the name-resolution outcome. Such an
outcome is dropped; locking the behavior as a regression guard is a separate,
deliberate human decision, not a TDD step
(`2026-06-28T16-01-48Z-no-green-on-arrival-tests`). The principle is applied
repeatedly afterward — and deliberately overridden twice, each time by the engineer
and on the record.

Two smaller process decisions: never ask whether to start a task test-first, since
test-first is the standing default (`2026-06-29T06-39-24Z`); and hinge choices always
go through the selection UI, never a hand-rolled "chat about this" option — the
built-in "Other" is the escape, and the two-option floor forces surfacing the real
underlying decision rather than padding
(`2026-06-29T15-38-02Z-hinge-choices-numbered-list`).

## 3. The terminology hardens

The prior session had promoted "name literally, not by analogy" to a binding rule.
This period spent it. Each of these is a decision-log entry and, in most cases, a
rule:

- **"limit"** replaces the metaphor "fault line" — a condition under which a
  principle stops fully holding (`2026-06-27T21-24-29Z`).
- **"name the outcomes"** replaces the coined "seal" (`2026-06-27T21-52-02Z`).
- **"mediates"** is the canonical verb for the `Constant`↔raw-constant relation,
  retiring "wrap"/"wrapper" and "holds". Settled first as "mediates for"
  (`2026-06-27T22-39-10Z`), then tightened to the bare "mediates" in a no-slang pass
  (`2026-06-28T23-05-57Z`), which supersedes the earlier wording.
- **"controls"**, never "fixtures" — the example constants a test is built from are
  controls, in Eventide/TestBench vocabulary (`2026-06-28T15-08-00Z`).
- **"actuation"**, never "the call", for the invocation of the unit under test —
  which partly *reverses* an earlier rule that had blessed "the call to the unit
  under test" (`2026-06-28T15-08-58Z`).
- **"normal path"**, never "happy path" — imported affective-metaphor jargon
  (`2026-06-28T07-41-49Z`).
- **"scenario"**, never "arm" of a method or feature (`2026-06-29T16-14-11Z`).
- **"increment"**, never "cut" of scope (`2026-06-29T19-22-42Z`).
- **"literal constant"** replaces "non-module constant" for a constant bound to a
  non-module value; the complement stays "module constant"
  (`2026-06-29T19-04-37Z`). This one is not housekeeping — it names the thing the
  restructure is about, and it arrives the same day the restructure does.

In each case the pattern is the same: a live word is found to be figurative,
imported, or coined; a literal word replaces it; live prose conforms; historical
records keep the word they were written with.

## 4. The Constant class, feature by feature

The code work, in the order it was done.

**`#namespace`, decided twice.** First: return the namespace *name* as a String —
the qualified name minus the final segment — and `nil` for a root constant, rather
than the containing module (`2026-06-27T20-42-52Z`). Reversed hours later: return a
**`Constant`** — the enclosing constant, mediated — with the String-returning form
removed as unneeded and the separate `namespace_constant` method folded back in. The
root namespace is `Constant.new(Object)` (`2026-06-27T21-44-53Z`).

**Equality.** `#==` compares by value over the mediated constant, returns `false`
for a non-`Constant` without raising, and is joined by `eql?` and `hash` so equal
`Constant`s collide as Hash keys and dedupe in a Set. The namespace tests were
simplified to assert `namespace == Constant.new(...)` rather than reaching into the
mediated value (`2026-06-27T22-12-18Z`).

**The name calculation moves to class methods, and collides with Ruby.** `#name`
and `#namespace`'s `rpartition("::")` logic was extracted into `def self.name(rc)` /
`def self.namespace(rc)`, with the instance methods thin delegators. Defining a class
method `name` shadows `Class#name`, so a bare `Constant.name` raised. The engineer
dictated the resolution: `class << self; alias __name name; end` preserves the native
method as `Constant.__name` — matching the `__import_constant` underscore convention
already in the library — and frees `name` for the calculation. Three conventions came
out of it: class methods get no separate tests (the instance tests cover them through
delegation); instance→class delegation always goes via `self.class`, so subclasses
work; and a class method builds with a bare `new` (`2026-06-28T07-12-02Z`).

**`build`, in two tasks.** Task 5 gave `build` the value scenario — `build(raw_constant)`
delegating to `new` — which had to justify existing at all, since it duplicates `new`.
It earns it as the single polymorphic public constructor owning all convenience and
validation, while `new` stays the bare no-validation state-recorder
(`2026-06-28T07-40-00Z`). Task 6 added the name scenario: resolve a name in a
namespace, threading `inherit`. `Constant::Error = Class.new(RuntimeError)` was
introduced, raised from two branches with distinct messages — undefined name, and a
name resolving to a non-module value (`2026-06-28T08-19-19Z`). That second error is
removed a day later, when a literal stops being an error.

**`defined?`, class and instance.** The class predicate mirrors `build`'s signature
and reuses `build` to resolve the namespace, then `const_defined?`. Its `inherit`
default is technically redundant but kept to mirror `build`; four of its five
candidate outcomes were green-on-arrival and dropped (`2026-06-29T01-03-13Z`). The
instance predicate was then reworked on a premise the engineer supplied: **the
instance IS the namespace** — it takes a name or a module and reports whether that is
defined within the mediated module, overriding the design document's `in:`
collision-check framing (`2026-06-29T15-44-03Z`). With a module argument the
semantics are identity and containment, not name existence
(`2026-06-29T15-59-32Z`). A name-scenario refute was added as a **deliberate
green-on-arrival exception**, for symmetry with the module scenario — the engineer's
call, recorded as an exception rather than a silent inconsistency
(`2026-06-29T17-12-42Z`).

**A direction rejected.** Adorning a Ruby `Module` with a back-reference to its
`Constant` was considered and rejected: there is no consistent attachment point, so
callers can never know which modules carry it, and decorating static modules risks
process-life retention. Use `Constant.build` on demand (`2026-06-29T07-00-11Z`).

Alongside this, a set of **code-style rules** was written, each from a correction the
engineer made on live code: no prepositions in method names, since a preposition
refers to the argument and the parameter already announces it
(`2026-06-28T06-33-29Z`); don't inline a method call as an argument — bind it to an
explaining local first (`2026-06-28T07-56-10Z`); optional parameters default to `nil`
in the signature and take their real defaults in the body
(`2026-06-28T16-10-26Z`); a positional default is written tight, without spaces
(`2026-06-28T23-56-30Z`); include the primary domain mixin before infrastructure
mixins (`2026-06-29T20-11-54Z`); and run the full suite *before* considering whether
to commit — the suite run is a precondition of the commit decision, not a step after
it (`2026-06-28T07-12-02Z`). The test-writing counterparts landed too: a `test` block
contains only the assertion, with every operand assigned to an explaining variable in
the enclosing context (`2026-06-28T15-24-22Z`); a predicate's context is named
"`<Name>` Predicate" (`2026-06-29T00-18-18Z`); control variables are suffixed by the
form they hold, and an extracted expected operand is a control, never `other_`
(`2026-06-28T17-11-02Z`); a control's string value starts with "some"
(`2026-06-29T21-48-18Z`).

## 5. The literal constant forces a type model

The turn of the period. `#constants` was being extended with an
`include_literal_constants:` keyword, and that raised a question the existing design
could not answer: **a literal cannot be mediated the way a module is.** A module knows
its own qualified name; a literal value does not — its name lives in the *binding*,
not in the value. So a literal needs a different derivation source, and therefore its
own type.

The discovery is recorded in
`waytide/local/observations/2026-06-29T19-13-17Z-constant-literal-type.md`, which
opens with what was dictated (there is a distinct `Constant::Literal`; it answers the
container view **degenerately but truthfully** — `#constants` is `[]`, `#defined?` is
`false` — so a returned list stays uniform rather than heterogeneous) and lists what
was still open. The split it names is the one the whole restructure turns on:

- the **binding view**, which every constant answers — name, full name, namespace,
  the bound value, equality;
- the **container view**, which only a constant that is itself a namespace answers —
  `#constants`, `#constant_names`, `#defined?`.

The open questions were settled the same day
(`2026-06-29T19-34-57Z-constant-literal-design-questions-settled`) and folded into the
design document as Section 5: the shared mixin is the equality protocol plus the
contract; literal equality is by **binding location**; the `Constant::Module` name is
kept, with `::Module` written wherever Ruby's is meant; `build` becomes a universal
factory and the non-module error is removed; the type model is sequenced *before* the
inner-constant query tasks. The direction — `Constant` morphs from a class into a
mixin included by `Constant::Module` and `Constant::Literal` — was recorded as a
breaking but acceptable change, acceptable only because `Constant` was new and
nothing external depended on it (`2026-06-29T19-21-47Z`).

**Two naming decisions inside the restructure are worth carrying.** The bound-value
accessor became **`#value`**, the sole accessor on both subtypes — removing `#mod` and
the `#raw` alias added only hours earlier, and superseding the settlement that had
made `#raw` universal and `#mod` module-only (`2026-06-29T19-40-22Z`). And the
equality protocol was lifted into the mixin over a subtype hook named **`identity`**
— not the coined `equality_key`, which was rejected as invented. `Constant::Module`'s
identity is its `#value`, since a module's identity already encodes its location;
`Constant::Literal`'s is its `#full_name`, so two literals are equal exactly when they
share a binding location (`2026-06-29T21-40-03Z`).

A structural mistake was made and reverted in the same entry: `lib/constant/` **is**
the `Constant` namespace directory, so the subtypes live at
`lib/constant/{module,literal}.rb`. An earlier move to `lib/constant/constant/` would
have implied `Constant::Constant::Module` (`2026-06-29T22-01-33Z`).

## 6. The restructure, and `build` versus `new`

The work was planned as
`waytide/local/plans/2026-06-29T19-49-18Z-constant-literal-restructure.md`, in four
phases: an atomic, behavior-neutral conversion proved by the existing suite; the
`Literal` type and the universal factory, test-first; the inner-constant queries;
then documentation and conformance. All eight tasks are checked off in the plan.

The conversion itself was behavior-neutral by construction — the moment `Constant`
becomes a module, `Constant.new` and `#mod`/`#raw` cease to exist, so every
construction site and accessor use had to move together, and the existing suite
passing is the proof (`2026-06-29T19-54-46Z`).

The constructor question was settled into a rule that outlived the library: **each
domain class gets both `new` and `build`** — `new` is the strict initializer that
records inputs as-is, `build` is the forgiving constructor that normalizes and then
delegates to `new`. `Constant::Literal.build` coerces a Symbol name to a String;
`Constant::Module.build` is a near-passthrough, kept for symmetry; and the top-level
factory delegates to the subtype builds so normalization flows through every
construction path (`2026-06-30T20-12-13Z`). `Constant.build` then became the universal
factory: a name resolving to a module yields a `Constant::Module`, a name resolving to
a literal yields a `Constant::Literal`, and the non-module error is gone — resolving to
a literal is no longer an error (`2026-06-30T19-57-09Z`).

Two more conventions came out of the same days: **don't default an argument you only
delegate** — pass it raw and let the receiver, which is responsible for its default,
coalesce; coalesce only at the point of use (`2026-06-30T22-13-54Z`). And a context
wrapping a test is justified **only** when the outcome needs local instrumentation; a
single assertion over in-scope values is a directly-named test with no context
(`2026-06-30T19-57-09Z`) — which queued a conformance pass over the tests already
written the other way.

`#constants` was implemented to filter by module-ness **before** constructing, rather
than mediating every inner constant and discarding the literals — avoiding allocations
that would be thrown away in the default case, at the cost of `#constants` doing its
own resolution rather than routing through `#get` (`2026-07-01T05-21-40Z`).

The loop records for this stretch are in `waytide/local/loops/`:
`build-universal-factory`, `constant-get-and-construction-interface`,
`constant-module-constants`, and `constant-module-constant-names`.

Also on 30 Jun, two additions to the method's own documentation: the TDD lexicon
gained a full "load-bearing, explained" section so the term could be taught
(`2026-06-30T18-47-18Z`), and formalized **loop** as a distributed OODA cycle — Observe
and Act owned by the AI, Orient and Decide owned by the human, with Orient the
irreplaceable phase, and the adversarial/tempo dimension explicitly not transferring
(`2026-06-30T18-52-14Z`). The **loop record** artifact kind was established the same
day (`2026-06-30T19-10-37Z`): one file per feature recording the passes through the
loop, the narrative companion to the one-line decision log, with retroactive
reconstructions marked as backfills.

## 7. The construction surface settles on `get`

The most consequential simplification of the period, and it came from noticing a
duplicate rather than from adding anything.

`Constant.get(value, namespace=Object, inherit:)` takes a module and returns the
mediating `Constant::Module`, or takes a name and resolves it in the namespace — the
class-level form of the instance `#get`, with the namespace passed as an argument
rather than being `self`. Because `Constant.get(mod)` does exactly what
`Constant.build(mod)` did, the class-level `build` was **a duplicate entry point, not
a distinct operation**, and it was dropped. Construction from a value you already hold
is the subtype constructors. This supersedes both the universal-factory settlement and
the brief `build`/`get` split that followed it
(`2026-07-01T18-00-00Z-get-universal-class-accessor`; loop record
`2026-07-01T17-58-39Z-get-universal-class-accessor`).

**The coercion method is an opt-in refinement.** Ruby's coercion idiom — `Integer()`,
`String()` — is a private `Kernel` instance method, so a bareword `Constant(x)`
requires one too; a gem planting one unconditionally pollutes every process, against
the library's ethos. So `Constant()` is `Constant::Coerce`, activated per file with
`using Constant::Coerce`: an idempotent, type-guarded front door
(`2026-07-01T16-40-00Z`, built at `2026-07-01T17-20-00Z`, loop record
`2026-07-01T16-38-52Z-constant-coercion-method`). Once `get` became the universal
accessor, the coercion was thinned to a veneer over it, carrying only its own three
concerns: idempotence, the type guard, and delegation.

**Nested paths resolve by recursion.** `"Foo::Bar::Baz"` splits in the *instance*
`Constant::Module#get`, which recurses — `get(head).get(rest)` — so each hop is a
single-segment resolution against the parent it actually resolved through. `inherit`
applies at every hop; a terminal literal is built from a genuine final segment with
its true enclosing namespace, fixing the malformed literal that native
`const_get("a::b")` produced; a mid-path literal errors; and the error message names
the exact failing segment and its parent, which is only possible *because* each hop is
single-segment (`2026-07-01T19-40-00Z`; loop record
`2026-07-01T20-24-12Z-nested-path-strings`). `Constant.get` and the coercion inherit
path support by delegating to the instance primitive — and a demonstration test was
written at the class level even though it was green on arrival, because it guards the
normalize-and-delegate hop that every instance test would miss
(`2026-07-01T19-55-00Z`).

**`defined?` was then routed through resolution.** Native `const_defined?` handled
`::`-paths correctly but **leaked a `TypeError`** when a path traversed a literal,
violating the predicate's never-raising contract. The fix routes `defined?` through
`get` and rescues `Constant::Error`, collapsing "undefined name" and "path through a
literal" to `false`, and making the predicate robustly total
(`2026-07-01T21-00-00Z`).

Two directions were closed rather than built: the instance `#define` / `#import`
mutating siblings of `#get` were **dropped** — the `Constant` object is not being
extended into a mutation handle on its module (`2026-07-01T18-40-00Z`); and
`Constant::Import` was settled as negotiating in **raw Ruby constants**, not `Constant`
instances, staying in Ruby's own currency and independent of the domain object
(`2026-07-01T15-35-03Z`). That second decision is the one the July macro/refinement
work later builds on.

## 8. The conformance passes

With the surface settled, the queued deferred items were worked in a run of
behavior-neutral passes, each verified against the suite:

- 25 over-wrapped single-assertion test files flattened to directly-named tests, with
  a refinement settling the boundary: flattening applies only when there is no code
  between the context and the test *and* the context is not a leading "When …"
  condition (`2026-07-01T14-55-26Z`, `2026-07-01T15-10-12Z`).
- An `assert_raises` test block is named exactly "Is an error", with the condition
  promoted to a wrapping context (`2026-06-30T21-20-24Z`); the existing error tests
  conformed (`2026-07-01T14-55-26Z`).
- Comment labels that print a control value gained a "Control " prefix — 19 files —
  while comments printing actuation results stayed unprefixed
  (`2026-07-01T16-05-00Z`).
- `Controls::Constant::Nested` was folded back into the base `example`, which now
  **recurses on a Hash value**: a Hash-valued inner constant means nest deeper, with
  the inner module bound into its parent *first* so Ruby assigns the correct nested
  name (`2026-07-01T20-20-00Z`).
- Logging was removed from the library — `Constant::Log` had been scaffolded and
  never invoked — which also dropped the `evt-log` gemspec dependency and about nine
  transitive packages (`2026-07-01T22-10-00Z`).
- The README was reordered to lead with `Constant::Import` (`2026-07-01T22-30-00Z`),
  gained a "Defining a Constant" section (`2026-07-01T22-45-00Z`), and had its example
  outputs normalized (`2026-07-01T23-40-00Z`).
- 18 legacy date-only filenames under `agent/` were conformed to the ISO-8601-UTC
  prefix, each keeping its **filename date** and borrowing its time of day from the
  git add-commit — with every cross-reference repointed
  (`2026-07-01T21-30-00Z`).

One audit resolved as **mis-premised**: the older `Import`/`Define` test suite was
examined for convention drift and found to be *intentional* on every apparent
divergence — unnamed tests where the context names the outcome; a two-tier control
scheme where deterministic values take `control_` and stateful domain entities take
their domain role; and a message assertion on `NameError` precisely because `NameError`
is generic. The examination still drove two deliberate improvements — the
source/receiver → **origin/destination** vocabulary rename, and `eval` →
`Object.const_get` in the resolution contexts — but as choices, not conformance
(`2026-07-02T00-10-00Z`).

## 9. The coverage audit, where three items dissolved

On 3 Jul the coverage-discrimination-gaps deferred item was worked to completion —
eight items, and the lesson is in how they resolved
(`2026-07-03T19-00-00Z-completed-coverage-discrimination-gaps-audit`).

- **`inherit` was completely untested.** Hard-coding it, dropping its coalescing, or
  failing to convey it through the nested-path recursion would all have left the suite
  passing. Coverage was added across every surface that carries it, discriminated by a
  new **`ancestor:` control** that yields a constant reachable *only* via ancestry.
  Green-on-arrival by design — these tests protect existing behavior rather than
  design new behavior (`2026-07-03T17-00-00Z`). Adding the control also surfaced an
  unrelated fragility: two tests asserted an unspecified `Module#constants` ordering,
  which the new symbols deterministically flipped; fixed by making the assertions
  order-independent, with the library untouched.
- **The error-message item dissolved into a rule.** The premise was "all eight
  `assert_raises` check only the class; add message assertions." Scrutiny found the
  class plus the test's condition already determine that the right error fired —
  *except* where the **same error class is reachable from multiple sites in one
  execution path**, which is exactly the two `::`-path cases. Message checks kept
  there, dropped everywhere else, and the criterion written as a rule
  (`2026-07-03T18-30-00Z`).
- **The `Define` item became a design change.** "Assert the result is a module"
  surfaced a prior question: is `Define` meant to be module-only, or is the kind of
  constant incidental? The implementation had silently committed to modules. The
  decision was to make `Define` **type-agnostic** with the module as the default, so a
  literal can be defined and existing two-argument callers are unchanged. Driven
  test-first with a **contained** red (`2026-07-03T17-30-00Z`).
- **A non-nil un-coercible item half-dissolved and half-surfaced a defect.**
  `Constant(42)` is behaviorally identical to `Constant(nil)`, so that half needed no
  test — but `Constant(:sym)` revealed that the coercion rejected Symbol names that
  `Constant.get` accepts, in a front door documented as a veneer over `get`. Fixed
  test-first (`2026-07-03T18-30-00Z`).
- **The redefinition item produced a rule about not writing a test.** `Define` behaves
  exactly as Ruby's `const_set` — overwrite plus warning — so there is no library
  policy to protect, and a "redefinition replaces" test would test Ruby, not the
  library. Hence the **do-not-test-the-platform** rule.

Outcomes: two rules, one defect fixed, one design change, and the suite from 75 to 92
tests. The stated lesson is that **an audit premise is a hypothesis** — under scrutiny,
three or four of the eight items were not the coverage tasks they first appeared to be.

## 10. Categorizing the rules, and the whole-project review

The 67 flat rule files were sorted into eight subdirectories — terminology,
methodology, test-writing, code, commands, process, git, docs — with the engineer
choosing subdirectories over an index document. Organization only: every file kept its
prefix and slug, and the 35 path references across 25 files were repointed and verified
(`2026-07-03T19-30-00Z`). A consolidation of near-duplicate terminology rules was
surfaced but not done, and was then explicitly **dropped** the next day so it would not
be resurrected as future work (`2026-07-04T04-26-10Z`).

The whole-project code review found **no correctness bugs** across the 335-line
library; every finding was consistency-with-its-own-rules or housekeeping, surfaced as
options and dispositioned by the engineer (`2026-07-04T05-49-40Z`). Two findings were
declined as behaviorally equivalent purity. Two became rule amendments: a settable
payload parameter that may be legitimately falsy defaults via `if .nil?` rather than
`||=` (`2026-07-04T05-49-41Z`), and within the `Constant` family a supertype may invoke
a subtype's `new` directly when it already holds strict, normalized input — an
intra-family privilege with a stated boundary (`2026-07-04T05-58-43Z`).

One finding became a real change. `#name` and `#namespace` raised a raw `NoMethodError`
for an anonymous module while `#full_name` alone returned `nil`. The engineer directed
the design: since `Module#name` is itself a total query returning `nil` for anonymous
modules, the library should **mirror the platform rather than fight it**. The guard was
placed in the class-level helpers, where the derivation lives, keeping them total and
the instance methods thin; `#full_name`'s existing `nil` was locked as a deliberate
green-on-arrival regression guard — the engineer's call, an intentional exception to
the default (`2026-07-04T06-30-52Z`). 92 → 95 tests.

The period closes with the deferred queue empty (`2026-07-04T06-00-12Z`) and the root
developer-aid files deliberately left in place (`2026-07-04T06-34-13Z`).

---

## Takeaways

- **The type model was not designed; it was forced.** Extending `#constants` with one
  keyword exposed that a literal's name lives in its binding and a module's lives in
  its value — two different derivation sources, therefore two types. The restructure
  followed from a fact about Ruby constants, not from a preference about design.
- **Simplification came from noticing a duplicate, not from adding an abstraction.**
  `Constant.build` was removed at the class level because `Constant.get(mod)` already
  did exactly what it did. The surface got smaller by subtraction.
- **`new` strict, `build` forgiving.** The pair that came out of the restructure —
  `new` records inputs as-is, `build` normalizes then delegates — is the durable
  result, and it holds because normalization flows through every construction path.
- **An audit premise is a hypothesis.** Three of the eight coverage items were not
  coverage tasks: one was a rule waiting to be stated, one was a design question, one
  was a defect. Treating the audit list as a work list would have produced tests that
  asserted the wrong things.
- **Do not test the platform.** A test that would exercise Ruby's own semantics rather
  than the library's policy is not coverage; it is noise with a maintenance cost.
- **Green-on-arrival is the default, and its exceptions are the engineer's.** Twice an
  outcome that drove no design was kept anyway — for symmetry, and as a regression
  guard — each time by explicit decision and each time recorded as an exception rather
  than left as an inconsistency.
- **The method was built out of corrections, not out of theory.** Nearly every rule in
  this record was written the moment a correction landed on live code: a batch that
  skipped gates, a foreign word, an inlined call, a default in the wrong place. The
  prior session predicted this migration — decider to conditioner — and this period is
  it happening, roughly thirty times.

## Glossary

Terms settled or sharpened during this period:

- **mediates** — the canonical verb for the relation between a `Constant` and the raw
  Ruby constant it stands in front of. Retires "wrap"/"wrapper"/"holds".
- **literal constant** — a constant bound to a non-module value. Its complement is a
  **module constant**. Replaces "non-module constant".
- **binding view / container view** — the two halves of the `Constant` interface. Every
  constant answers the binding view (name, full name, namespace, value, equality); only
  a constant that is itself a namespace answers the container view (`#constants`,
  `#constant_names`, `#defined?`). `Constant::Literal` answers the container view
  degenerately but truthfully.
- **identity** — the subtype-provided hook the shared equality protocol is expressed
  over. `Constant::Module`'s is its `#value`; `Constant::Literal`'s is its
  `#full_name`, so literals are equal by **binding location**.
- **`new` (strict) / `build` (forgiving)** — the constructor pair: `new` records inputs
  as-is, `build` normalizes and delegates to `new`.
- **the hinge cycle** — actuation → assertion → controls → implementation → naming;
  each prompted separately and accepted before the next, with an escape always
  available.
- **green-on-arrival** — an outcome whose test passes the moment it is written. The
  tell is a no-op implementation hinge. Dropped by default.
- **actuation** — the invocation of the unit under test. Retires "the call".
- **controls** — the example values a test is built from. Retires "fixtures".
- **limit** — a condition under which a principle stops fully holding. Retires the
  metaphor "fault line".
- **increment** / **scenario** — retire the slang "cut" and "arm".
- **loop record** — the per-feature narrative of the passes through the loop; the
  companion to the one-line decision log. A retroactive one is marked a **backfill**.

## Where the durable records live

- **Design** — `waytide/local/design/2026-05-22T18-59-14Z-constant-class-design.md`,
  whose **Section 5** carries the settled type model; Sections 2–4 are marked
  superseded and kept as the design record rather than rewritten.
- **Plans** — `waytide/local/plans/2026-06-29T19-49-18Z-constant-literal-restructure.md`
  (all eight tasks complete), superseding Tasks 10–11 of
  `2026-05-29T17-39-17Z-constant-class.md`.
- **Observation** —
  `waytide/local/observations/2026-06-29T19-13-17Z-constant-literal-type.md`, the
  discovery record for the type model, marked Settled and pointing at the design
  document.
- **Loop records** — `waytide/local/loops/`: five backfills dated `2026-06-29T19-13-01Z`
  (constant-literal type design, equality, full name, degenerate container, the
  instance defined predicate), then `build-universal-factory`,
  `constant-get-and-construction-interface`, `constant-module-constants`,
  `constant-module-constant-names`, `constant-coercion-method`,
  `get-universal-class-accessor`, and `nested-path-strings`.
- **Decision log** — `waytide/local/log/`, entries from `2026-06-27T19-51-34Z` through
  `2026-07-04T06-34-13Z`. Entries that were later superseded are left as written; the
  superseding entries name what they supersede.
- **Rules** — the methodology, terminology, test-writing, and code rules written during
  this period are now installed packages under `waytide/system/` (chiefly
  `design-by-efferent/`, `code/ruby/`, `testing/`, `language/`, `git/`), except the
  three the packages do not carry, which are local rules under `waytide/local/rules/`.
- **Code** — `lib/constant/constant.rb` (the mixin), `lib/constant/module.rb`,
  `lib/constant/literal.rb`, `lib/constant/coerce.rb`, `lib/constant/define.rb`,
  `lib/constant/controls/constant.rb`, and the `test/automated/constant/` tree.

## A closing note

The period's two halves were the same activity at different altitudes. The code work
kept discovering that a thing it had named was actually two things — a namespace is a
constant, not a string; a constant is a module *or* a literal; `build` at the class
level is `get` under another name — and each discovery cost a reversal that was cheap
because it was found early. The method work kept discovering that a decision it had
filed as mechanical was actually a hinge — naming, controls, the implementation
itself — and each discovery cost a rule. The library ended smaller in surface than it
started, and the method ended with two more hinges than it started. Both are the same
result: the things that turn out to be load-bearing are rarely the ones you allocated
attention to in advance.

---

Authored by Scott Bellware on Mon Jul 27 2026 at 11:16:34 PM PT
