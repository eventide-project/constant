# Observation: gate-ness in human-in-the-loop TDD — the discriminator and how to discover the missing gates

**Status:** Working hypothesis, under active discovery. Not a binding rule. Promote to a rule once the gate set stabilizes. The candidate gates below are proposals to be judged, not settled conventions.

## Why this is recorded as an observation, not a rule

The gates are the essence of human-in-the-loop TDD (see the human-in-the-loop rule and `agent/design/2026-06-20-human-in-the-loop-tdd-design.md`). Two gates are known by intuition — the efferent call (setting the cradle) and solubility — but the rule that *produced* them was never stated, and more gates are suspected but unclear. This records the discriminator that detects gates and the method for finding the rest. It is mid-discovery, so it is held as an observation rather than canonized.

## The discriminator — what makes a decision a gate

**Terminology (2026-06-20):** the two legs are named **subtle** and **load-bearing** — plainer than the earlier "intrinsic" and "asymmetric"; the meaning is unchanged. "Subtle" draws on Bellware's distinction between *subtle* and *crude* knowledge (https://madabout.software/articles/subtle-knowledge-crude-knowledge/): crude knowledge is tools and patterns — visible, derivable; subtle knowledge is design principles and qualities — invisible to the unpracticed eye but foundational. (History: soft-spot A ratified that this leg is about whether the answer is in the artifacts, not about how good the AI is. Soft-spot B — splitting affordability out — is provisional.)

A gate is a decision that is **subtle** and **load-bearing** at the same time.

1. **Subtle** — the choice turns on design judgment: taste, intent, what "good" looks like here. That is subtle knowledge, not crude knowledge (a tool, a pattern, a name you can read off the code). The answer isn't written in the code or the tests, so you can't derive it from them — it lives in the person. Crude choices aren't gates; the AI can just make them.
2. **Load-bearing** — other work gets built on top of the choice. Get it wrong and the mistake spreads and sticks: cheap to fix now, costly later. A choice that stays local and is easy to change isn't load-bearing.

Both are required (AND, not OR). Subtle but local → not a gate (let the AI do it, fix it whenever). Load-bearing but crude → not a gate (the answer is there to read; no judgment needed). **A gate is where a subtle call meets work that will rest on it.**

Two questions to test any candidate:

- Does the choice take design judgment that isn't written in the code or tests — subtle, not crude?
- Will other work rest on it, so a wrong choice spreads and sticks — load-bearing?

Yes to both → it is a gate.

A note on why "subtle vs crude" and not "how good is the AI": subtlety is a fact about the design, not about the tool generating it. A smarter model doesn't turn a subtle call crude — the judgment was never written down to read. So the set of gates doesn't shrink as models improve.

**Whether we can afford to ask is a separate question** (provisional, per soft-spot B): *can the gate be put to the human quickly?* A real-but-expensive gate is still a gate — it just needs a cheaper proxy. Not part of the definition.

### Examples

- *Naming a local variable* — you can read the right name off the value it holds (crude), and it stays local. Not a gate.
- *The shape of the call (the efferent interface)* — written nowhere yet, takes judgment (subtle), and everything gets built on it (load-bearing). A gate.
- *Whether the unit is soluble* — passing tests don't tell you (subtle), and a clumsy shape gets built on (load-bearing). A gate.

### Validation — passes 1 and 2 (2026-06-20)

Run against the discriminator. (The bullets below use the earlier labels: *intrinsic judgment* = **subtle**, *asymmetric* = **load-bearing**.) See the settling observation for the full method.

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
