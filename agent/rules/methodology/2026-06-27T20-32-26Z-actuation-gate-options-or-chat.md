# The actuation gate: offer candidate actuations as options; the human chooses one or opens a chat

At the actuation gate — the first gate, where the cradle is set — the AI does not commit a single actuation and proceed. It presents the human a small set of **candidate actuations** as options to choose among. The human then either:

- **chooses** the option that reads as the more soluble use, or
- selects **"chat about this"**, which opens into either the human **dictating** the actuation outright, or a **chat** to work out what the call should be.

This is how the highest-leverage hinge — the efferent shape of the call — is handed over for deliberation: by comparing concrete alternatives, with an always-open escape into dictation or dialogue when the right shape isn't among the options.

The form is deliberate, and it is the operationalization of two results already reached in the gate-forecasting work:

- **Present alternatives, not a fait accompli (Law 1 — provoke origination, not mean-bias).** A single proposed call ("here's my actuation — approve?") puts the human in judge mode, downstream of the AI's mean-drawn answer, exerting mean-bias and lowering the human toward the average. Offering several genuine options keeps the human originating — comparing real candidate shapes for solubility — rather than ratifying.
- **The escape is mandatory (limit A — options the AI can't produce).** The option set is the AI's own, drawn from the average; the best actuation is often one only the human can produce, and showing a closed list tempts the human to pick from it instead of producing their own. "Chat about this" / dictate is the origination escape — the human is never boxed into the AI's option set.

**Why:** The actuation is the cradle and the highest-leverage hinge (human-in-the-loop rule, step 1: "the AI may propose the actuation… asks rather than averaging"). Concrete alternatives make the deliberation tractable and provoke origination; the mandatory chat/dictate escape keeps the human above the AI's mean when the right call isn't on the list. Together they let the AI carry the proposing work without pulling the human's judgment down to the mean.

**How to apply:** At the first gate, generate a few genuinely distinct candidate actuations — different efferent shapes, not cosmetic variants — each presented as it would read at the use site. Offer them as options together with a "chat about this" choice. If the human chooses one, adopt it as the cradle. If the human chooses "chat about this," take their dictated actuation or enter a dialogue, and settle the call before writing the test file. Do not proceed to the test body until the actuation is settled. **When a hinge has no genuinely distinct candidates, do not manufacture them** — prompt the human to *accept* the single proposal instead, always keeping the mandatory "chat about this" escape. This options-or-accept-with-escape mechanism applies at **every** hinge of the cycle (actuation, assertion, controls, implementation), not only the actuation — see the hinge-cycle rule (`agent/rules/methodology/2026-06-28T15-04-47Z-hinge-cycle.md`). Related: the hinge-cycle, human-in-the-loop, first-turn, TDD-as-design-tool, and lexicon rules, and the gate-forecasting observation (Law 1; limit A).
