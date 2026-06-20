# Human-in-the-Loop TDD with AI — Design

## Premise

Two ideas from the project's TDD rules drive this whole design:

1. **Design judgment stays with the human.** Knowing in detail what good, soluble design looks like is the human's contribution and does not delegate.
2. **Red-green-refactor is ceremony.** It only ever existed to insert a human's attention into the loop. A test written before its implementation is trivially going to fail; that failure teaches nothing.

Put together, they imply a precise design move: **don't remove the human, and don't keep the ceremony — relocate the human's attention to the decisions the design turns on, and let the AI generate straight through everywhere else.**

Those decisions are the **hinges**. The loop **gates** at the hinges so the human can **deliberate** them. The spine of the whole design is one pair: **the AI generates; the human deliberates.**

## Where design judgment lives — the hinges

A hinge is a decision that is **subtle** (it takes design judgment that isn't written in the code or tests) and **load-bearing** (other work rests on it, so a wrong choice spreads and sticks). The full account is in the hinge-marks observation; more hinges are still being discovered. Two are known:

- **The cradle — the efferent shape of the call.** How the unit is actuated *is* its interface. The highest-leverage hinge, and it is one line.
- **Solubility — the result.** Whether the unit has dissolved into its use: usable, transparent, as simple as it should be and no simpler.

Everything else — test scaffolding, the implementation body, running the test — is generation or verification, not a hinge. The human does not belong there.

## Division of labor

| Concern | Owner |
| --- | --- |
| The efferent design — what the call looks like | **Human** (AI may propose; human edits/approves) |
| The solubility verdict on the result | **Human** |
| Test scaffolding from the efferent intent | **AI** |
| Implementation that satisfies the cradle | **AI** |
| Running the test to confirm | **AI** |

The AI generates *within the cradle the human sets*. The cradle holds the implementation in proper position without gripping it rigid — it supports generation within the dictates of the efferent view while leaving it free to move inside those bounds.

## The loop

### 1. Human sets the cradle — the actuation

The call is the contract. Two modes:

- The human writes the actuation line directly (maximum control), or
- The AI proposes the actuation and the human edits or approves it.

Default to the second, with one firm rule: **the human holds edit and veto power specifically on the call**, even when waving everything else through. When the AI is uncertain about the efferent shape, it **asks rather than averaging toward common code** — guessing is most expensive precisely here.

### 2. AI writes turn one — the test file only

Following the first-turn and test-structure rules: outer `context` for the feature, the actuation bound to an explaining variable, an inner `context` for the first outcome, one `test` block, one assertion. No implementation.

**Human deliberates (fast):** read *the call*, not the test mechanics. Does this read as soluble use? If the call is awkward, fix the cradle now — it is cheapest before any implementation exists.

### 3. AI generates the implementation inside the cradle, straight through

Toward solubility: minimal necessary complexity, conditioned on this project's high-solubility code rather than the average of code in general. The AI runs the test to **confirm** — verification that the implementation satisfies the cradle, not the "green" half of a ceremony.

**No deliberation on the red/green bar.**

**Human deliberates (the real one):** read the resulting unit and judge solubility. If the implementation only works by forcing an awkward call, that surfaces *here, at the interface* — and the fix goes to the cradle, not the implementation.

### 4. Loop by outcome

The human (or the AI proposing, the human approving) names the next distinct outcome of the **same single actuation**. The AI adds an inner `context` and extends the implementation just enough to satisfy it. The human deliberates solubility again. Repeat.

### 5. Exit on solubility, not coverage

The stopping criterion is that the unit has dissolved into its use — not an assertion count, not a coverage percentage.

## Principles that keep it honest

- **The human deliberates at the hinges — never at mechanical pass/fail.** If you are asking the human to confirm a red bar, you have reintroduced the ceremony.
- **The actuation is the contract.** Give the human direct control of that one line; let the AI fill everything else.
- **Small turns keep the cradle legible.** Human judgment is sharpest when applied to one actuation and one outcome, not a finished file.
- **Catch solubility regression at the interface.** The AI's failure mode is averaging toward poorly-designed code; it announces itself first as an awkward *call*. Gate on that hinge and you catch it early.
- **When the efferent shape is uncertain, the AI asks.** Design judgment is the human's; the AI requests it rather than inventing it.

## Net effect

The human spends attention almost entirely on the **hinges** — the call and solubility, two small, high-leverage surfaces — and never on test mechanics or pass/fail theater. The AI generates inside the cradle without ceremony. This is the human-in-the-loop placement the cradle concept implies.

## Related

- TDD is a design tool, not a testing ritual (the cradle).
- TDD first turn: start a feature with a test file.
- Test structure: actuate once at the top, assert each outcome in its own nested context.
- In TDD, use the term "efferent", never "caller".
- Human-in-the-loop TDD: deliberate the hinges, never the pass/fail bar.
- The marks of a hinge, and how to discover the missing ones (observation).
