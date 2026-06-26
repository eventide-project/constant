# Observation: TDD dialogue digest (running record)

**Status:** Running record, appended to as the TDD design dialogue proceeds (per the auto-record-tdd-dialogue rule). Captures the *flow and reasoning* of the conversation; discrete conclusions live in the linked rules and observations. Not binding.

This digest preserves why each fork was taken, not just what was decided. Newest entries at the bottom. Detail lives in the discrete files it points to.

---

## 2026-06-20 — Session: establishing TDD as a design tool, then formalizing the gates

### Framing: TDD is a design tool, not a ceremony
TDD here is a design tool; red-green-refactor is choreography that only ever existed to insert a human's attention. A test written before its implementation is trivially going to fail — that failure teaches nothing, so we don't stop to observe the red bar. The point is the **cradle** (refined across the dialogue: jig → harness → *cradle* — it holds the implementation in proper position without gripping it rigid, supporting generation within the dictates of the efferent view while leaving it free to move inside those bounds). The target is **solubility**: how readily a unit dissolves into use. "Efferent in, efferent out" — condition on this project's high-solubility code, not the average of code seen. Design judgment stays with the human. → rule `…18-07-21Z-tdd-as-design-tool.md`.

### Terminology: efferent, never caller
The use-site perspective is always **efferent** (efferent side / reference / view), never "caller." "Actuation" and "the call to the unit under test" stay fine — they name the invocation, not the perspective. Applied retroactively across the TDD rules. → rule `…18-30-05Z-tdd-efferent-not-caller.md`.

### The process, turn by turn
- **Turn one:** start a feature by writing *only* the test file — proper context nesting, one `test` block, one assertion against an **explaining variable** holding the result of actuating the concern. No implementation; don't pause on the inevitable failure. → rule `…18-11-57Z-tdd-first-turn-test-file.md`.
- **Next turn (described, not yet its own rule):** bring the unit into existence inside the cradle, generate straight through toward solubility, run the test to *confirm* (verification, not the green half of a ceremony).
- **Then loop by outcome;** exit on solubility, not coverage.

### Test structure (exemplar: `define_constant.rb`)
Actuate once at the top of the feature context; assert each outcome in its own inner context. Explaining variables carry the assertion (never assert an inline expression); narration is layered (`comment` scenario-wide, `detail` context-local); one assertion per `test`, one outcome per `context`. → rule `…18-13-51Z-tdd-test-structure.md`.

### Human-in-the-loop: gate on the call and on solubility, never on pass/fail
Relocate the human's attention to where design judgment lives — setting the cradle (the efferent call) and judging solubility — and let the AI generate straight through between. Never gate on red/green. The human owns the call and the solubility verdict; the AI owns generation. → rule `…18-36-39Z-tdd-human-in-the-loop.md`, design doc `agent/design/2026-06-20-human-in-the-loop-tdd-design.md`.

### The pivot: "the definition of the gates is essential"
The gates *are* the essence; some are still missing and unclear. The move: recover the **discriminator** that detects gates, then discover the rest together.

### The gate discriminator + discovery method
A gate = **intrinsic judgment ∩ asymmetry** (AND). Discovery is a pincer: analytical (decompose a feature, classify each decision) + empirical (watch the seams — every human intervention is an un-formalized gate firing). Discovery is itself gated (AI proposes candidates, human judges) — same shape as the thing it designs. Candidate gates: decomposition, intent/correctness, outcome-set, concern, naming. → observation `…18-48-32Z-tdd-gate-discriminator.md`.

### Settling the discriminator
"Settled" = run blind, it produces the verdicts the human would, across corpus + adversarial cases, zero unreconciled disagreements; then it promotes to a rule. Procedure: four passes (calibrate knowns → specificity on non-gates → reconcile candidates → stress the boundary). Two soft spots: **A** make judgment-bearing *intrinsic* (not capability-relative, which would shrink the gate set as models improve); **B** split affordability out of gate-ness. → observation `…18-55-29Z-settling-the-gate-discriminator.md`.

### Decision + passes 1–2
**Soft-spot A ratified:** judgment-bearing is now intrinsic (*underdetermined by the code and tests; needs intent/taste only the human holds*). **B provisionally adopted** (affordability split out), not yet ratified. The discriminator was rewritten; **both legs are now capability-independent**.
- **Pass 1 (calibrate knowns): green** — efferent call and solubility both pass.
- **Pass 2 (specificity): green** — explaining-variable name, `comment` order, whitespace all rejected.
- **Findings:** AND structure validated (variable naming is judgment-ish but rejected via asymmetry); asymmetry is the sharper specificity blade; the "naming" candidate partly resolves — asymmetry splits interface/contract names (gate-ward) from test-local names (not a gate).
- **Remaining:** pass 3 (reconcile candidates), pass 4 (boundary stress), ratify soft-spot B.

