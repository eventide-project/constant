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
