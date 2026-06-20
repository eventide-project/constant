# Observation: how to settle the gate discriminator

**Status:** Working hypothesis, under active discovery. Not a binding rule. Companion to `agent/observations/2026-06-20T18-48-32Z-tdd-gate-discriminator.md` — that one defines the discriminator; this one is the method for settling it. Promote to a rule once the discriminator is settled (and fold the settled discriminator itself into `agent/rules/`).

## What "settled" means (the stopping criterion)

The discriminator is settled when, **run blind on a decision, it produces the verdict the human's judgment would — across a known corpus and a set of adversarial cases — with zero unreconciled disagreements.** Then it earns promotion from observation to rule.

The recursion: "settled" is itself a solubility-style judgment the human ratifies. The AI runs the discriminator and reports verdicts; whether it is settled is a gate, and that gate belongs to the human.

## The procedure — four passes, cheapest and most decisive first

1. **Calibrate on the knowns (fixed points).** The two accepted gates — the efferent call, and solubility — must pass all the discriminator's criteria. If either fails, the *discriminator* is wrong, not the gate. This anchors it.
2. **Test specificity on known non-gates.** Decisions we are confident are pure generation — the name of an explaining variable, the order of `comment` lines, whitespace — must be *rejected*. A discriminator that admits everything is useless; if a non-gate passes, a property needs tightening.
3. **Reconcile the candidates.** Run it on the five candidate gates (decomposition, intent/correctness, outcome-set, concern, naming). Where the discriminator's verdict and the human's judgment disagree, *that disagreement is the work*: either the discriminator is missing a dimension, or the intuition was wrong. Each reconciliation refines the discriminator or kills a candidate. Do not stop while a disagreement stands.
4. **Stress the boundary.** Construct adversarial cases built to break it — judgment-bearing but reversible; asymmetric but fully mechanizable — and confirm the two-property AND correctly rejects them.

## The two soft spots that actually need settling

The passes above are mechanical. These two are the real thinking, and settling means deciding them:

### A. "Judgment-bearing" is currently capability-relative; it should be intrinsic

The current definition tests judgment-bearing by AI behavior — "would the AI average here?" That is contingent on model capability, so the gate set *shrinks as models improve* — the wrong foundation.

Proposed fix: re-found it on an **intrinsic** property — *the decision is underdetermined by the code and the tests; its correct resolution requires intent or taste that exists only in the human, nowhere in the artifacts.* Stable regardless of which model is generating. This is the most important thing to settle.

### B. Affordability is conflated with gate-ness; split them

The "can it be posed as a quick question?" criterion is not a definition of gate-ness — it is an **affordability** filter. A decision can be a true gate and still be expensive to pose. Conflating them would wrongly discard real gates for being costly to check.

Proposed fix: split the criteria.
- **Is it a gate?** — intrinsic judgment (A) **and** asymmetry (a wrong resolution propagates and sets).
- **Can we afford to gate it?** — the quick-question test.

A real-but-unaffordable gate is still a gate; it just needs a cheaper proxy, which is its own problem.

## Resulting candidate discriminator (if A and B hold)

> A decision is a gate iff its correct resolution requires intent/taste absent from the code and tests (**intrinsic judgment**), and a wrong resolution propagates and sets (**asymmetry**). Affordability is a separate, downstream question.

## Progress (2026-06-20)

- **Soft-spot A: ratified.** Judgment-bearing is now intrinsic (underdetermined-by-the-artifacts), not capability-relative. The discriminator in the gate-discriminator observation was rewritten accordingly.
- **Soft-spot B: provisionally adopted, not yet ratified.** Affordability is split out of the gate definition for the purpose of running the passes. Still needs a ratification decision.
- **Pass 1 (calibrate on knowns): green.** Both fixed points — efferent call and solubility — pass under the intrinsic definition.
- **Pass 2 (specificity on non-gates): green.** Explaining-variable naming, `comment` order, and whitespace are all correctly rejected. The AND structure is validated (naming is judgment-ish but rejected via asymmetry), and asymmetry emerges as the sharper specificity blade. Full results recorded in the gate-discriminator observation.
- **Remaining:** pass 3 (reconcile the five candidates), pass 4 (boundary stress), and ratification of soft-spot B.

## Where to start

The cheapest decisive move is **pass 2 on a single non-gate**: if the discriminator cannot cleanly reject "the name of an explaining variable," nothing else matters and we fix it first. Then passes 1 and 3.

But the two soft spots are forks only the human can take, and they come first. Open question to resolve before any pass: **should "judgment-bearing" be intrinsic (underdetermined-by-the-artifacts) rather than capability-relative (the-AI-would-average)?** Recommendation: intrinsic. If accepted, rewrite the discriminator in the gate-discriminator observation accordingly, then run passes 1–2 to confirm it still classifies the knowns correctly.
