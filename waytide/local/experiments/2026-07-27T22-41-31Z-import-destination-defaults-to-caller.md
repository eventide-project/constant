# Experiment — Import destination defaults to the caller

**State:** Affirmed
**Upstream branch:** `master`.
**Experiment branch:** `experiment/import-destination-defaults-to-caller`.
**Base:** `4f2367549b7b4d77cbac2ed9ebc1d92984db3e3e` (from `master`, "Migration file
is removed").
**Working location:** single tree.
**Origin:** the deferred item
`2026-07-27T18-11-43Z-import-call-destination-defaults-to-the-caller`, gated on the
Waytide migration; the gate cleared when the migration landed.

**Question:** can `Constant::Import.call`'s destination parameter be made optional
— `Constant::Import.(SomeOrigin)` importing into the calling module or class,
derived from the call stack rather than passed — with machinery sound enough to
stand behind, and is that machinery worth the argument it removes?

The macro already has this for free: `Macro#__import_constant` passes `self`, the
module body it was invoked in. The question is whether the plain API can offer the
same convenience without it. **A negative result is a legitimate outcome and is to
be recorded as one** — the experiment is not obliged to produce the feature.

## User confirmations

- **Working location** (2026-07-27, selection UI): **single tree**. Chosen over a
  worktree on the expectation that gate 1 may resolve in a sitting.
- DBE is followed; no suspension requested.

## Ground already covered (from the deferred item's probe, Ruby 4.0.1)

- `caller_locations` yields file and line only — not the caller's `self`
- `Binding.of_caller` is not defined
- `RubyVM::DebugInspector` is not defined
- the `binding_of_caller` and `debug_inspector` gems are not installed, and a
  runtime dependency for a convenience feature is judged too expensive
- `TracePoint` is available, and is the remaining pure-Ruby avenue

The destination is now normalized inside `Import.call` (a non-module destination
imports into its class), so a defaulted destination has to fit **ahead** of that
normalization rather than around it.

## The forecast (made before any work)

**Predicted verdict: refuted** — stated in advance so the outcome can be read
against it.

**Gate 1 — feasibility, and the reasoning behind the prediction.** The prediction
rests on what `TracePoint` yields: on a `:call` event, `tp.binding` is the binding
of the **callee**, not the caller. Recovering the caller's `self` in pure Ruby
therefore means keeping a TracePoint **enabled across the caller's own frame
entry** and maintaining a shadow stack of bindings — a globally-armed trace, whose
cost is paid by every method call in the host process, not only by imports. If
that is what the machinery costs, it is disqualifying for a library, and the
question resolves negative on feasibility grounds without reaching the design
hinges below. The forecast could be wrong in either direction: an arming strategy
narrow enough to be affordable would carry gate 1, and conversely the shadow-stack
approach might prove not merely expensive but unsound (frames that are entered
before the trace is armed, `instance_eval`, blocks, fibers).

**Tier 1 — gates.** Reached only if gate 1 carries.

- **Actuation** — the efferent shape of the defaulted call. Whether the arity
  genuinely drops (`Import.(origin)`) or the parameter takes a sentinel default;
  whether one method carries both shapes or the defaulted form is its own actuation.
- **Where the default resolves** relative to the existing normalization — the
  deferred item already establishes it must sit ahead of it, so this is the more
  specific question of whether derivation happens in `Import.call` or in a
  collaborator that `call` consults.
- **The failure behavior when the caller cannot be derived** — top-level `main`,
  a block, `instance_eval`, a `define_method` body. Predicted to be a real hinge:
  raising versus falling back to `Object` is load-bearing, and the wrong choice
  makes silent global pollution possible.

**Tier 2 — suspected.**

- The **observation** — whether the test asserts the constant is resolvable from
  the caller, or asserts the destination identity that derivation produced.
- The **controls** — the caller must be a **module body**, and the discriminating
  case needs a caller that is *not* the top level, or derivation isn't established
  at all (the same shape as the name experiment's nested-vs-top-level point).
- Whether class callers and module callers need separate outcomes, given the
  normalization already distinguishes them.

**Tier 3 — mechanical.** File paths, requires, `control_` prefixing, the "Is"
naming rule, and — enumerated deliberately, per the name experiment's post-integration
miss — **test context nesting mirroring the folders**.

**Forecast of the human's interjections.** On the evidence of the name experiment,
corrections are expected at the tier-1 gates, and at least one on the tier-2/3
boundary in naming or vocabulary. If gate 1 resolves negative, the forecast
predicts the deliberation moves to *whether the negative result is conclusive* —
i.e. whether the macro is thereby established as the answer — which is a judgment
the AI should not make alone.

## What actually happened

### Gate 1 — feasibility. Probed empirically on Ruby 4.0.1.

| Probe | Question | Result |
|---|---|---|
| A | Does `TracePoint(:call)#binding` yield the caller? | **No — the callee.** Traced into a callee invoked from `ProbeACaller`, `tp.binding.receiver` was `ProbeA`, the callee's own `self` |
| E | Does the `:return` event yield the caller? | **No — the callee.** Both `tp.binding.receiver` and `tp.self` were the callee |
| B | Can a TracePoint armed *inside* the method see the caller's frame? | **No.** The caller's frame was entered before the trace was armed, so no event for it ever fires |
| C | Can a `:line` trace that outlives the call recover the caller? | **Yes — but only *after* `call` has already returned** |
| D | What does a globally-armed shadow-stack `:call` trace cost? | **8.8× slower** over 300,000 method calls (0.0108 s → 0.0944 s) |
| F | What does `caller_locations` give at a module-body use site? | Labels only — `["<module:ProbeFUseSite>", "<main>"]`. No `self`, no binding |

**The forecast's central claim held:** `TracePoint` yields the **callee's** binding,
not the caller's (A, confirmed again at `:return` by E). The two consequences the
forecast predicted both landed.

**Probe C is the outcome the forecast did not anticipate in detail, and it is worse
than merely expensive — it is unsound.** The caller's `self` *is* recoverable in
pure Ruby by arming a `:line` TracePoint inside `call` and letting it survive the
return, skipping the callee's own frames. But the event fires only **after
`Import.call` has returned**, which breaks the feature in a way no amount of care
repairs: when the import is the **last statement in the module body**, there is no
subsequent `:line` event in that body at all. The trace then fires on whatever frame
runs next — an unrelated module body, a different file — and the import lands in
**the wrong destination, silently**. A mechanism whose failure mode is importing
into someone else's namespace without an error is not one to stand behind.

**Probe D disqualifies the sound alternative.** Capturing the caller's frame
correctly means arming the trace *before* the caller is entered — a globally-armed
trace maintaining a shadow stack of bindings. The cost is paid by **every method
call in the host process**, not only by imports: 8.8× on this machine. For a
library whose purpose is importing constants, that is not a trade anyone would
accept, and it is exactly the "disqualifying for a library" the forecast named.

**The design hinges were never reached.** Gate 1 resolved negative, so the tier-1
actuation, resolution-point, and undeliverable-caller hinges — and all of tier 2
and 3 — were not opened. No test was written and no implementation exists on this
branch; the experiment produced findings only.

## Findings

- **The question is answered negatively on feasibility, not on taste.** Ruby 4.0.1
  offers no pure-Ruby mechanism to obtain the caller's `self` at call time. The
  options are: unsound (C), unaffordable (D), or a C-extension dependency
  (`debug_inspector`) that the deferred item had already judged too expensive for a
  convenience feature — a judgment this evidence strengthens rather than revisits.
- **The macro is not a workaround for the missing feature — it is the mechanism
  that has the information.** `Macro#__import_constant` passes `self` because it is
  *invoked in the module body*, so the destination is its receiver rather than
  something to be recovered. The plain API cannot have that without being invoked
  the same way. This inverts the deferred item's framing: it supposed the macro's
  reason for being might narrow to `import`-as-a-keyword if the API could hide the
  argument. It can't, so the macro's reason for being is **wider** than the item
  supposed — it is the only sanctioned way to omit the destination.
- **A forecast that predicts its own verdict is still worth committing.** The
  predicted verdict (refuted) held, but the forecast's *reasoning* was incomplete in
  an informative way: it anticipated the cost objection (D) and missed the
  correctness objection (C) entirely. Had the experiment been skipped on the
  strength of the prediction alone, the silent-wrong-destination failure mode would
  never have been characterized — and it is the finding that actually forecloses
  the approach, since cost arguments invite "optimize it later" and correctness
  arguments do not.

### The verdict gate was put to the user and declined — the experiment continues

At the close of gate 1 the verdict was gated (2026-07-27, selection UI) with
**Refuted** recommended. The user chose **keep working it**, directing the
experiment at the adjacent avenue named in the option: whether a call *form* other
than the plain call can carry the destination without stack introspection.

**The Question is thereby broadened, and the broadening is recorded rather than
made silently.** As initiated, the Question asked whether the destination could be
"derived from the call stack rather than passed." Gate 1 answers that: **no.** The
Question the experiment now pursues is the motivating one the deferred item
actually stated — whether the destination can be **omitted at the use site** — of
which call-stack derivation was only the first candidate mechanism.

### Gate 1b — a block carries the caller's binding. Probed on Ruby 4.0.1.

`Proc#binding` is the binding of the block's **definition site**, so a block passed
at the use site carries the caller's `self` without any stack introspection at all.
Every case tried resolved correctly:

| Use site | `block.binding.receiver` |
|---|---|
| Module body | `UseSiteModule` ✓ |
| Class body | `UseSiteClass` ✓ |
| Nested module body | `Outer::Inner` ✓ |
| **Last statement in the body** | `UseSiteLastStatement` ✓ |
| Top level | `main` ✓ |
| Inside a method body | `MethodCaller` ✓ |

**The case that killed probe C passes here.** An import as the last statement in a
module body — where the `:line` trace had no subsequent event and would have
imported into the wrong destination silently — resolves correctly, because the
block was created in that body and carries its binding regardless of what runs
next. There is no timing involved: the binding is captured at block creation, not
recovered after the fact.

`Proc#binding` costs 7.3× a plain argument (200,000 calls: 0.0066 s → 0.0481 s).
**Unlike probe D, this cost is irrelevant** — D taxed every method call in the host
process, whereas this is paid once per import, at load time. The two numbers are
similar and mean opposite things; the difference is what the cost is levied on.

An explicit `binding` argument (probe H) also resolves correctly, but it is longer
than `self` at the use site and so removes nothing.

**So the mechanism question is settled affirmatively, and what remains is a design
hinge, not a feasibility one:** `Constant::Import.(Origin) { }` is sound and
available — but an empty block whose only purpose is to smuggle a binding is
obscure, and it is being weighed against `Constant::Import.(Origin, self)`, which
says plainly what it does, and against the macro's `import Origin`, which is
shorter than both and already exists.

### Gate 1c — the other use-site forms, probed rather than argued

The design hinge was put to the user (2026-07-27, selection UI) with three options;
the user chose **explore other forms first**, naming a curried `Import.into(self)`,
a `at: binding` keyword, and making the macro available without an explicit
`extend`. All were probed against the real library.

| Form | Use site | Result |
|---|---|---|
| `Constant::Import.into(self).(Origin)` | **36 chars** | Works. **Longer** than the 31-char `Constant::Import.(Origin, self)` it replaces |
| `Constant::Import.(Origin, at: binding)` | **38 chars** | Works. **Longer** than the explicit form |
| `Module.include(Constant::Import::Macro)` → `import Origin` | no ceremony | Works in any module **and** class body, with no `extend` |
| `refine Module` → `using …` + `import Origin` | one `using` per file | Works, lexically scoped |

**The first two forms lose on their own terms.** Both were offered as ways to stop
passing the destination, and both **relocate** the argument into *more* characters
than passing it cost — 36 and 38 against 31. Neither removes the noise the deferred
item objected to; they rename it. This is an empirical result, not a preference: the
forms were measured at the use site against the thing they were meant to improve.

**The third form is the only one that removes the argument entirely.** Patching
`Module` gives `import Origin` in any module or class body with no ceremony at all —
the `import`-as-a-keyword reading, delivered fully. A collision check found
`Module.instance_methods.grep(/import/)` **empty** before the patch, and there is
in-library precedent for global reach: `Import.included` already extends the
top-level `main` when included into `::Object`. The cost is a core monkey-patch —
every `Module` in the host process gains `:import` and `:__import_constant`, and
`import` is a generic enough name that a collision with another library is a real
risk this probe cannot rule out from inside one process.

**The refinement is the scoped version of the same idea**, trading the global
patch for one `using` per file. Against the status quo's one `extend` per module
that is a modest win — a file holding several modules pays once — bought with
refinement semantics, which are lexically scoped in ways that surprise.

### Gate 1d — what the global forms actually mutate, and what the refinement does instead

The user rejected `include Constant::Import` on the grounds that it activates the
macro in `Object` and so affects the entire process. Probed rather than assumed,
because the premise is checkable — and the blast radius turned out to be a
different **shape** than "everything", which matters for the comparison.

**`Object.include(Constant::Import)` — what it actually does.** Top-level `include`
includes into `Object`, so `Import.included` sees `base == ::Object` and runs both
branches:

| Effect | Result |
|---|---|
| `main` gains `import` | yes |
| `Object` gains `import` | yes |
| **Every class in the process** gains `import` | **yes** — including classes defined afterward |
| Every *module* gains `import` | **no** — `module TryIt; import Origin; end` raises `NoMethodError` |
| Instance methods added to every object | **none** — `Import.instance_methods(false)` is `[]` |
| `Object.ancestors` changed | yes — `Constant::Import` joins the chain, contributing no methods |

`Object.extend(Macro)` puts `Macro` in `Object`'s singleton class, and every class's
singleton class inherits from it — so the reach is **all classes, permanently**. It
does not reach modules, because a module's singleton class does not descend from
`Object`'s. The concern is therefore **broader than stated in one direction** (every
class, forever) and **narrower in another** (no modules, no instance methods, no
effect on ordinary objects).

**The refinement's effect on that problem: it removes it, and covers more ground.**

| | `include` at `Object` | `Module.include(Macro)` | Refinement |
|---|---|---|---|
| `Module.instance_methods.grep(/import/)` | `[]` | `[:__import_constant, :import]` | **`[]`** |
| Reaches classes | all of them | all of them | only under `using` |
| Reaches modules | **no** | all of them | **yes**, under `using` |
| Process-wide footprint | every class, permanently | every module, permanently | **none** |

Because `Class < Module`, refining `Module` covers **both** modules and classes — so
it closes the gap the `Object` include leaves while leaving nothing behind outside
the files that opt in. On the isolation axis it dominates both global forms.

**The refinement's costs, measured:**

- **It stops at the file boundary.** A module reopened in a file without `using`
  raises `NoMethodError: undefined method 'import' for module ReopenedElsewhere` —
  a message naming no remedy. A module split across files must repeat the `using`.
- **Introspection disagrees with itself.** Within the refined scope
  `respond_to?(:import)` is `true` while `methods.grep(/import/)` is `[]`.
- **`using` is not permitted inside a method** (`RuntimeError: main.using is
  permitted only at toplevel`). It is permitted at file top level and inside a
  module body, which covers the use sites in question.
- **Dynamic dispatch works** within the scope: `send`, `public_send`, `class_eval`
  with a block, and `class_eval` with a **string** all resolved.
- **A method defined in a refined file carries the refinement when called from an
  unrefined file.** A helper defined beside the `using` imported successfully when
  invoked from elsewhere — so the refinement is usable as an **internal** mechanism
  even if never exposed as the public form.

### Gate 1e — the form is settled by the user, and `refine ::Module` proves redundant

The user directed the form: `import SomeModule` available in `test_init.rb`, with
neither `include Constant::Import` nor `extend`. That is the refinement, and it
settles the actuation hinge by origination rather than selection.

Two reductions followed, each probed rather than argued:

- **`refine ::Module` is redundant.** `refine ::Object` alone covers `main`, module
  bodies, class bodies, an explicit module receiver, and instances — because
  modules and classes *are* objects. The `Module` refinement was written first,
  then dropped. `Object.instance_methods.grep(/import/)` and the `Module`
  equivalent both stay `[]`.
- **No separate `Refinement` module.** The refinement sits directly in
  `Constant::Import`, so the use site is `using Constant::Import` rather than
  `using Constant::Import::Refinement`. Verified under `-w`: `include
  Constant::Import` continues to work alongside it, with no warnings.

### Gate 1f — `Macro` is unpublished, and the record's earlier claim was wrong

Asked whether including `Constant::Import` could stop exposing `Macro`, the answer
was `private_constant :Macro` — with the obstacle that `Constant::Import::Macro`
appeared to be published surface (README **Instance Destinations**, a test, and a
decision-log entry calling it "a supported idiom").

**The user corrected the premise: `Macro` was only ever unpublished by convention.**
The characterization "public API" was an inference drawn from the README
documenting it, not from any recorded decision — "supported idiom" is what the log
actually said, and the two were collapsed. The correction is recorded here because
the mistaken reading was the sole basis for calling `private_constant` foreclosed.

With that settled, `private_constant :Macro` was applied. A module including
`Constant::Import` now reports `constants == []`, and `Constant::Import::Macro`
raises `NameError: private constant … referenced`. The `included` hook still works,
since it names `Macro` unqualified from inside the module.

### What was built

| File | Change |
|---|---|
| `lib/constant/import.rb` | `refine ::Object` defining `__import_constant` and its `import` alias |
| `lib/constant/import/macro.rb` | `private_constant :Macro`, placed after the module body so the constant exists |
| `lib/constant/controls/script.rb` | `Script.top_level_refinement_import` — subprocess control for the top-level form |
| `test/…/import_constant/refinement/refinement.rb` | Module receiver, plus an assertion that `Object.instance_methods.grep(/import/)` is empty |
| `test/…/import_constant/refinement/top_level.rb` | Subprocess: `using Constant::Import` then bare `import SomeOrigin` |
| `test/…/import_constant/refinement/instance.rb` | Moved from `macro/instance.rb`, rewired to the refinement |
| `README.md` | Instance Destinations documents `using Constant::Import` |

**103 tests pass, 0 failed** (99 before). Four decision-log entries written, two of
them superseding earlier entries that the change invalidated.

## Findings

- **The refuted verdict at gate 1 was for the right conclusion about the wrong
  scope.** Call-stack derivation is genuinely dead — probes A, B, C, E and the 8.8×
  of D stand unchanged. But the experiment's *question* was the motivating one
  (can the destination be omitted at the use site), and the answer to that is
  **yes**. Had the verdict gate been accepted when it was first offered, the
  experiment would have closed as refuted with a working answer one probe away.
  The user declining the recommended conclusion is what produced the feature.
- **Every reduction came from probing a thing the reasoning had assumed.**
  `refine ::Module` was written because `main` was known not to be a Module; nobody
  asked whether `Object` covered modules until it was measured, and it did. The
  separate `Refinement` namespace existed until asked about. `private_constant` was
  called foreclosed on an inference nobody had checked. Three assumptions, three
  reductions.
- **The forecast's tier-3 list was never exercised**, because the design hinges it
  belonged to were reached by a different route than the forecast imagined — the
  user dictating the form outright, rather than the AI proposing options at an
  actuation gate. Origination bypassed the option-set entirely, which is the
  mechanism working as intended and not something the tier partition models.

## Conclusion — Affirmed

**User confirmation:** Scott Bellware declared the experiment **affirmed** on
2026-07-27.

**The affirmation is qualified, and the qualification is the point: the solution
does not leverage the caller's binding.** That mechanism — the one the experiment
was initiated to test — is **impracticable**, and gate 1 establishes it as such:

- `TracePoint` yields the **callee's** binding, not the caller's (probes A, E)
- a trace armed inside the method cannot see the already-entered caller frame (B)
- the one pure-Ruby recovery that works fires **after the call has returned**, and
  imports into the **wrong destination silently** when the import is the last
  statement in a module body (C)
- the sound alternative — a globally-armed shadow stack — costs **8.8×** on every
  method call in the host process (D)

What is affirmed is the **motivating question**, not the mechanism: the destination
*can* be omitted at the use site. It is omitted by a `refine ::Object` on
`Constant::Import`, activated with `using Constant::Import` — the caller supplies
its own `self` as the refined method's receiver, so nothing is derived from the
stack at all. The caller is not *inspected*; it is simply the receiver.

Anyone reading this record for the caller-binding technique should stop at gate 1.
It does not work, and the feature that shipped does not use it.

**Implementation merged.** The experiment produced code, the suite passes (**103
tests, 0 failed**, from 99 at the base), so the branch merges to `master` under the
test gate — no untested-code confirmation was required.

**Log copy.** The decisions were logged as they were made — `macro-is-unpublished`,
`instance-import-idiom-is-the-refinement`,
`instance-destination-test-moves-to-refinement`, and `import-refinement-on-object`.
The affirmation adds the two **methodological** findings, which had no entries: that
declining a recommended verdict is what produced the feature, and that each
reduction came from probing an assumption rather than reasoning from it.

## Final state

- Gate 1 negative (caller binding impracticable); gates 1b–1f positive.
- Implementation complete, **103 tests pass**, committed as `d9795d0`.
- **Integrated to `master`.**

---

Authored by Scott Bellware on Mon Jul 27 2026 at 3:41:31 PM PT
Changed by Scott Bellware on Mon Jul 27 2026 at 4:28:56 PM PT
Changed by Scott Bellware on Mon Jul 27 2026 at 4:40:44 PM PT
