# Observation: gate forecasting — the AI predicts and announces the gates ahead of acting

**Status:** Speculation, early. The user's words: "Predicting the gates and then communicating them to the human could be a key to the TDD AI process maybe. Just a speculation at this point." Recorded as a low-maturity working hypothesis, not adopted. Would promote toward a rule only after being tested on real runs (the forecast's misses and false alarms in hinge-prediction; whether it helps or exerts mean-bias). Companion to `2026-06-26T16-40-50Z-whether-to-interject.md` (the two dials), `2026-06-26T16-54-59Z-the-humans-role.md` (the modes), and `2026-06-20T18-48-32Z-tdd-hinge-marks-and-discovery.md` (discovery method).

**Terminology (2026-06-26):** plain terms replace two imported jargon words. **mean-bias** (not "anchoring") — the forecast biasing the human toward the AI's mean-drawn answer, dragging the above-the-mean element down toward the mean; names the direction (the harm) and composes with the existing "mean" vocabulary, and isolates the *harmful* kind of bias from benign bias toward an above-the-mean answer. **miss / false alarm** (not "recall / precision") — a **miss** is failing to flag a real hinge (expensive, invisible); a **false alarm** is flagging a mechanical decision (cheap, even useful). "Lean toward flagging" replaces "recall-biased."

## The hypothesis

Before acting, the AI **forecasts the gates** for the task — predicts which upcoming decisions are hinges (subtle ∧ load-bearing) — and **communicates them to the human**. The gate becomes *signaled by the AI ahead of time* rather than *tripped by the human after the fact*. Tentative name: **gate forecasting**.

## Why it might be key

1. **Flips discovery from reactive to proactive.** The prior empirical method was "watch the seams — every human interjection is a hinge announcing itself," i.e. after the fact (the human catches the AI at the seam). Forecasting surfaces the seam *before* the AI acts; the hinge announces itself through the AI, not through the human's catch.
2. **Counters unscrutinized proceeding directly.** The core risk is the AI silently averaging through a subtle, load-bearing call. A forecast converts silent averaging into an explicit handoff ("the next decision is a hinge — here is the call I am about to make"), moving the burden of vigilance off the human and onto the AI.
3. **The boundary-setter recursion, run inline, AI-first.** "Deciding what counts as a hinge is itself a hinge." Forecasting is the AI proposing candidate hinges and the human ratifying which are real — the discovery loop's own shape, executed every feature.
4. **A conditioning-transfer channel.** Each forecast the human ratifies confirms the AI has internalized the hinge-map; each override (a missed gate, or a false one) is a calibration signal. So forecasting is *how the boundary-setter role partly migrates to the AI over time* — the AI gradually owns "where are the hinges," leaving the human "is it resolved well." The migration made operational.
5. **Economizes the scarce resource.** The human is the above-the-mean element — expensive. A gate-forecast is a map of where to spend deliberation, so the human stops scanning everything. This is the practical form of the gate-policy dial — what makes the gates affordable.

## Where it could break

- **Structural blind spot.** The AI can only forecast hinges it can *see*; but a hinge is *absent from the artifacts* (subtle) — the very property that can make it invisible to the AI. Forecasting is weakest exactly where it matters most. It **supplements** catch-the-seam vigilance; it cannot replace it.
- **False alarms / gate inflation.** Over-forecasting (flagging mechanical decisions as gates) re-imposes the attention cost it was meant to save and trains the human to rubber-stamp. Needs calibration: few misses *and* few false alarms.
- **Mean-bias.** "Here is the call I am about to make, please ratify" pulls the human toward the AI's mean-drawn answer (assent) — degrading the gate into theater and contaminating the ratify-vs-correct measurement. Mitigation: present the decision and live alternatives, not a fait accompli to bless.

## Net read

Most powerful as a **supplement that focuses attention** and a **calibration channel for transferring the hinge-map** — not a replacement for human vigilance.

## Developing the form of a good forecast (2026-06-26, theorizing)

Pushing on the three failure modes yields a shape for a *well-formed* forecast.

