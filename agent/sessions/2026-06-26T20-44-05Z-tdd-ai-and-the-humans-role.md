# Session — Discovering the Human's Role in AI-Driven TDD (2026-06-26)

A working session on the `constant` library. It began as a check-in on an
in-progress feature, turned into an extended theory-building dialogue about
what the human is *for* when an AI does test-driven development, and ended by
starting an experiment to test that theory on a real feature.

This document is the communicable record of that session: a chronological
account of what was asked and what was concluded at each step, with the settled
vocabulary defined as it arises. Pointers to the durable records (binding rules,
working observations, decision log) are given throughout; this narrative is the
guided tour, those files are the source of truth.

> A note on terms: this project insists that terminology be *soluble* — named by
> a direct, literal description, never by analogy, code, or academic jargon
> (this became a binding rule during the session). The vocabulary below reflects
> the settled, de-jargoned forms; earlier drafts used clumsier words that were
> retired as we went.

---

## 0. Where we started

The `constant` library is a small Ruby gem in the Eventide ecosystem. An
in-progress plan adds a stateful `Constant` class (it mediates a module/class and
answers questions about it). Two tasks were done (class conversion;
initialization with a `#raw_constant` reader); **Task 3 — Name** was next.

The prior week's commits weren't feature code — they were methodology: a binding
rule set establishing **TDD as a design tool**, plus a frozen vocabulary. The
session picked up from there.

## 1. The TDD thesis being built on

**TDD here is a design tool, not a testing ritual.** Red-green-refactor is
choreography whose only real purpose was ever to insert a human's attention at
the right moment. A test written before its implementation will trivially fail,
and that failure teaches nothing — so you don't stop to watch the red bar. Keep
what the ceremony was smuggling in (design judgment at the right points) and
drop the rest.

Two load-bearing ideas:

- **The cradle.** Approach every unit from the *efferent* side first — the
  use-site. The test is the first efferent reference, so writing the call before
  the implementation forces the interface to be designed from the outside in.
  The test then holds the implementation in position without gripping it rigid:
  a cradle, not an after-the-fact filter.
- **Solubility.** The target quality: how readily a unit dissolves into use.
  Exit the loop on solubility, not coverage. And don't regress to the mean of
  code you've seen — condition on this project's high-solubility code.

The vocabulary (frozen as a binding rule):

- **hinge** — a decision the design turns on. The object of attention.
- **gate** — where the loop stops and hands a hinge to the human. The mechanism.
- **deliberation** — what the human does at a gate.
- **mechanical** — everything that isn't a hinge; the AI generates it straight through.

> One-liner: *the AI generates straight through, and gates at the hinges — the
> subtle, load-bearing decisions — for the human to deliberate; everything else
> is mechanical.*

**What makes a decision a hinge — two marks, both required:**

1. **Subtle** — the choice takes design judgment that *isn't written in the code
   or tests*; it lives only in the person. (Versus *crude*: a tool, pattern, or
   name you can read off the artifacts.)
2. **Load-bearing** — other work rests on it, so a wrong choice spreads and
   sticks: cheap to fix now, costly later.

Two confirmed hinges: the efferent call (the interface shape) and solubility.

## 2. The prior question: *whether* to interject

The first new move. The hinge/gate machinery answers *where* the human acts and
*how* — but it presupposes *that* the human acts at all. It remains possible to
let the AI proceed entirely unscrutinized. So the live question is **whether** to
interject, which is upstream of *where*.

Resolution: this is a **second dial**, distinct from hinge-ness.

- **Dial 1 — hinge-ness:** is this decision subtle ∧ load-bearing? A fact about
  the *design*. Independent of how good the AI is. Says *where the risk is*.
- **Dial 2 — gate-policy:** given a hinge, do we actually stop? Depends on cost
  and on how much the AI has been conditioned. Says *whether to pay to cover it*.

The whether-question is dial 2, and it can be turned all the way to "don't
interject." Three observations pinned it down: at a real hinge an unscrutinized
AI can only average (which the thesis forbids); but "condition on this project's
good code" is an attempt to pre-load the standard into the AI, so **better
conditioning → fewer gates**; and yet one interjection is irreducible — deciding
the interjection policy is itself the most load-bearing hinge, so a human must
make it at least once.

(Durable: `agent/observations/2026-06-26T16-40-50Z-whether-to-interject.md`.)

## 3. The human's role: source and guarantor of the standard of "good"

Stepping back: the hinge/gate machinery is *instrumentation* — it says where and
when the human acts, but never names what the human is *for*. The real object of
discovery is **the human's role in AI TDD**.

