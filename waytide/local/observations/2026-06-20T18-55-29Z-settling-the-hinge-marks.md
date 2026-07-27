# Observation: how to settle the marks of a hinge

**Status:** Working hypothesis, under active discovery. Not a binding rule. Companion to `agent/observations/2026-06-20T18-48-32Z-tdd-hinge-marks-and-discovery.md` — that one defines the marks of a hinge; this one is the method for settling them. Promote to a rule once the marks are settled (and fold the settled marks into `agent/rules/`).

**Lexicon (2026-06-20):** a **hinge** is a decision the design turns on; the loop **gates** at hinges for the human to **deliberate**; everything else is **mechanical** (the mechanics) — the AI generates it. A decision is a hinge when it is **subtle** and **load-bearing**. "Discriminator" (the earlier name for the test of hinge-ness) is retired. See the dialogue digest.

## What "settled" means (the stopping criterion)

The marks are settled when, **applied blind to a decision, they produce the verdict the human's deliberation would — across a known corpus and a set of adversarial cases — with zero unreconciled disagreements.** Then they earn promotion from observation to rule.

The recursion: "settled" is itself a solubility-style judgment the human ratifies. The AI applies the marks and reports verdicts; whether they are settled is itself a hinge, and that hinge belongs to the human.

## The procedure — four passes, cheapest and most decisive first

1. **Calibrate on the knowns (fixed points).** The two known hinges — the efferent call, and solubility — must pass both marks. If either fails, the *marks* are wrong, not the hinge. This anchors them.
2. **Test specificity on known mechanical decisions.** Decisions we are confident are mechanical (the AI just generates them) — the name of an explaining variable, the order of `comment` lines, whitespace — must be *rejected*. Marks that admit everything are useless; if a mechanical decision passes, a mark needs tightening.
3. **Reconcile the candidates.** Apply the marks to the candidate hinges (decomposition, intent/correctness, outcome-set, concern, naming). Where the marks' verdict and the human's deliberation disagree, *that disagreement is the work*: either a mark is missing a dimension, or the intuition was wrong. Each reconciliation refines a mark or kills a candidate. Do not stop while a disagreement stands.
4. **Stress the boundary.** Construct adversarial cases built to break them — subtle but reversible (local); load-bearing but crude (mechanizable) — and confirm the two-mark AND correctly rejects them.

## The two soft spots that needed settling

The passes above are mechanical. These two were the real thinking:

### A. The subtle mark is about the artifacts, not the AI (ratified)

An earlier framing tested the judgment mark by AI behavior — "would the AI average here?" That is contingent on model capability, so the set of hinges would *shrink as models improve* — the wrong foundation.

Fix (ratified): found it on the artifacts — *the decision is underdetermined by the code and the tests; its correct resolution needs intent or taste that exists only in the human.* Stable regardless of which model is generating. (First ratified under the name "intrinsic," then renamed **subtle**, per Bellware's subtle/crude distinction.)

### B. Affordability is separate from hinge-ness (provisional)

"Can it be put to the human quickly?" is not part of what makes a decision a hinge — it is an **affordability** filter. A decision can be a true hinge and still be expensive to deliberate. Conflating them would wrongly discard real hinges for being costly to gate.

Proposed split:
- **Is it a hinge?** — subtle **and** load-bearing.
- **Can we afford to gate it?** — the quick-question filter.

A real-but-unaffordable hinge is still a hinge; it just needs a cheaper proxy. (Provisional — not yet ratified.)

## Resulting definition (with A ratified, B provisional)

> A decision is a **hinge** iff its correct resolution needs intent/taste absent from the code and tests (**subtle**), and a wrong resolution spreads and sticks (**load-bearing**). Affordability is a separate, downstream question.

## Progress (2026-06-20)

- **Soft-spot A: ratified.** The subtle mark is founded on the artifacts (underdetermined-by-the-artifacts), not on AI capability. The marks observation was rewritten accordingly.
- **Soft-spot B: provisionally adopted, not yet ratified.** Affordability is split out of the hinge definition for the purpose of running the passes.
- **Pass 1 (calibrate on knowns): green.** Both fixed points — efferent call and solubility — pass.
- **Pass 2 (specificity on mechanical decisions): green.** Explaining-variable naming, `comment` order, and whitespace are all correctly rejected. The AND is validated (naming is subtle-ish but rejected via load-bearing), and load-bearing emerges as the sharper specificity blade. Full results in the marks observation.
- **Remaining:** pass 3 (reconcile the candidate hinges), pass 4 (boundary stress), and ratification of soft-spot B.

## Where to start

The cheapest decisive move is **pass 2 on a single mechanical decision**: if the marks cannot cleanly reject "the name of an explaining variable," nothing else matters. Then passes 1 and 3. The remaining open ratification (soft-spot B) is a hinge only the human can take.
