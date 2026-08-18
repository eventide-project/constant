# Session — The Import destination and the refinement (Mon Jul 27 2026 17:41)

A working session on the `constant` library, spanning two days. It began as a
narrow fix — `Constant::Import`'s macro doesn't work at the top level of a
script — and ended by removing the top-level macro entirely, replacing it with a
Ruby refinement activated by `using Constant::Import`. Along the way the Waytide
system was installed and the project's own working state moved under it, and two
experiments were closed: the name-feature experiment (affirmed on its
methodological findings) and a new experiment on defaulting the import
destination, whose stated mechanism was refuted and whose motivating question was
answered anyway.

This document is the communicable record of that session: a chronological account
of what was asked and what was concluded at each step, with the settled vocabulary
defined as it arises. Pointers to the durable records — the decision log, the loop
record, the experiment records, and the code — are given throughout; this
narrative is the guided tour, those files are the source of truth.

> A note on reading the log for this session: the top-level idiom was decided
> three times, and the destination rule four. The decision log records each
> decision as it was made, including the ones later superseded, and the
> superseding entries name what they supersede. Read chronologically it looks
> like churn; read as the arc below, each reversal is a premise being corrected
> by evidence. This record exists mainly to make that arc legible.

---

## 1. The macro doesn't reach the top level

`Constant::Import` has a **macro** form: `include Constant::Import` in a module
body, then `import SomeOrigin`, which copies the origin's inner constants into
the including module. It does not work at the top level of a plain script.
`self` there is `main`, and Ruby's top-level `include` redirects to
`Object.include`, which puts `import` on `Object`'s singleton — not somewhere
`main` can call it.

The whole of the first day is recorded pass-by-pass in the loop record
`waytide/local/loops/2026-07-26T17-27-23Z-macro-top-level-include.md`. The
summary here is the arc, not the passes.

**First decision: extend-based.** `extend Constant::Import::Macro; import Origin`,
with `Macro#__import_constant` falling back to `self.class` when the receiver
isn't a module. The include form was disqualified for blast radius: making it
work at top level appeared to require installing `import` as a public instance
method on every object in the process
(`2026-07-26T17-27-23Z-macro-top-level-extend-based`).

**Reversed on a use case, then on a probe.** Review surfaced that the README
documented the *include* form and nothing tested it. The engineer supplied the
missing use case — this is done in a `test_init.rb` file, where the
library-under-test's root namespace is imported so every test file can reach it —
which named the include form as the intended idiom. That reopened the direction,
and the disqualifying premise turned out to be incomplete: a third path exists,
where `Import.included` extends the *top-level receiver's singleton* when the base
is `Object`. Probed: the idiom works at top level and `Object.new.respond_to?(:import,
true)` is `false`. None of the blast radius that decided pass 1 applied
(`2026-07-26T21-36-28Z-macro-top-level-idiom-is-include-based`).

**The destination rule was decided twice in one minute.** First narrowly — resolve
to `::Object` only for the top-level receiver, on the argument that `self.class` is
principled for `main` and arbitrary otherwise
(`2026-07-26T21-36-29Z-macro-destination-resolves-only-for-main`). Then reversed,
when the engineer asked what happens if someone includes the macro into `Object`
to give everything the macro: `include Constant::Import::Macro` in a class body
gives that class's instances an `import` targeting the class, which already worked
and is a form worth supporting. So the general `self.class` rule stayed, and the
top-level object became an ordinary case of it rather than a special case
(`2026-07-26T21-36-30Z-instance-import-idiom-is-supported`).

Two smaller decisions closed the day: the top-level test nests three deep —
`Import Constant` / `Macro` / `Top Level` — giving the case its own context
(`2026-07-26T22-55-52Z-top-level-case-gets-its-own-context`), and the destination
guard names its receiver rather than reaching back to `self`, leaving no explicit-`self`
receiver anywhere in `lib/` outside `def self.`
(`2026-07-26T23-12-20Z-macro-guard-names-its-receiver`). The instance-destination
test was named for its case rather than its wiring keyword —
`macro/instance.rb` under an `Instance` context, wired through `include
Constant::Import::Macro` in a class body, the form the README documents
(`2026-07-26T23-29-44Z-instance-destination-test-covers-the-documented-class-form`).

Released as 2.1.1.0.

## 2. The destination check belongs to the API, not the macro

The next morning opened on a divergence the loop had left behind.
`Macro#__import_constant` normalized a non-module destination to its class, but
`Constant::Import.call` did not — so `some_object.import(origin)` succeeded while
`Import.(origin, some_object)` raised `NoMethodError` on `ancestors`. The check
moved into `Import.call`, so the macro and the API cannot deviate, and
`Macro#__import_constant` returned to being a transparent pass-through of `self`
(`2026-07-27T17-23-47Z-destination-normalization-belongs-to-import-call`).