**Proposal: the human is the source and guarantor of the standard of "good."**
Every thread converges on one ingredient only the human supplies — *subtle*
knowledge absent from the artifacts; an external referent for "above the mean";
a solubility judgment the passing tests can't certify. The AI can generate but
cannot *originate* the standard, because its only move without the standard is to
average, which is by definition not-good. So the machinery is recast: hinges/gates
are where the standard must be injected; deliberation is one way of injecting it.

## 4. The human as the above-the-mean element

A sharpening with teeth. The configuration needs an element *above the mean* —
above the AI's natural pull toward averaging — and **the human is that element.**
The AI's gravity is "good enough"; the human is inclined to "better," and
*better than the AI has encountered*. This is why the human is irreducible:
averaging can only reproduce the encountered distribution, so "better than
encountered" can't be recovered from the corpus — it can only be *introduced*, by
the human.

## 5. The role is a set of modes; purpose vs. operationalization

The role isn't one act — it's a set of **modes**, split by whether they're
permanent or fade as the AI learns:

| Mode | What the human does | Permanent or fading |
|---|---|---|
| **Originator** | Holds what "good" means here | Permanent — it's what everything is delegated *from* |
| **Boundary-setter** | Decides what counts as a hinge; sets gate-policy | Permanent — the standard *about* the standard |
| **Conditioner** | Transfers the standard into the AI ahead of time | The *lever* — converts fading load into the AI |
| **Decider** | Resolves a hinge in-loop | Fades as conditioning succeeds |
| **Judge** | Validates the AI's call against the standard | Fades, slower |

This reconciled two claims that looked like rivals — "the human is the source of
the standard" (a single **purpose**) and "the role is the set of its modes"
(irreducibly plural). They sit at two levels: **purpose** answers *why a human is
here at all* (the Originator mode, irreducible); the **modes** answer *what the
human does all day* (the purpose operationalized across a collaboration). Same
purpose, and as conditioning succeeds the weight migrates out of the fading modes
into the AI — so the human's role *migrates* toward originating and
boundary-setting; it does not shrink to zero.

Terminology settled here: the items are **modes of the one role** (not separate
roles, so no "set of roles" to name); **purpose** replaced the academic
"essence."

(Durable: `agent/observations/2026-06-26T16-54-59Z-the-humans-role.md`.)

## 6. The experiment, framed: the Name feature

To test the theory in practice, we set up Task 3 (Name) as a **build +
experiment**. The theory predicts the human interjects only at hinges, so we'd
*forecast* the gates and treat every actual interjection as data: a predicted
gate that fires confirms the framework; an unpredicted one names a hinge we
hadn't formalized; a predicted gate that needs no interjection means conditioning
already carried that standard. The observable per gate: **ratify vs. correct** —
ratify means the standard had transferred; correct means it hadn't (and the
correction becomes a conditioning candidate).

## 7. Gate forecasting

A speculation that grew teeth: **the AI predicts the gates and announces them to
the human before acting**, instead of the human catching the AI at the seam after
the fact. Why it might matter: it flips discovery from reactive to proactive;
converts silent averaging into an explicit handoff; is the boundary-setter's job
run inline (the AI proposes candidate hinges, the human ratifies); and
economizes the human's scarce attention by mapping where to spend it.

### The three laws of a good forecast

Pushing on its failure modes produced a shape:

1. **Provoke origination, not mean-bias.** Handing the human a proposed answer to
   ratify makes them *evaluate* it (judge mode) instead of *originate* the best
   (originator mode). Since the AI's proposal comes from the mean, this pulls the
   above-the-mean human down toward the mean. (This pull is **mean-bias**; see §8.)
2. **Expose the proceed-pile.** Don't forecast only the gates — forecast the whole
   decision partition (gates / suspected / about-to-decide-silently). The
   dangerous miss is always filed under "mechanical," so the mechanical pile must
   be visible for the human to audit.
3. **Keep it step-local.** An exhaustive partition only works at the scale of the
   current cradle; a whole-feature partition is unaffordable.

Meta-payoff: the human's *re-filings* between tiers are labelled data about where
the hinges are — so forecasting is the mechanism that migrates boundary-setting
to the AI.

(Durable: `agent/observations/2026-06-26T17-17-05Z-gate-forecasting.md`.)

## 8. mean-bias and lowering

Two imported jargon words ("anchoring", "recall/precision") were rejected as
un-soluble and replaced:

- **mean-bias** — the forecast pulling the human toward the AI's mean-drawn
  answer. (Named for its *direction*; it composes with the "mean" vocabulary.)