### Meta: auto-record this dialogue
Decided the TDD dialogue is too valuable to record only on request. Established a standing rule to record substantive TDD design dialogue automatically as the session proceeds — into this digest plus discrete artifacts — rather than waiting to be asked. A settings.json hook can't do this (it can't distill dialogue); the rule is the durable mechanism. → rule `…19-03-59Z-auto-record-tdd-dialogue.md`.

### Plain-language statement of the discriminator
Restated the discriminator in plainest terms (added to the gate-discriminator observation as "In plain language"): a gate is where you stop and put the decision to the human; it is a gate only if **(1)** the answer isn't in the code or tests — it takes human taste/intent (*intrinsic*) **and (2)** getting it wrong spreads and locks in (*asymmetric*). Clarified **intrinsic**: the answer isn't present in the artifacts, only in the human's head — anchored to the artifacts, not the model, so it doesn't shrink as models improve (vs. the retired "the AI would guess" phrasing). Examples: naming a local variable → not a gate (derivable + local); the unit's solubility → a gate (unwritten + sets downstream).
*(Process note: this exchange initially went unrecorded; caught and recorded retroactively. Reinforces applying the auto-record rule in the same turn.)*

### Terminology: "subtle" and "load-bearing" replace "intrinsic" and "asymmetric"
The dense terms ("intrinsic", "asymmetric", "capability-independent") read as academic and risk a preachy, Uncle-Bob-ish tone for an engineering audience the work is ultimately meant to reach. Reframed the two legs in plainer, conveyable language, meaning unchanged: **subtle** (vs **crude**) replaces *intrinsic*, drawing on Bellware's subtle/crude-knowledge distinction — subtle = design principles/qualities, invisible but foundational; crude = tools/patterns, visible/derivable. **Load-bearing** replaces *asymmetric* — other work rests on the choice, so a wrong one spreads and sticks. Dropped "capability-independent" as a coined term and said it plainly instead (subtlety is about the design, not the model, so gates don't shrink as models improve). Reference: https://madabout.software/articles/subtle-knowledge-crude-knowledge/. → updated the gate-discriminator observation.

### Naming the concept: converged on "deliberation"; "load-bearing" ratified
Confirmed **load-bearing** for the second leg. Searched for a more soluble replacement for **discriminator** (correct, but academic and carrying ML/GAN baggage). Walked candidates: *inflection* (turning-point geometry; math + management-speak baggage), *reflection* (right essence but collides with the Reflection programming concept), *consideration/pause/juncture*, and landed on **deliberation** — clean (no programming collision, not buzzwordy), and it sharpens the framework through its double sense: *deliberate* = carefully weighed AND intentional, the opposite of the AI's averaging. Organizing pair: **the AI generates; the human deliberates.** Consequences: "discriminator" retires (the test becomes "does this call for deliberation?"); subtle + load-bearing become the *reasons* a point calls for deliberation. Resolved: **gate stays** (the mechanism — where the loop stops). **hinge** kept as the decision the design turns on (subtle + load-bearing), which also relieves "gate" of its old double-duty (decision vs. stop).

### Settled lexicon
- **hinge** — the decision the design turns on; subtle + load-bearing. The object.
- **gate** — where the loop stops to hand a hinge to the human. The mechanism.
- **deliberation** — the human's act at the gate. (The AI generates; the human deliberates.)
- **subtle** / **crude** and **load-bearing** — the two marks that make a decision a hinge.
- **"discriminator" retires** — the test it named is just "is this a hinge?", and the answer routes to a gate.

One-liner: *the AI generates straight through, and gates at the hinges — the subtle, load-bearing decisions — for the human to deliberate.*

Propagated (2026-06-20): rewrote both observations and renamed them → `…-tdd-hinge-marks-and-discovery.md` and `…-settling-the-hinge-marks.md`; reworked the human-in-the-loop rule and the design doc around hinge / gate / deliberation; "discriminator" retired.

### Two more terms: "mechanical" adopted; "interjection" considered and declined
- **Mechanical / mechanics** replaces "non-hinge" — a positive, non-negated term that scales to bulk generated code, with no programming collision. (Rejected for overloading: given→BDD, routine→subroutine, default, fixture.) Hinges take deliberation; everything else is mechanical.
- **Interjection** considered for the human's act (it conveys the interrupt) but **declined** in favor of keeping **deliberation**: the interrupt is already the **gate**'s job (interjection would duplicate it); "interjection" grammatically means a brief exclamation (underselling considered judgment); and it loses deliberation's double sense (carefully weighed + intentional — the opposite of the AI's averaging).

### Vocabulary frozen; glossary promoted to a rule
Froze **mechanical** (dropped the "for now"). Promoted the canonical glossary from an observation to a binding **terminology rule**: `agent/rules/2026-06-20T21-12-34Z-tdd-lexicon.md` (alongside the efferent-not-caller rule). The observation `…19-46-18Z-tdd-lexicon.md` is kept as a tombstone pointing to the rule. The *framework* (which hinges exist, whether the two marks are final) remains under discovery; only the vocabulary is frozen.

