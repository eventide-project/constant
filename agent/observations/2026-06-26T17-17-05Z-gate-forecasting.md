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

### Mean-bias (the mechanism) vs lowering (its effect at a hinge) — resolved

**Resolved (2026-06-26):** keep **mean-bias** as the name for the *mechanism* — the forecast pulling the human toward the AI's mean-drawn answer — and use **lowering** for the specific *effect* mean-bias has *at a hinge*. Mean-bias is the cause; the lowering is what it does at a gate.

**Why the distinction is needed:** "mean-bias" names a *direction* (toward the mean), not a *harm*. Bias toward the mean is a **lowering** only if you start *above* the mean; for a *below-the-mean* design the same pull is a *raising* — an improvement. So the bare direction-name would over-claim badness, smuggling in the premise "the human is above the mean."

**The rescue — scope it to hinges.** Law 1 governs only how a **gate** is presented, i.e. a hinge. On a hinge the human is above the mean *by definition*: a hinge is *subtle* (answer absent from the artifacts), so the AI can only average — its proposal is a mean-draw that cannot contain the subtle knowledge, and the human, holding it, can do better. So at a hinge, bias toward the AI's proposal is *always* a lowering. The below-the-mean case can only occur on a **mechanical** decision (human has no subtle edge; the AI's mean-level answer is as good or better) — but there is no gate there, so Law 1 never applies. The counterexample is real but lives outside the gate.

| | human vs AI on this decision | bias toward AI's answer | gate? |
|---|---|---|---|
| **Hinge** | human above (subtle edge) | **lowering** — harmful | yes — Law 1 applies |
| **Mechanical** | human at/below | raising or neutral — fine | no |

So at a gate, mean-bias necessarily produces a **lowering**: it pulls the human to produce *worse than their unbiased best*. "Toward the mean" is just what lowering looks like when you are above the mean — which, at a hinge, you always are. Law 1 stays *provoke origination, not mean-bias*; the harm it prevents is the lowering. (Outside a gate — on mechanical decisions — mean-bias causes no lowering, and there is no gate there anyway, so Law 1 never applies.)

