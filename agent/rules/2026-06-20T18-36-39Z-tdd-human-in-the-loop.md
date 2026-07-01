# Human-in-the-loop TDD: deliberate the hinges (the efferent call and solubility), never the pass/fail bar

In human-in-the-loop TDD with AI, place the human's attention only where design judgment lives — at the **hinges**. A hinge is a decision the design turns on (subtle and load-bearing; see the hinge-marks observation). Two hinges are known: **setting the cradle** (the efferent shape of the call) and **judging solubility** (the result). The loop **gates** at the hinges so the human can **deliberate** them; everything between is generation the AI does straight through. Never gate the human on a red or green bar — that is the ceremony, and the ceremony only ever existed to insert human attention that now belongs at the hinges.

The spine of the whole thing is one pair: **the AI generates; the human deliberates.**

Division of labor: the human owns the efferent design — what the call looks like — and the solubility verdict on what comes back; the AI owns generating within the cradle, both the test scaffolding and the implementation, steered toward solubility.

The loop, by turn:

1. **Human sets the cradle — the actuation.** The call is the contract and the highest-leverage hinge. The AI may propose the actuation, but the human holds edit and veto power *specifically on the call*. When the efferent shape is uncertain, the AI asks rather than averaging toward common code.
2. **AI writes turn one — the test file only.** The human deliberates the *call*, not the test mechanics — does it read as soluble use? Fix the cradle now if not; it is cheapest before any implementation exists.
3. **AI generates the implementation inside the cradle, straight through**, and runs the test to *confirm* (verification, not the green half of a ceremony). The human deliberates the unit's solubility. If it only works by forcing an awkward call, the fix goes to the cradle, not the implementation.
4. **Loop by outcome.** Name the next distinct outcome of the same single actuation; the AI adds an inner `context` and extends the implementation just enough; the human deliberates solubility again.
5. **Exit on solubility, not coverage.** The stopping criterion is that the unit has dissolved into its use, not an assertion count.

**Why:** Design judgment stays with the human (see the TDD-as-design-tool rule), and the only places it applies are the hinges — here, the efferent call and the resulting solubility. Concentrating human attention there — and removing it from pass/fail theater and test mechanics — spends the human's judgment where it has leverage and lets the AI generate inside the cradle without ceremony. The AI's failure mode is regressing toward the average of poorly-designed code, which announces itself first as an awkward call; gating on that hinge catches it at the interface.

**How to apply:** Run the loop above. Keep turns small (one actuation, one outcome) so the cradle stays legible while the human deliberates. Hand the human the call to edit or approve; let the AI fill everything else. Do not ask the human to confirm a failing or passing test. Stop when solubility is satisfied. The hinges beyond these two are still being discovered — see `agent/observations/2026-06-20T18-48-32Z-tdd-hinge-marks-and-discovery.md`. The fuller procedural treatment lives in `agent/design/2026-06-20T18-50-55Z-human-in-the-loop-tdd-design.md`. Related: the TDD-as-design-tool, first-turn, test-structure, and efferent-not-caller rules.
