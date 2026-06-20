# Observation: hinges in human-in-the-loop TDD — the marks of a hinge, and how to discover the missing ones

**Status:** Working hypothesis, under active discovery. Not a binding rule. Promote to a rule once the set of hinges stabilizes. The candidate hinges below are proposals to be judged, not settled conventions.

**Lexicon (2026-06-20):** a **hinge** is a decision the design turns on; the loop **gates** (stops) at hinges so the human can **deliberate** them; everything else is **mechanical** (the mechanics) — the AI generates it straight through. A decision is a hinge when it is **subtle** and **load-bearing** (the two marks below). "Discriminator" — the earlier name for the test of hinge-ness — is retired; the test is just "is this a hinge?" See the dialogue digest for how this vocabulary was settled.

## Why this is recorded as an observation, not a rule

The hinges are the essence of human-in-the-loop TDD (see the human-in-the-loop rule and `agent/design/2026-06-20-human-in-the-loop-tdd-design.md`). Two hinges are known by intuition — the efferent call (setting the cradle) and solubility — but the rule that *produced* them was never stated, and more hinges are suspected but unclear. This records the marks that identify a hinge and the method for finding the rest. It is mid-discovery, so it is held as an observation rather than canonized.

## The marks of a hinge

**Terminology (2026-06-20):** the two marks are **subtle** and **load-bearing** — plainer than the earlier "intrinsic" and "asymmetric"; the meaning is unchanged. "Subtle" draws on Bellware's distinction between *subtle* and *crude* knowledge (https://madabout.software/articles/subtle-knowledge-crude-knowledge/): crude knowledge is tools and patterns — visible, derivable; subtle knowledge is design principles and qualities — invisible to the unpracticed eye but foundational. (History: an earlier "intrinsic" framing replaced a capability-relative one — the subtle mark is about whether the answer is in the artifacts, not about how good the AI is. Affordability was split out as a separate, provisional question.)

A hinge is a decision that is **subtle** and **load-bearing** at the same time.

1. **Subtle** — the choice turns on design judgment: taste, intent, what "good" looks like here. That is subtle knowledge, not crude knowledge (a tool, a pattern, a name you can read off the code). The answer isn't written in the code or the tests, so you can't derive it from them — it lives in the person. Crude choices aren't hinges; the AI can just make them.
2. **Load-bearing** — other work gets built on top of the choice. Get it wrong and the mistake spreads and sticks: cheap to fix now, costly later. A choice that stays local and is easy to change isn't load-bearing.

Both are required (AND, not OR). Subtle but local → not a hinge (let the AI do it, fix it whenever). Load-bearing but crude → not a hinge (the answer is there to read; no judgment needed). **A hinge is where a subtle call meets work that will rest on it** — and that is where the loop gates for deliberation.

Two questions to test any candidate:

- Does the choice take design judgment that isn't written in the code or tests — subtle, not crude?
- Will other work rest on it, so a wrong choice spreads and sticks — load-bearing?

Yes to both → it is a hinge; gate there and let the human deliberate it.

A note on why "subtle vs crude" and not "how good is the AI": subtlety is a fact about the design, not about the tool generating it. A smarter model doesn't turn a subtle call crude — the judgment was never written down to read. So the set of hinges doesn't shrink as models improve.

**Whether we can afford to gate is a separate question** (provisional): *can the hinge be put to the human quickly?* A real-but-expensive hinge is still a hinge — it just needs a cheaper proxy. Not part of the definition.

### Examples

- *Naming a local variable* — you can read the right name off the value it holds (crude), and it stays local. Not a hinge.
- *The shape of the call (the efferent interface)* — written nowhere yet, takes judgment (subtle), and everything gets built on it (load-bearing). A hinge.
- *Whether the unit is soluble* — passing tests don't tell you (subtle), and a clumsy shape gets built on (load-bearing). A hinge.

### Validation — passes 1 and 2 (2026-06-20)

Tested against the two marks. See the settling observation for the full method.

**Pass 1 — calibrate on the knowns (must pass):**
- *Efferent call* — subtle: yes (at first writing nothing exists yet; the call's shape is pure seed, in no artifact). Load-bearing: yes, strongly — the call is the contract; every test and the implementation rest on it. **Hinge ✓**
- *Solubility* — subtle: yes (green tests do not encode whether the unit dissolves into use). Load-bearing: yes — a non-soluble shape sets and accretes downstream. **Hinge ✓**
- Both fixed points preserved.

**Pass 2 — specificity on known mechanical decisions (must be rejected):**
- *Name of an explaining variable* — subtle-ish (some taste) but **fails load-bearing**: test-local, non-propagating, renamable anytime. **Not a hinge ✓**
- *Order of `comment` lines* — crude (convention) and non-propagating. **Not a hinge ✓**
- *Whitespace / formatting* — crude (style) and non-propagating. **Not a hinge ✓**

**Findings:**
- Both marks are read off the artifacts, not off model behavior: **subtle** = "absent from the artifacts," **load-bearing** = "inherited by downstream artifacts." Capability-independent.
- **The AND is validated.** Explaining-variable naming is subtle-ish yet correctly rejected *because it isn't load-bearing* — exactly the case that distinguishes AND from OR.
- **Load-bearing is the sharper blade for specificity**; the subtle mark is fuzzier at the margin (naming has some taste).
- Emergent partial resolution of the **naming candidate**: the load-bearing mark cleanly separates *interface/contract names* (propagate and set → hinge-ward) from *test-local names* (non-propagating → not a hinge). The bare word "naming" conflated the two.

Remaining to settle: pass 3 (reconcile the candidate hinges), pass 4 (stress the boundary — subtle-but-local, load-bearing-but-crude), and ratification of the affordability split.

## How to discover the missing hinges

A pincer:

- **Analytical — decompose and classify.** Walk one real feature end to end, list every decision however small, test each against the two marks. Passers are candidate hinges; the rest are generation. Corpus to replay: `define_constant.rb`, `import_constant.rb`.
- **Empirical — watch the seams.** Wherever the human reaches in to correct the AI, an un-formalized hinge just fired. Run a feature live, log every intervention; each one names a hinge. Interventions are hinges announcing themselves.

The recursion that makes it collaborative: **deciding what counts as a hinge is itself a hinge.** The AI proposes candidates; the human deliberates which are real. The discovery loop has the same shape as the thing it designs — which is also a correctness check on the framework.

## Candidate hinges (first pass — to be judged, not adopted)

Beyond the two known hinges (efferent call; solubility):

- **Decomposition hinge** — is this one unit, or should it split? Fires when the implementation reveals a seam. Likely real; probably upstream of solubility.
- **Intent / correctness hinge** — does the asserted outcome encode the intended truth, not merely a green bar? Distinct from solubility (which judges design quality). Suspected most important missing hinge: the AI can make a wrong expectation pass convincingly.
- **Outcome-set hinge** — are these the outcomes that establish the concern; is anything essential unasserted or anything asserted that doesn't matter?
- **Concern hinge** (furthest upstream) — should we build this unit at all? Possibly out of scope for the TDD loop proper.
- **Naming hinge** — do the names say what the things are? Eventide-critical, but may be a facet of the cradle/efferent call rather than its own hinge. Genuinely unclear; a good test of the marks.

Expectation: the marks should *reject* at least one of these, and at least one likely folds into an existing hinge.

## Next moves

1. Finish settling the marks — they are what identifies every hinge, including the two already in use.
2. Then run the empirical pass on one real feature (`import_constant` is richer — it has the alias and already-included branches): drive it turn by turn while the human marks every intervention point. The interventions are the missing hinges, surfaced from behavior rather than speculation.