That made `macro/instance.rb` redundant as a proof of the destination rule, which
`import_constant/instance.rb` now establishes at the API. It was circumscribed to
a cursory proof that the macro's pass-through is in place — one inner constant, one
assertion (`2026-07-27T17-42-14Z-instance-macro-test-is-circumscribed-to-the-passthrough`).

A question left open by that change was deferred rather than pursued: if the
destination is normalized inside `Import.call`, could it be *defaulted* — could
`Import.(SomeOrigin)` import into the calling module? The deferred item recorded
the ground already probed (no `Binding.of_caller`, no `RubyVM::DebugInspector`, a
gem dependency judged too expensive for a convenience feature, `TracePoint` the
remaining avenue), instructed that it be carried out as an experiment, and gated
itself on the Waytide migration.

## 3. Waytide is installed, and the project's working state moves under it

The migration the deferred item was gated on. The project's rules and working
state had lived under `agent/`; they moved to `waytide/`, and the rule packages
were installed as git subtrees. Mid-migration the layout was corrected once —
from `waytide/framework/` to `waytide/system/`, with the project's own material
gathered under `waytide/local/` — settling the split the `AGENTS.md` now
describes: `waytide/system/` is installed and never edited in place,
`waytide/local/` is everything this project writes.

Three rules the installed packages do not carry were restored as local rules,
each keeping its original ISO-8601-UTC filename prefix and gaining a provenance
footer recording its original authorship:
`namespace-variable-suffix`, `literal-constants-terminology`, and
`string-outputs-permissive-inputs`
(`2026-07-27T20-23-13Z-three-library-specific-rules-are-restored-as-local-rules`).
That entry names their destination as `waytide/rules/`; the reorganization later
the same afternoon moved them to `waytide/local/rules/`, which is where they are.
The log entry is not rewritten — the log is a record of decisions as made.

## 4. The name-feature experiment is affirmed

With the migration landed, the long-open name-feature experiment
(`waytide/local/experiments/2026-06-26T21-19-51Z-name-feature-run-1.md`) was
declared **affirmed**. Its code decisions had been logged during the run; the
affirmation added the three **methodological** findings, which had none:

- **Gate forecasting locates the deliberation.** Forecasting where the human will
  interject, before the work starts, put both substantive corrections at the tier
  they were predicted for, and no predicted gate went unfired except where the
  design had already settled it
  (`2026-07-27T22-23-32Z-gate-forecasting-locates-the-deliberation`).
- **Exposing the proceed-pile is what catches mechanical-tier corrections.** Two
  of four corrections would have passed silently as misses had the pile the AI was
  about to decide on not been shown for audit. Corollary: naming, vocabulary, and
  punctuation consistency belong in tier 2, not tier 3
  (`2026-07-27T22-23-33Z-exposed-proceed-pile-catches-mechanical-corrections`).
- **The partition must enumerate test-structure conventions.** The run's one true
  miss — flattened context nesting — escaped the forecast, every gate, and
  integration because it was never itemized at all. Exposing the pile only helps
  for items in the pile; a gap in the partition is invisible to the audit
  (`2026-07-27T22-23-34Z-partition-enumerates-test-structure-conventions`).

The affirmation is qualified: the planned second, originate-blind run was never
run, so the mean-bias question that comparison would have isolated is not part of
what is affirmed.

## 5. The import-destination experiment — refuted at gate 1, and continued anyway

The deferred item was carried out as it instructed, on branch
`experiment/import-destination-defaults-to-caller`, worked in a single tree, with
the forecast committed before any work and a **predicted verdict of refuted** on
`TracePoint` feasibility grounds
(`2026-07-27T22-41-32Z-import-destination-experiment-is-started`). The full record
is `waytide/local/experiments/2026-07-27T22-41-31Z-import-destination-defaults-to-caller.md`.

**Gate 1 resolved negative, and the prediction's reasoning was incomplete in an
informative way.** `TracePoint` yields the *callee's* binding, not the caller's; a
trace armed inside the method cannot see the already-entered caller frame; the one
pure-Ruby recovery that works fires *after* the call returns, and when the import
is the last statement in a module body it imports into the wrong destination
**silently**; the sound alternative — a globally-armed shadow stack — costs 8.8× on
every method call in the host process. The forecast anticipated the cost objection
and missed the correctness objection entirely, which is the finding that actually
forecloses the approach: cost arguments invite "optimize it later" and correctness
arguments do not.

**The verdict gate was put to the engineer with Refuted recommended, and
declined.** That is the turn the session hinges on. The verdict had been scoped to
the *mechanism* under test — deriving the destination from the call stack — rather
than to the experiment's *motivating question*, which was whether the destination
can be omitted at the use site at all. Call-stack derivation was only the first
candidate mechanism. The Question was broadened, and the broadening recorded rather
than made silently.

