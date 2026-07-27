# Experiment — Import destination defaults to the caller

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

_To be recorded as the work proceeds._

## Findings

_To be recorded._

## Final state

_To be recorded._

---

Authored by Scott Bellware on Mon Jul 27 2026 at 3:41:31 PM PT
