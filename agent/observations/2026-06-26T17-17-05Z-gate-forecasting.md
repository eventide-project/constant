# Observation: gate forecasting — the AI predicts and announces the gates ahead of acting

**Status:** Speculation, early. The user's words: "Predicting the gates and then communicating them to the human could be a key to the TDD AI process maybe. Just a speculation at this point." Recorded as a low-maturity working hypothesis, not adopted. Would promote toward a rule only after being tested on real runs (precision/recall on hinge-prediction; whether it helps or anchors). Companion to `2026-06-26T16-40-50Z-whether-to-interject.md` (the two dials), `2026-06-26T16-54-59Z-the-humans-role.md` (the modes), and `2026-06-20T18-48-32Z-tdd-hinge-marks-and-discovery.md` (discovery method).

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
- **Crying wolf / gate inflation.** Over-forecasting (flagging mechanical decisions as gates) re-imposes the attention cost it was meant to save and trains the human to rubber-stamp. Needs calibration: precision *and* recall on hinge-prediction.
- **Anchoring.** "Here is the call I am about to make, please ratify" biases the human toward assent — degrading the gate into theater and contaminating the ratify-vs-correct measurement. Mitigation: present the decision and live alternatives, not a fait accompli to bless.

## Net read

Most powerful as a **supplement that focuses attention** and a **calibration channel for transferring the hinge-map** — not a replacement for human vigilance.

## How to test it

A crude version already ran: the Name-feature proposal forecast GATE 1/GATE 2 and the candidate seams up front. Test on that run: did announcing the gates help the human spend attention where it mattered, or did it anchor toward ratifying? Track, per gate, whether forecasting changed the **ratify-vs-correct** outcome. Over several features, measure forecast precision/recall against where interjections actually fired.