What followed was a sequence of probes rather than arguments:

- **A block carries its definition site's binding.** `Proc#binding` resolves
  correctly at every use site including the last-statement-in-a-module-body case
  that killed the trace approach, because the binding is captured at block
  creation rather than recovered after the fact. Sound and available — but an empty
  block whose only purpose is to smuggle a binding is obscure.
- **The other proposed forms lose on their own terms.** `Import.into(self).(Origin)`
  is 36 characters and `Import.(Origin, at: binding)` is 38, against the 31 of the
  explicit `Import.(Origin, self)` they were meant to improve. Both *relocate* the
  argument into more characters than passing it cost. Measured at the use site, not
  argued.
- **The blast-radius premise was checked rather than assumed.** Top-level
  `include Constant::Import` reaches **every class in the process, permanently**
  (including classes defined afterward), but reaches **no modules**, adds **no
  instance methods**, and leaves ordinary objects untouched. Broader than stated in
  one direction, narrower in another.
- **The refinement removes the problem and covers more ground.** Under `using`, it
  reaches modules *and* classes while `Object.instance_methods.grep(/import/)` stays
  empty. Its costs were measured too: it stops at the file boundary, `respond_to?`
  disagrees with `methods`, and `using` is not permitted inside a method.

**The engineer settled the form by origination, not selection:** `import SomeModule`
available in `test_init.rb`, with neither `include` nor `extend`. Two reductions
followed, each from probing an assumption rather than reasoning from it —
`refine ::Module` was dropped as redundant once measured, since modules and classes
*are* objects and `refine ::Object` reaches them
(`2026-07-27T23-26-02Z-import-refinement-on-object`); and the separate `Refinement`
namespace was dropped once questioned, so the use site is `using Constant::Import`.

**A third assumption fell at the same gate.** `private_constant :Macro` had been
called foreclosed because `Constant::Import::Macro` looked like published surface —
it was in the README, it had a test, and a log entry called it "a supported idiom."
The engineer corrected the premise: `Macro` was only ever unpublished *by
convention*. "Public API" was an inference drawn from the README documenting it, not
from any recorded decision, and the two had been collapsed. `private_constant :Macro`
was applied (`2026-07-27T23-25-59Z-macro-is-unpublished`), which withdrew the
`include Constant::Import::Macro` instance idiom decided the day before — the
instance idiom is now `using Constant::Import` and then `some_object.import(Origin)`,
with behavior unchanged (`2026-07-27T23-26-00Z-instance-import-idiom-is-the-refinement`),
and its test moved from `macro/instance.rb` to `refinement/instance.rb`
(`2026-07-27T23-26-01Z-instance-destination-test-moves-to-refinement`).

Declared **affirmed**, and the affirmation is qualified in a way worth carrying:
what is affirmed is the motivating question, not the mechanism. The destination
*can* be omitted at the use site — but nothing is derived from the stack. The
caller is not inspected; under the refinement it is simply the receiver
(`2026-07-27T23-40-44Z-import-destination-is-the-receiver-not-the-caller`). Anyone
reading that record for the caller-binding technique should stop at gate 1.

Two methodological findings were logged from the affirmation: that declining a
recommended verdict is what produced the feature
(`2026-07-27T23-40-45Z-declining-a-recommended-verdict-produced-the-feature`), and
that every reduction came from probing an assumption rather than reasoning from it
(`2026-07-27T23-40-46Z-probe-the-assumption-rather-than-reason-from-it`). Merged
to `master` by a `--no-ff` merge so the branch topology survives; branch deleted on
confirmation.

## 6. Top-level inclusion is refused

The refinement having made the top-level include form unnecessary, the blast radius
the experiment had measured made it indefensible: top-level `include` includes into
`Object`, whose singleton class every class inherits from, so `base.extend(Macro)`
had been putting `import` on every class in the process. Including
`Constant::Import` at the top level now raises `Constant::Error` naming
`using Constant::Import` as the remedy. **The raise precedes the extend, so nothing
is installed** (`2026-07-27T23-55-48Z-top-level-include-is-refused`). This is a
breaking change for scripts that included at the top level, and it supersedes both
the extend-based decision of the previous morning and the include-based idiom that
replaced it.

The `macro/top_level.rb` test keeps its path and contexts and changes subject to the
refusal, asserting both that inclusion is refused and that the error names the
refinement. `Controls::Script::Example` gained `#error`, which runs a script and
returns its error output, raising if the script unexpectedly succeeds; `#run` and
`#error` share a new `#execute`
(`2026-07-27T23-55-49Z-top-level-macro-test-covers-the-refusal`).

Suite: **104 tests, 0 failed.**

