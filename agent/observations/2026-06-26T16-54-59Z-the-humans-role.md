# Observation: the human's role in AI TDD — source and guarantor of the standard of "good"

**Status:** Working hypothesis, under active discovery. Not a binding rule. This reframes the central inquiry: the hinge/gate/deliberation machinery is *instrumentation* (where and when the human acts); it does not name *what the human is for*. This observation proposes the role the machinery serves. Companion to `2026-06-26T16-40-50Z-whether-to-interject.md` (the two dials), `2026-06-20T18-48-32Z-tdd-hinge-marks-and-discovery.md` (the marks), and the human-in-the-loop rule.

## The reframe

We had been cataloguing hinges and gate-policy — mapping the controls — without naming the role they serve. The question is not "where are the hinges" but **"what is the human's role in AI TDD?"** The hinge framework is one *hypothesis about the role*, not the role itself.

## The proposal

The human's role is to be **the source and guarantor of the standard of "good."**

Every thread converges on one missing ingredient that only the human supplies:
- **subtle** is defined as *absent from the artifacts, present only in the person*;
- **"don't regress to the mean"** requires an external referent for what is above the mean;
- **solubility** is a quality the green bar cannot certify.

In each case the standard of good is not in the code, the tests, or the model — it **originates in the human**. The AI can generate but cannot *originate* the standard: the standard is subtle (by definition not in the artifacts), and the AI's only native move in its absence is to average — which is definitionally not-good. That is the whole reason a human is in the loop.

This makes the machinery instrumentation, not the role:
- **hinges/gates** = the points where the standard must be injected (and nowhere else);
- **deliberation** = one mode of injecting it;
- the **cradle** and **solubility** (the two known hinges) = the human imposing the *shape* standard and the *quality* standard.

## Sharpening: the human is the above-the-mean element of the configuration

"Don't regress to the mean" requires an external referent for what is *above* the mean — and that requirement has teeth. Simplified: **the Human/AI configuration must contain an element that is above average, above the AI's natural inclination toward averaging. The human is that element.**

- The AI's native gravity is toward the mean — it is inclined to **"good enough."**
- The human is inclined to **"better"** — and crucially, *better than the AI has encountered.*
- This is why the human is irreducible: averaging can only ever reproduce the *encountered* distribution. "Better than encountered" is by definition outside that distribution, so it cannot be recovered from the corpus or the artifacts — only **introduced**. The human introduces it.

So the human's role is not merely *access to* a standard; it is *being the super-mean element itself*. The human takes the AI above its inherent pull toward average. This is the mechanism beneath the **Originator** mode below — what makes it essential and undelegatable: delegating it to the AI would collapse the configuration back to the mean.

## The role is exercised through several modes

The standard is supplied through several **modes** of the one role. ("Role" is reserved for the whole position; the items are *modes of the role*, not separate roles, so no collective noun like "portfolio of roles" is needed. The item word — **mode** vs **capacity** — and the role-level wording are not yet frozen.) The load-bearing distinction is **essential** (never goes to zero) vs. **transitional** (shrinks as conditioning improves):

| Mode | What the human does | Essential / transitional |
|---|---|---|
| **Originator** | Holds what "good/soluble" means here | **Essential** — the thing delegated *from*; cannot itself be delegated |
| **Boundary-setter** | Decides what counts as a hinge; sets gate-policy (whether to interject) | **Essential** — the standard *about* the standard; the irreducible floor from the whether-to-interject exchange |
| **Conditioner** | Transfers the standard into the AI ahead of the loop (rules, exemplars, "efferent in, efferent out") | The **lever** — converts transitional load into the AI |
| **Decider** | Resolves a hinge in-loop, where conditioning has not reached | **Transitional** — shrinks as conditioning succeeds |
| **Judge / ratifier** | Validates the AI's call against the standard (solubility verdict; "is it settled") | **Transitional**, slower — drift-catching outlives deciding |

Ties to the two-dials finding: **gate-policy (dial 2) is transitional; conditioning is the lever that moves it.** So AI TDD describes a **migration**: the human's role moves from per-instance *deciding* toward *originating + conditioning + boundary-setting* — less a participant in each loop, more the **author of the standard the loop runs on**.

## Reconciliation: the role is the set of its modes vs. the single-purpose thesis

Two claims appear to compete: that the human is the *source and guarantor of the standard of "good"* (a single **purpose**), and that the role is exercised through several modes (irreducibly plural — the role *is* the set of its modes, no residue once the modes are named). They are not rivals; they sit at two levels:

- **The purpose answers "why is a human here at all?"** — because the configuration needs an element above the mean, and only the human can be it (the above-the-mean sharpening). This is carried by the **Originator** mode and it is irreducible: the single reason the collaboration needs a human.
- **The modes answer "what does the human actually do all day?"** — originating the standard gets *operationalized* across a real collaboration as a managed allocation across modes (originator, boundary-setter, conditioner, decider, judge). There is no single verb for the day-to-day; it is the mix.

So: **originating the standard is the irreducible core; the set of modes is how that core is operationalized.** The purpose does not reduce the modes to one row, and the modes do not dissolve the purpose into "just a mix" — the set of modes is *the operational form of the one purpose*. The other modes (boundary-setting, conditioning, deciding, judging) are all in service of getting the above-the-mean standard into the work: conditioning transfers it ahead of time, deciding injects it in-loop, judging defends it against drift, boundary-setting decides where it must enter. Each is the purpose acting through a different mechanism.

This also explains the "moving part": as conditioning succeeds, weight shifts out of the transitional modes into the AI, concentrating the human's allocation on the purpose itself (originating) and the standard-about-the-standard (boundary-setting). Same purpose, migrating allocation.

## The open question, sharpened

If the role is "source and guarantor of the standard," the research question is no longer "where are the hinges" but: **how does the standard transfer from the human into the AI's conditioning, and what is the residue that never transfers?** The residue *is* the permanent human role. Candidates for the residue: the two essential modes (**originator**, **boundary-setter**). Everything else is conditioning-in-progress.