### Mean-bias: the forecast drags the above-the-mean element toward the mean
A naive forecast ("here's the call I'm about to make — ratify?") makes the human evaluate *is X acceptable?* instead of *what is best?* Evaluating a proposal is lower-energy than originating the best, so the human slides from **originator** mode into **judge** mode. Judge mode is downstream of the AI's proposal — it can only catch errors in what was offered, never supply what was never offered — and the proposal is drawn from the mean. So the forecast exerts **mean-bias**: it pulls the above-the-mean element *down toward the AI's mean* and demotes the human from the one irreducible mode (originator) to a transitional one (judge). **The mechanism meant to prevent averaging induces averaging — in the human.** Mean-bias attacks the purpose, not just a gate. (When conditioning has lifted the AI's proposal *above* the mean, biasing the human toward it is not mean-bias — see fault-line "when is bias correct?")
→ **First law: a forecast must provoke origination, not exert mean-bias.**

### Calibration: asymmetric costs → lean toward flagging, which then self-destructs
A **false alarm** (flagging a mechanical decision) is *cheap and instructive* — "that's mechanical, proceed" is itself a labeled calibration signal. A **miss** (failing to flag a real hinge) is *expensive and invisible* — silent averaging through a load-bearing call. The asymmetry ⇒ lean toward flagging (when unsure, flag). But leaning too hard collides with false alarms: over-flagging habituates the human into rubber-stamping, which silently restores the misses.

### Resolution: forecast the *partition*, not the gates
Don't forecast "here are the hinges." Forecast the **whole decision partition**, tiered by confidence: **tier 1 gates** (high-confidence hinges — deliberate), **tier 2 suspected** (might be — glance), **tier 3 mechanical** (about to decide silently — audit only if something looks off). Key insight: **the dangerous miss lives in the proceed pile** — a hinge the AI can't see is one it filed under "mechanical." Exposing tier 3 (the inverse of forecasting gates) is where misses are caught: the AI can't know which silent decision is secretly a hinge, but the human scanning the list might. Tiering keeps the high-attention channel (tier 1) clean, so leaning toward flagging doesn't flood it. Bonus: a partition is about *which decisions need you*, not *what the answers are*, so it engages the human in **boundary-setting** (the recursion) rather than ratifying answers — originator/boundary-setter, not judge. So the partition also satisfies the first law.
→ **Second law: expose the proceed-pile, or misses pass silently.**

### The blind spot is bounded, not solved
The AI still cannot see the hinge it cannot see. The partition does not *find* the hidden hinge; it converts an **unknown unknown** (a hinge nobody noticed) into a **known region to audit** (somewhere in tier 3). The most a blind instrument can do: not see, but *point at where the unseen lives*. Catch-the-seam vigilance stays irreducible; the forecast narrows where it must look.

### Meta-payoff: the forecast is the training loop
Every **re-filing** by the human (tier 3 → tier 1 "you should have stopped"; tier 1 → tier 3 "not a hinge") is a *labeled example for the hinge-map*. So forecasting the partition is the concrete instrument by which **boundary-setting migrates to the AI**: re-filings become new rules/exemplars (conditioner output). The forecast generates its own training signal — the migration made mechanical and observable.

### The catch: it doesn't scale → step-local
An exhaustive partition is tiny for `name` but explodes for a large feature, and a giant partition reintroduces the miss problem at the meta-level (the human can't audit hundreds of lines either). So the partition must be **step-local**: exhaustive only at the altitude of the current cradle (this method, this turn), not the whole feature.
→ **Third law: keep it step-local, or it's unaffordable.**

### Compressed
A well-formed forecast is **a step-local, confidence-tiered decision partition that leans toward flagging, presented to provoke origination rather than exert mean-bias — and its re-filings are the conditioning signal that migrates the hinge-map to the AI.** Three laws: provoke origination (no mean-bias); expose the proceed-pile; keep it step-local. (Still speculation — untested.)

## How to test it

A crude version already ran: the Name-feature proposal forecast GATE 1/GATE 2 and the candidate seams up front. Test on that run: did announcing the gates help the human spend attention where it mattered, or did it exert mean-bias toward ratifying? Track, per gate, whether forecasting changed the **ratify-vs-correct** outcome. Over several features, measure the forecast's **misses** and **false alarms** against where interjections actually fired.