---

## 2026-06-26 — The prior question: *whether* to interject

### The "whether" is upstream of the "where"
Raised: the whole hinge/gate apparatus answers *where* the human interjects and *how*, but presupposes *that* the human interjects — and it remains possible to let the AI proceed **entirely unscrutinized** (set the call, judge solubility, resolve hinges, generate straight through, no gate). So the live question is *whether* to interject, upstream of *where*.

### Resolution: it's a second dial, not the hinge marks
The hinge marks (subtle + load-bearing) locate **leverage, not necessity** — where judgment pays off *given* the human is in the loop, not that the human must be. This splits the framework into two dials, rightly separated: **(1) hinge-ness** — subtle ∧ load-bearing, a fact about the *design*, capability-independent (soft-spot A's whole point); says *where the risk is*. **(2) gate-policy** — given a hinge, do we actually stop? Capability- and cost-**dependent**; says *whether to pay to cover it*. Capability was pushed out of dial 1 deliberately; it re-enters at dial 2, legitimately. The whether-question is dial 2, and it can be turned to "don't interject."

### The tension, the escape hatch, the floor
- **Tension:** "subtle" = *absent from artifacts, only in the human*. At a real hinge, unscrutinized = the AI can only **average**, which the thesis forbids — an argument to interject *at hinges specifically*, threatening to collapse "whether" back into "where."
- **Escape hatch (already in the thesis):** "condition on this project's high-solubility code" pre-loads the subtle knowledge into the AI; to that degree the gate is overhead. **Better conditioning → fewer gates.** "Unscrutinized" = the framework with gate-policy dialed to *trust*, valid to the degree conditioning absorbed the subtlety. Terminal aim: drive gates toward zero by transferring subtle knowledge into conditioning.
- **Floor (recursion):** "whether to interject" is itself the most load-bearing hinge, so it must be deliberated at least once by the human to set the policy. The human can delegate the loop but not the decision to delegate without first making it. One irreducible interjection.

### Consequence for soft-spot B
This reframes affordability: it is not a downstream *filter* on hinge-ness — it **is** the gate-policy axis (dial 2). → observation `agent/observations/2026-06-26T16-40-50Z-whether-to-interject.md`.

### The inquiry reframed: what is the human's *role*?
Stepped back: the hinge/gate/deliberation machinery is **instrumentation** (where/when the human acts); it never names *what the human is for*. We had mapped the controls without naming the role. The real object of discovery is **the human's role in AI TDD** — and the hinge framework is a hypothesis about it, not the role itself.

**Proposal: the human is the source and guarantor of the standard of "good."** Every thread converges on one ingredient only the human supplies — *subtle* = absent from artifacts/only in the person; "don't regress to the mean" needs an external referent for above-the-mean; solubility can't be certified by the green bar. The AI can generate but cannot *originate* the standard (it's subtle by definition), and its native move without the standard is to average = definitionally not-good. So the machinery is recast: hinges/gates = the points where the standard must be injected; deliberation = one mode of injecting it; cradle + solubility = the human imposing the shape standard and the quality standard.

**The role is a portfolio, split essential vs transitional:** *Originator* (holds what "good" means — essential, can't be delegated, it's what's delegated *from*) and *Boundary-setter* (what counts as a hinge; gate-policy — essential; the irreducible floor) vs *Decider* (in-loop hinge resolution — transitional) and *Judge/ratifier* (validates against the standard — transitional, slower). *Conditioner* (transfers the standard into the AI ahead of the loop) is **the lever** that converts transitional load into the AI. Ties to the two dials: gate-policy is transitional, conditioning moves it → AI TDD is a **migration** of the human from per-instance deciding toward originating + conditioning + boundary-setting; the human becomes the *author of the standard the loop runs on*.

**Sharpened research question:** no longer "where are the hinges" but **how the standard transfers from human into AI conditioning, and what residue never transfers** — the residue *is* the permanent human role (candidates: originator, boundary-setter). → observation `agent/observations/2026-06-26T16-54-59Z-the-humans-role.md`.

### Sharpening: the human is the above-the-mean element
"Don't regress to the mean" requires an external referent for *above* the mean — with teeth. The Human/AI configuration must contain an element above average, above the AI's natural inclination to average; **the human is that element.** The AI's gravity is "good enough" (the mean); the human is inclined to "better" — and *better than the AI has encountered*. Irreducible because averaging only reproduces the *encountered* distribution; "better than encountered" is outside it, so it can't be recovered from corpus/artifacts — only **introduced**, by the human. So the human's role isn't *access to* a standard but *being the super-mean element*; this is the mechanism beneath **Originator** and why delegating it collapses the configuration to the mean. → folded into `2026-06-26T16-54-59Z-the-humans-role.md`.
