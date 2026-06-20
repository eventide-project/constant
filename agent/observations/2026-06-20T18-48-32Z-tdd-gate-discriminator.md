# Observation: gate-ness in human-in-the-loop TDD — the discriminator and how to discover the missing gates

**Status:** Working hypothesis, under active discovery. Not a binding rule. Promote to a rule once the gate set stabilizes. The candidate gates below are proposals to be judged, not settled conventions.

## Why this is recorded as an observation, not a rule

The gates are the essence of human-in-the-loop TDD (see the human-in-the-loop rule and `agent/design/2026-06-20-human-in-the-loop-tdd-design.md`). Two gates are known by intuition — the efferent call (setting the cradle) and solubility — but the rule that *produced* them was never stated, and more gates are suspected but unclear. This records the discriminator that detects gates and the method for finding the rest. It is mid-discovery, so it is held as an observation rather than canonized.

## The discriminator — what makes a decision a gate

A gate is a decision point in the loop with two properties at once:

1. **Judgment-bearing** — resolving it correctly requires design taste the human holds and the AI doesn't; left alone, the AI averages toward common code rather than decides.
2. **Asymmetric in cost** — a wrong resolution is cheap to fix now and expensive later, because it bakes in and everything downstream inherits it.

Both are required. Judgment-bearing but cheap-to-fix-anytime → not a gate (let the AI generate, correct later). Asymmetric but the AI resolves it correctly alone → not a gate (no judgment needed). **A gate is where judgment and irreversibility intersect.**

Four questions to test any candidate:

- Left alone, would the AI guess or regress to the average here? *(judgment)*
- Is this a call the human can make and the AI can't? *(judgment)*
- Does a wrong answer propagate and set? *(asymmetry)*
- Can it be posed as a question the human answers quickly? *(gates must be cheap, or they aren't worth the interruption)*

Pass all four → it is a gate. The two known gates pass cleanly, which calibrates the discriminator.

## How to discover the missing gates

A pincer:

- **Analytical — decompose and classify.** Walk one real feature end to end, list every decision however small, run the discriminator on each. Passers are candidate gates; the rest are generation. Corpus to replay: `define_constant.rb`, `import_constant.rb`.
- **Empirical — watch the seams.** Wherever the human reaches in to correct the AI, an un-formalized gate just fired. Run a feature live, log every intervention; each one names a gate. Interventions are gates announcing themselves.

The recursion that makes it collaborative: **discovering gates is itself gated.** The AI generates candidate gates; the human judges which are real. The discovery loop has the same shape as the thing it designs — which is also a correctness check on the framework.

## Candidate gates (first pass — to be judged, not adopted)

Beyond the two known gates (efferent call; solubility):

- **Decomposition gate** — is this one unit, or should it split? Fires when the implementation reveals a seam. Likely real; probably upstream of solubility.
- **Intent / correctness gate** — does the asserted outcome encode the intended truth, not merely a green bar? Distinct from solubility (which judges design quality). Suspected most important missing gate: the AI can make a wrong expectation pass convincingly.
- **Outcome-set gate** — are these the outcomes that establish the concern; is anything essential unasserted or anything asserted that doesn't matter?
- **Concern gate** (furthest upstream) — should we build this unit at all? Possibly out of scope for the TDD loop proper.
- **Naming gate** — do the names say what the things are? Eventide-critical, but may be a facet of the cradle rather than its own gate. Genuinely unclear; a good test of the discriminator.

Expectation: the discriminator should *reject* at least one of these, and at least one likely folds into an existing gate.

## Next moves

1. Sharpen and settle the discriminator first — it is the tool that validates every gate, including the two already in use.
2. Then run the empirical pass on one real feature (`import_constant` is richer — it has the alias and already-included branches): drive it turn by turn while the human marks every intervention point. The interventions are the missing gates, surfaced from behavior rather than speculation.
