# Present every prompt to the developer through the AskUserQuestion selection UI

Every time you prompt the developer to make a choice, a decision, or an answer —
not only hinge choices, but **any** prompt — present it through the
**AskUserQuestion** selection UI, never as a prose question. Each genuine option
is an option in the UI; the UI's built-in free-text **"Other"** is the escape (do
not add your own "chat about this" option).

**Why:** the selection UI makes every handoff legible and uniform, and already
supplies the free-text origination escape. Routing *all* prompts through it — not
only hinge gates — keeps the developer's decision points consistent and easy to
act on, and stops a choice from being buried inside prose.

**How to apply:** whenever you would ask the developer to decide or answer — a
hinge choice, a "which approach," a confirmation to proceed / commit, a
clarification between interpretations — use AskUserQuestion, one option per
genuine choice (two-option floor; surface the real underlying decision rather than
padding). Reserve plain prose for statements, reports, and explanations that are
**not** asking the developer to choose. This generalizes the hinge-choices rule
(which required the UI for hinge gates) to every prompt. Related: the
hinge-choices-via-AskUserQuestion rule and the actuation-gate options-or-chat rule.