- **miss / false alarm** — the two ways a forecast goes wrong: a **miss** fails to
  flag a real hinge (expensive, invisible); a **false alarm** flags a mechanical
  decision (cheap, even useful). "Lean toward flagging" replaced "recall-biased."

A correction sharpened mean-bias: it names a *direction*, not a *harm* — bias
toward the mean is only a **lowering** if you start above the mean (for a
below-the-mean design it's an improvement). The rescue: at a *gate* the human is
above the mean by definition (a hinge is subtle, so the AI can only average), so
there mean-bias always produces a lowering. Settled: keep **mean-bias** for the
mechanism, use **lowering** for its effect at a hinge.

## 9. Two fault-lines on Law 1, and the conditioning-confidence measure

Two limits on "provoke origination, not mean-bias":

- **Fault-line A — options the AI can't reach** (developed in §11).
- **Fault-line B — the laws are stage-dependent.** Law 1 forbids mean-bias only
  *because the proposal is mean-drawn*; once conditioning lifts the proposal above
  the mean, leading with it is fine and provoking from scratch is wasteful. So the
  laws relax as conditioning matures — *if* the regime switch is governed
  correctly.

The switch needs a **conditioning-confidence measure**. The signal already
exists: the ratify/correct record per kind of decision. But there's a trap — if
you lead with the answer (propose-for-ratification), the human is mean-biased
toward ratifying, which inflates the very signal that justified the switch. So
confidence can only be measured cleanly under **blind audits**: the AI commits
its answer privately, the human originates free-form, then you compare. Same
instrument, two jobs (see §11). The measure must be per-kind, severity-weighted
(a catastrophic-miss kind never relaxes), recency-weighted (it can decay), and
the switch itself is a hinge the human ratifies — automating it on a metric would
be the "proceed unscrutinized" trap. Two costs never go away: blind-audit
sampling, and human vigilance for what the AI can't see.

## 10. Can the AI know its own conditioning? Can it predict the human?

- **Know its conditioning:** *empirically yes* — the ratify/correct record is in
  the artifacts; *introspectively no* — feeling the gap would require the gap's
  content to be inside it (contradiction). Worse, the AI's fluency is highest on
  the mean answer, so confident-and-wrong feels safe. Trust the record, not the
  feeling — and the record always lags one audit behind.
- **Predict the human:** it can learn the human's *expressed* taste on *seen*
  patterns (that's conditioning succeeding), but not *novel* origination. And the
  gap is permanent, not just large, because **prediction relocates the frontier**:
  once the AI absorbs the standard, "the mean" includes it, and the human's job is
  to exceed the now-AI-inclusive mean. The AI converges on where the human *was*;
  the human stays where the AI isn't yet.

Consequence: over-confident prediction would freeze the standard (the human stops
originating), so the provoke-origination channel must persist **forever** — not as
a fallback, but as the engine that keeps the standard rising. The migration is
*moving-frontier*, not *shrink-to-zero*.

(Durable: `agent/observations/2026-06-26T18-05-02Z-ai-self-knowledge-and-predicting-the-human.md`.)

## 11. Fault-line A, developed: the three-rung ladder

The lone limit that survives mature conditioning. To avoid pushing one answer,
the AI shows a *list* of options — but the list is the AI's own, drawn from the
average, and **showing a list makes the person pick from it instead of producing
their own**. The best option may not be on it. Options absent from the list form
a three-rung ladder:

1. **Reached** — the AI produced and surfaced it; on the list.
2. **Missed** — the AI could reach it but didn't this pass. *Fixable* (run more,
   varied lists).
3. **Unreachable** — only the person can produce it; the AI never reaches it.
   *Not fixable* — the permanent residue.

It looks like a 2×2 (reachable/not × surfaced/not) but the fourth cell is
impossible: being *reached* presupposes being *reachable*, so unreachable options
are always off the list. The labels carry this on their face.

The unreachable rung can't be produced — only kept from suppressing the person:
have the person **answer first, before seeing the AI's list**, then show the list
as a cross-check. This is structurally the same as the blind audit in §9 — so the
defense against unreachable options and the confidence measure are one
instrument. And the unreachable rung is not a new thing: the option the AI can't
reach, the decision it can't recognize as needing the person, and the answer it
can't predict are **the same single thing seen three ways — what only the person
can produce.**

## 12. The naming principle (promoted to a binding rule)

Running through the whole session was a methodological correction the human
applied repeatedly: **name concepts with direct, literal descriptions — no
real-world analogies, no opaque codes, no academic jargon.** A metaphor is itself
jargon (the reader must memorize the mapping); a code carries no meaning;
academic words read as preachy. The test: *can the reader understand it without
being taught a mapping?* This was promoted from observation to a binding rule
(`agent/rules/2026-06-26T19-55-19Z-name-literally-not-by-analogy.md`).

In practice during the session this retired: "anchoring" → mean-bias;
"recall/precision" → miss/false alarm; "A1/A2" and a "menu" metaphor → the
reached/missed/unreachable ladder; "essence" → purpose; "irreducible/intrinsic"
stated plainly.

## 13. Checkpoint, and starting the experiment

Before running the experiment we set a **checkpoint**: an annotated git tag
`pre-name-experiment` on the theory baseline. The pattern is tag-for-checkpoint
(immutable, the thing you return to) plus a branch per run (`name-experiment-1`,
`name-experiment-2`, …) started from the tag, so each run is preserved for
comparison.

**Run 1 began** on `name-experiment-1`. Following the binding first-turn rule, the
AI wrote *only the test file* for `#name` — the proposed efferent call (the
cradle) — forecast the gates, and stopped at the first gate for the human to
deliberate.

The first data point arrived immediately and validated the theory's mechanics:
the human audited a decision the AI had filed as **mechanical** (a variable named
`expected_name`) and caught that "expected" is foreign vocabulary the test suite
never uses — the convention is role-naming. A *correction on a mechanical-tier
item*: exactly the case the "expose the proceed-pile" law exists for. The fix
made the assertion compare two role-named variables, matching the suite.

At the time of writing the run is paused at the first gate, with the substantive
hinges (the discriminating nested example; the outcome set) still open for the
human's deliberation.

## 14. Running the experiment to completion — the corrections, gate by gate

The run played out as a sequence of human corrections, each one a data point.

- **GATE 1, return type (correct).** The human changed `#name` from a **Symbol**
  to a **String**. This opened a genuine design question — is there a foundational
  Ruby case for Symbol? The answer (supplied as *crude* knowledge): Ruby is mixed
  — `Module#name` is a String, `Module#constants`/`Method#name` are Symbols — and
  the strongest specific precedent for a mediated module/class's own name is
  `Module#name` (a String), the very type `#name` is derived from. Decided:
  String. The baseline (design doc, plan) was corrected on `master`;
  `#constant_names` stays Symbols, mirroring `Module#constants`.
- **GATE 1, outcome set (correct).** The AI leaned "nested case only" (minimalism).
  The human required **both** the nested and top-level cases, as **separate files
  in a `name/` directory** — a structure the AI hadn't proposed.
- **Two mechanical-tier corrections.** A variable named `expected_name` (foreign
  vocabulary; the suite uses role-naming) and a stray comma in a test name. Both
  were caught by the human auditing the "proceed pile" — exactly what Law 2 is for.
- **GATE 2, solubility (correct).** The AI implemented `split("::").last` and
  filed the alternative `rpartition` as a "micro-optimization." The human chose
  `rpartition` — not for speed, but because it *expresses the concern faithfully*:
  "the part after the last separator" **is** "the final segment," whereas
  `split.last` only coincides. A sharp lesson: **mean-bias can reach the AI's
  justification, not just its code** — the AI had the right option but the wrong
  reason for ranking it.
- **Turn 3.** `#name` committed (`rpartition`), Task 3 checked off, decision logs
  added; run 1 integrated into `master`; 28 tests pass.

Mid-run, the human asked "are you recording all of this?" — and the honest answer
was no: the run's data was being narrated in chat but not persisted. That gap was
closed by writing an experiment-run log
(`agent/experiments/2026-06-26T21-19-51Z-name-feature-run-1.md`) capturing forecast vs.
actual and ratify-vs-correct per gate.

## 15. The most informative miss — caught after integration

After integration, the human spotted that the test **context nesting** was wrong:
a flattened `context "Constant Name"` instead of `"Constant"` → `"Name"` mirroring
the `constant/name/` folders (the existing `import_constant/macro` convention).
This was a **true miss**: it escaped the forecast, every gate, the human's live
deliberations, *and* integration. The reason: the forecast partition had no entry
for *test-structure conventions*, so context nesting was never an itemized,
auditable decision — "expose the proceed-pile" can only help for what is actually
in the pile. The convention was only *implicit* in the existing tests; writing it
as a binding rule converts a recurring miss into conditioner output the AI can
apply and forecast going forward. (Two test-convention rules came out of this run:
the "Is"-prefix naming rule and the context-nesting rule.)

## 16. What the experiment showed

- **The forecast located the substantive gates** — return type and outcome set
  fired at GATE 1, solubility at GATE 2, where predicted.
- **Mean-bias did not suppress the human's origination** this run (the human
  corrected despite seeing the AI's proposals) — but run 1 is the *AI-proposes*
  baseline, not a clean test; it also showed mean-bias reaching the AI's *reasons*.
- **The blind spots were real and they were the residue:** the misses clustered in
  conventions not yet written down (vocabulary, test structure). Each became a
  rule — the migration from *decider* to *conditioner*, observed in one feature.
- **Every correction was the above-the-mean element at work:** String over Symbol,
  both-cases over minimal, `rpartition` over `split.last`, precise names. The AI
  generated; the human supplied the standard the AI's averaging could not.

---

## The takeaways, compressed

- TDD is a design tool; the human's attention belongs at the **hinges** (subtle ∧
  load-bearing decisions), and nowhere else.