---

## Takeaways

- **The top-level idiom moved through three forms in two days** — extend-based,
  include-based, then refused entirely in favor of `using Constant::Import`. Each
  reversal came from a premise being checked: the first from a use case the engineer
  supplied, the second from a probe that found a narrower path, the third from
  measuring what top-level `include` actually mutates.
- **A verdict is scoped to a mechanism or to a question, and the difference is
  load-bearing.** The import-destination experiment was correctly refuted on its
  stated mechanism and would have closed there — with the working answer one probe
  away — had the recommended verdict been accepted. When a gate resolves negative,
  check whether it refutes the question or only the first candidate mechanism.
- **Probe the assumption rather than reason from it.** Three reductions in one
  gate, each from measuring something the reasoning had taken for granted:
  `refine ::Module` redundant, the `Refinement` namespace unnecessary,
  `private_constant :Macro` not foreclosed.
- **Documenting something is not publishing it.** `Macro` appeared to be public
  API because the README described it; no decision had ever made it so. An inference
  from documentation had hardened into a constraint.
- **A check that exists in two places will diverge.** The destination normalization
  lived in the macro and not the API, and the two behaved differently for the same
  input until it moved to the single place both go through.
- **Cost figures mean opposite things depending on what they are levied on.** The
  shadow stack's 8.8× is disqualifying and `Proc#binding`'s 7.3× is irrelevant —
  one taxes every method call in the process, the other is paid once per import at
  load time.
- **Origination bypasses the option set.** The actuation hinge was settled by the
  engineer dictating the form outright rather than by the AI proposing options —
  which the forecast's tier partition does not model, and which is the
  human-in-the-loop mechanism working as intended rather than failing.

## Glossary

Terms settled or sharpened during this session:

- **Origin** — the module whose inner constants are copied by an import.
- **Destination** — the module or class the constants are copied *into*. A
  non-module destination is normalized to its class, in `Constant::Import.call`.
- **The macro** — `Constant::Import::Macro`, which provides `import` as a bare call
  in a module body. Activated by `include Constant::Import` in a module or class
  body; **now private** (`private_constant :Macro`) and refused at the top level.
- **The refinement** — the `refine ::Object` in `Constant::Import`, activated by
  `using Constant::Import`. Gives `import` at the top level, in module and class
  bodies, and on any instance, with no process-wide footprint. The only top-level
  form.
- **Unpublished by convention** — surface that no recorded decision ever made
  public, regardless of whether documentation describes it. Distinguished here from
  *published surface*, which is a decision, so that documentation cannot silently
  create an API commitment.
- **The verdict's scope** — whether an experiment's negative result refutes the
  Question or only the first candidate **mechanism** for it. Naming the difference
  is what kept this experiment open.
- **Origination** (as against selection) — the engineer dictating a design outright
  rather than choosing from options put up at a gate.

## Where the durable records live

- **Loop record** — `waytide/local/loops/2026-07-26T17-27-23Z-macro-top-level-include.md`
  (the first day, pass by pass).
- **Experiments** —
  `waytide/local/experiments/2026-07-27T22-41-31Z-import-destination-defaults-to-caller.md`
  (affirmed; read gate 1 for why caller-binding derivation does not work, and gates
  1b–1f for what shipped instead), and
  `waytide/local/experiments/2026-06-26T21-19-51Z-name-feature-run-1.md` (affirmed
  this session on its methodological findings).
- **Decision log** — `waytide/local/log/`, entries from `2026-07-26T17-27-23Z`
  through `2026-07-27T23-55-49Z`. The superseding entries name what they supersede;
  the superseded ones are left as written.
- **Local rules** — `waytide/local/rules/`, where the three library-specific rules
  were restored during the migration.
- **Code** — `lib/constant/import.rb` (the refusal, the refinement, and
  `Import.call`'s destination normalization), `lib/constant/import/macro.rb`
  (`private_constant :Macro`), `lib/constant/controls/script.rb`
  (`Script::Example#error`, `#execute`), `test/automated/import_constant/refinement/`
  and `test/automated/import_constant/macro/top_level.rb`, and the README's
  Instance Destinations section.

## A closing note

The session's shape is a single question asked at three widening scopes. It opened
as "how does the macro reach `main`", became "can the destination be omitted", and
resolved as "what should activate `import` at all" — and the answer at the widest
scope removed the feature the narrowest scope had spent a day building. Every step
of that widening came from someone declining to accept a conclusion that was
correctly reasoned within too small a frame: the engineer supplying the `test_init`
use case that reopened a settled direction, and later declining a recommended
Refuted verdict that was right about its mechanism and wrong about its question.
The reasoning was not faulty either time. The frame was.

---

Authored by Scott Bellware on Mon Jul 27 2026 at 5:41:35 PM PT
