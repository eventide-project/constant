# Observation: gate-ness in human-in-the-loop TDD — the discriminator and how to discover the missing gates

**Status:** Working hypothesis, under active discovery. Not a binding rule. Promote to a rule once the gate set stabilizes. The candidate gates below are proposals to be judged, not settled conventions.

## Why this is recorded as an observation, not a rule

The gates are the essence of human-in-the-loop TDD (see the human-in-the-loop rule and `agent/design/2026-06-20-human-in-the-loop-tdd-design.md`). Two gates are known by intuition — the efferent call (setting the cradle) and solubility — but the rule that *produced* them was never stated, and more gates are suspected but unclear. This records the discriminator that detects gates and the method for finding the rest. It is mid-discovery, so it is held as an observation rather than canonized.

## The discriminator — what makes a decision a gate

**Revision (2026-06-20):** judgment-bearing is now defined **intrinsically** (ratified — soft-spot A in `agent/observations/2026-06-20T18-55-29Z-settling-the-gate-discriminator.md`). The earlier capability-relative phrasing ("the AI would average") is retired: it made the gate set shrink as models improve, which is the wrong foundation. Affordability is provisionally split out (soft-spot B, not yet ratified).

A gate is a decision point in the loop with two properties at once:

1. **Intrinsic judgment** — the decision is *underdetermined by the code and the tests*; its correct resolution requires intent or taste that exists only in the human, nowhere in the artifacts. (Capability-independent: it does not matter how good the generating model is — the information simply is not in the artifacts.)
2. **Asymmetric** — a wrong resolution propagates and sets: downstream artifacts inherit it, so it is cheap to fix now and expensive later. (Also intrinsic — you can see it by asking whether other code inherits the decision.)

Both are required (AND, not OR). Intrinsic judgment but local/non-propagating → not a gate (let the AI generate, correct anytime). Asymmetric but determined by the artifacts → not a gate (no human-only judgment needed). **A gate is where human-only judgment and irreversibility intersect.**

Two questions to test any candidate:

- Is the correct resolution absent from the code and tests — does it need intent/taste only the human holds? *(intrinsic judgment)*
- Does a wrong answer propagate and set into downstream artifacts? *(asymmetry)*

Pass both → it is a gate.

**Affordability is a separate, downstream question** (provisional, per soft-spot B): *can the gate be posed as a question the human answers quickly?* A real-but-unaffordable gate is still a gate — it just needs a cheaper proxy. This is not part of the gate definition.

### Validation — passes 1 and 2 (2026-06-20)

Run against the intrinsic discriminator. See the settling observation for the full method.

**Pass 1 — calibrate on the knowns (must pass):**
- *Efferent call* — intrinsic judgment: yes (at first writing nothing exists yet; the call's shape is pure seed, underdetermined by any artifact). Asymmetric: yes, strongly — the call is the contract; every test and the implementation inherit it. **Gate ✓**
- *Solubility* — intrinsic judgment: yes (green tests do not encode whether the unit dissolves into use; the artifacts underdetermine it). Asymmetric: yes — a non-soluble shape sets and accretes downstream. **Gate ✓**
- Both fixed points preserved under the intrinsic definition.

**Pass 2 — specificity on known non-gates (must be rejected):**
- *Name of an explaining variable* — judgment-ish (some taste) but **fails asymmetry**: test-local, non-propagating, renamable anytime. **Not a gate ✓**
- *Order of `comment` lines* — determined by convention (not intrinsic) and non-propagating. **Not a gate ✓**
- *Whitespace / formatting* — determined by style, non-propagating. **Not a gate ✓**

**Findings:**
- The intrinsic refounding holds: **both legs are now capability-independent** — intrinsic judgment ("absent from the artifacts") and asymmetry ("inherited by downstream artifacts") are both read off the artifacts, not off model behavior.
- **The AND structure is validated.** Explaining-variable naming is judgment-ish yet correctly rejected *because it fails asymmetry* — exactly the case that distinguishes AND from OR.
- **Asymmetry is the sharper blade for specificity**; the intrinsic-judgment leg is fuzzier at the margin (naming has some taste).
- Emergent partial resolution of the **naming candidate**: the asymmetry leg cleanly separates *interface/contract names* (propagate and set → gate-ward) from *test-local names* (non-propagating → not a gate). The bare word "naming" conflated the two.

Remaining to settle: pass 3 (reconcile the five candidates), pass 4 (stress the boundary — judgment-but-reversible, asymmetric-but-mechanizable), and ratification of soft-spot B.

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