- The human's **purpose** is to be the source and guarantor of the standard of
  "good" — the **above-the-mean element** the configuration needs, because the AI
  alone can only average.
- That purpose is operationalized across **modes** (originator, boundary-setter,
  conditioner, decider, judge). Conditioning migrates the fading modes into the
  AI; the role moves toward originating and boundary-setting — it never reaches
  zero.
- **Gate forecasting** could make the process work: the AI announces the gates
  ahead of time, governed by three laws — provoke origination (not mean-bias),
  expose the proceed-pile, keep it step-local.
- The residue that never transfers is one thing seen three ways — the
  **unreachable** option, the unflagged hinge, the unpredictable origination —
  defended by the same move: **answer first, compare second.**
- Name things by what they are. Soluble terminology is the conveyable output.

## Glossary (settled terms)

- **hinge** — a decision the design turns on; subtle ∧ load-bearing.
- **gate** — where the loop stops to hand a hinge to the human.
- **deliberation** — the human's act at a gate.
- **mechanical** — everything that isn't a hinge; the AI generates it straight through.
- **subtle / crude** — subtle = judgment absent from the artifacts (in the person);
  crude = readable off the artifacts.
- **load-bearing** — other work rests on it, so a wrong choice spreads and sticks.
- **cradle** — the efferent test held during generation, steering toward solubility.
- **efferent** — the use-site view; designing a unit from the outside in.
- **solubility** — how readily a unit dissolves into use.
- **the mean** — the AI's averaging tendency; "good enough."
- **above-the-mean element** — the human, who introduces "better than encountered."
- **purpose** — why a human is here at all: source/guarantor of the standard.
- **modes** — how the purpose is operationalized: originator, boundary-setter,
  conditioner, decider, judge.