### Mean-bias: the forecast drags the above-the-mean element toward the mean
A naive forecast ("here's the call I'm about to make — ratify?") makes the human evaluate *is X acceptable?* instead of *what is best?* Evaluating a proposal is lower-energy than originating the best, so the human slides from **originator** mode into **judge** mode. Judge mode is downstream of the AI's proposal — it can only catch errors in what was offered, never supply what was never offered — and the proposal is drawn from the mean. So the forecast exerts **mean-bias**: it pulls the above-the-mean element *down toward the AI's mean* and demotes the human from the one irreducible mode (originator) to a transitional one (judge). This effect — the human producing worse than their unbiased best — is the **lowering**. **The mechanism meant to prevent averaging induces averaging — in the human.** Mean-bias attacks the purpose, not just a gate. (When conditioning has lifted the AI's proposal *above* the mean, biasing the human toward it is not mean-bias — see fault-line "when is bias correct?")
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

## Open questions (two fault-lines on Law 1)

Both are limits on **Law 1** (*provoke origination, not mean-bias*): one attacks its mitigation, one its applicability.

### Fault-line A — options the AI can't produce
Law 1's mitigation for mean-bias was "don't hand the person one answer to ratify; show the options instead." But the list of options is the AI's own, drawn from the average of what it has seen, and two problems follow.

First, the best option may not be on the list. The full picture is a **three-rung ladder**:

1. **Reached** — the AI reached it (produced and surfaced it); it's on the list.
2. **Missed** — the AI could reach it but didn't this pass; more tries, or asking from different angles, surface it. *Fixable.*
3. **Unreachable** — only the person can produce it; the AI never reaches it however much it improves. (Same thing that makes a hinge subtle: the answer isn't in the artifacts, so averaging can't get there.) *Not fixable.*

It looks like a 2×2 — reachable / not × surfaced / not — but the fourth cell is **impossible**: being reached presupposes being reachable (you can't surface what you can't produce), so *unreachable options are always off the list*. That collapses the grid to these three rungs. Fault-line A lives in rungs **2 and 3** — the options absent from the list.

Second — and worse — **showing a list makes the person pick from it instead of producing their own.** A list invites selection; a blank start invites origination. So presenting options suppresses the person's own generation, exactly when the option that mattered was an unreachable one (which only the person could have produced). That is mean-bias one level up, and a Law-1 violation at the level of the option list.

**Missed is fixable; unreachable isn't.**
- *Missed (rung 2):* a single list is one draw from the average. Run several independent lists, from different angles, and coverage rises. This shrinks the missed gap; it does nothing for the unreachable rung.
- *Unreachable (rung 3):* the AI can't produce these — but you can stop the list from suppressing the person. Have the person produce their answer **first, before seeing the AI's list**; show the list afterward only as a cross-check ("did either of us have one the other didn't?"). The person's answer is never bounded by the list, because it comes first. This is the same "answer first, compare second" structure as the conditioning-confidence check — so the defense against unreachable options and the confidence measure are one and the same.

**What the AI can tell about its own blindness.** It can't tell *which* options it failed to produce, but it can tell when its list is *all of one kind* — every option a variation on one approach. That sameness is a sign it's stuck and probably missing whole categories, and a cue to push the person to produce fresh. (Catches the stuck-in-one-approach case, not the case where the options are varied but all still below what the person would produce.)

**Two leftover pulls.** (1) Even as a cross-check, the AI's list tempts the person to defer to it; keep the person's first answer privileged and present the list as "more candidates, not the full set." (2) Producing first is costly, so reserve it for decisions that matter — same dial as fault-line B.

**Where it lands.** What survives is the *unreachable options*, and that is not a new thing: **the option the AI can't produce, the decision it can't recognize as needing the person, and the answer it can't predict are the same single thing seen three ways — what only the person can produce.** Fault-line A doesn't get closed; it gets **handed to the person**, which is what you do with anything the AI can't produce. It stays with the person permanently, because it's about options the AI can never produce — not about the quality of its average — so improving the AI doesn't touch it.

### Fault-line B — the laws are stage-dependent on conditioning
Law 1 forbids mean-bias *because the AI's proposal is mean-drawn* — a justification with an expiry date. As conditioning matures, the AI's proposal becomes above-the-mean (it embodies the transferred standard), so biasing the human toward it is no longer a lowering, while the *cost* of provoking origination from scratch grows (it burns scarce attention re-deriving an answer the AI already has right). So the laws are not absolute: low conditioning → provoke-origination; high conditioning → propose-for-ratification (lead with the answer, human spot-checks — judge mode is now appropriate because judging an above-mean proposal isn't settling for the mean). **The danger is the regime-switch:** switch too early and you reintroduce lowering while believing it safe. The switch is itself a hinge, and it needs a **measure of conditioning confidence we don't yet have.** Fault-line B **dissolves as conditioning matures** (by design) — but only if the switch is governed correctly. Developed next.

## Developing the conditioning-confidence measure (2026-06-26)

The measure that governs the fault-line-B regime switch: *for a class of decision, is the AI's proposal reliably above the mean — i.e., would it match what the human would originate?*

**The signal already exists: ratify-vs-correct is the confidence signal.** Every gate yields a labeled outcome — **ratify** (the AI's proposal met the standard → it transferred for that decision-class) or **correct** (it fell short → not yet transferred). Confidence for a hinge-class = the recency-weighted ratify rate over recent gates of that class. The instrument that *transfers* the standard (the re-filing/ratify training loop) doubles as the instrument that *measures how much transferred* — same data stream.

**But the measure is contaminated by mean-bias — a vicious circularity.** Under propose-for-ratification the human is mean-biased toward ratifying, so the ratify rate is inflated: switching regimes corrupts the very signal that justified the switch. **So confidence can only be measured cleanly under provoke-origination.** Mechanism: keep a **blind-audit channel** — the AI commits its proposal privately, the human originates **free-form** (open-ended, *not* multiple-choice — else fault-line A poisons the estimate), then reveal and score the match. Agreement under blind origination = uncontaminated confidence. It costs the attention you hoped to save, so you **sample** it (spot-audits at rate *r*), trading measurement freshness against cost.

Properties the measure needs:
- **Per hinge-class granularity.** Confidence isn't global — the AI may be well-conditioned on naming but not on decomposition. Tag the ratify/correct log by class; each class gets its own regime. (This can also drive partition-tier assignment.)
- **Severity weighting (the miss/false-alarm asymmetry).** A missed lowering is expensive and invisible; a false alarm is cheap. So gate the switch on *both* a high agreement rate *and* low worst-case load-bearing-ness. A class whose rare correction is catastrophic never leaves provoke-origination, however high its ratify rate.
- **Recency / drift / no permanent graduation.** Confidence is non-stationary: the codebase shifts, the model changes, and the human's standard itself keeps rising (the above-the-mean element's job is to climb). A high-confidence class can decay, so the measure is recency-weighted and a class can *regress* back to provoke-origination on a sustained drop. Never graduate a class permanently. (This is why the floor interjection is re-taken when conditioning or stakes change.)
- **The switch is a hinge — measure recommends, human ratifies.** Acting on the measure (switching regimes) is subtle and load-bearing, so it is a boundary-setter call the human owns. The measure informs; it does not decide. Automating the switch on a metric would *be* the "proceed unscrutinized" trap.

**Payoff — the loop closes and self-regulates.** The same human act (deliberating a gate) simultaneously transfers the standard and, via blind audits, measures how much transferred. As confidence rises, the regime relaxes, freeing human attention, which redirects to lower-confidence classes and to the irreducible catch-the-seam vigilance. The migration (decider → conditioner) becomes self-paced by its own measurement.

**Two permanent taxes (no free lunch).** (1) **Blind-audit sampling** — you pay an origination cost forever to keep the estimate fresh and catch drift; confidence is never free. (2) **Seam vigilance** — fault-line A means even perfect confidence on what the AI *can* produce never covers what only the person can produce, so catch-the-seam vigilance is also permanent. Conditioning confidence can relax the laws on what the AI can see; it can do nothing about what it can't.

## How to test it

A crude version already ran: the Name-feature proposal forecast GATE 1/GATE 2 and the candidate seams up front. Test on that run: did announcing the gates help the human spend attention where it mattered, or did it exert mean-bias toward ratifying? Track, per gate, whether forecasting changed the **ratify-vs-correct** outcome. Over several features, measure the forecast's **misses** and **false alarms** against where interjections actually fired — and, for the confidence measure, run occasional **blind audits** (AI commits privately, human originates free-form, score the match) to get an uncontaminated per-class confidence estimate.