- **conditioning** — transferring the human's standard into the AI ahead of the loop.
- **gate forecasting** — the AI predicting and announcing the gates before acting.
- **mean-bias** — a forecast pulling the human toward the AI's mean-drawn answer.
- **lowering** — mean-bias's effect at a hinge: the human producing worse than
  their unbiased best.
- **miss / false alarm** — a forecast failing to flag a real hinge / flagging a
  mechanical decision.
- **reached / missed / unreachable** — options on / fixably-off / permanently-off
  the AI's list.

## Where the durable records live

- Binding rules: `agent/rules/` (TDD-as-design-tool, the lexicon, the
  human-in-the-loop gating, the literal-naming rule, the test conventions).
- Working observations (under discovery): `agent/observations/` — the
  human's-role thread, gate-forecasting, the AI-self-knowledge thread, plus the
  running **dialogue digest** (`…19-03-59Z-tdd-dialogue-digest.md`) that preserves
  the reasoning behind each fork.
- Decision log: `agent/log/` — one line per decision, in commit order.
- The Name feature (the experiment's product): `lib/constant/constant.rb`
  (`#name`) and `test/automated/constant/name/{nested,top_level}.rb`, on `master`.
- The experiment run: `agent/experiments/2026-06-26T21-19-51Z-name-feature-run-1.md` —
  forecast vs. actual, ratify-vs-correct per gate, findings (run 1 integrated to
  `master`; the experiment is closed). The git scaffolding (branch, checkpoint
  tag) is incidental and not load-bearing now that the run is recorded here.
- Test-convention rules produced by the run: the "Is"-prefix naming rule and the
  context-nesting-mirrors-folders rule, in `agent/rules/`.

## A note on the session itself

This session was an instance of the very thing it theorized. The durable
conclusions are the AI's generation; but the moves that made them *good* were the
human's — rejecting averaged jargon ("menu", "expected", "anchoring"), insisting
on literal names, catching a foreign word the suite never uses. Those are the
**originator** and **boundary-setter** modes in action: the above-the-mean element
introducing what the AI's averaging could not. The transcript is, in that sense,
its own best evidence.
