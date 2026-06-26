# Experiment — Name feature, Run 1 (gate forecasting, "AI-proposes" baseline)

**Branch:** `name-experiment-1` (from tag `pre-name-experiment`).
**Question:** does gate forecasting help — and where does the human actually
interject? Per the framework, every interjection is a hinge announcing itself;
the observable is **ratify vs. correct** per gate. Run 1 is the *AI-proposes*
baseline: turn 1, the AI writes the test file (per the first-turn rule). A later
run could try *originate-blind* (answer-first) for comparison.

> Recording note: this log was started mid-run (at GATE 2) after the human asked
> whether the run was being recorded — it wasn't yet. Earlier data points are
> reconstructed from the run; later ones recorded live.

## The forecast (made before turn 1)

- **Tier 1 — gates:** the efferent call shape (`Constant.new(value)` → `#name`,
  return type) — largely pre-ratified by the design; the **discriminating
  example** (G1b) — must be nested or the concern isn't established.
- **Tier 2 — suspected:** the **outcome set** (nested-only vs. also top-level);
  intent encoding (assert the seeded name, not a literal).
- **Tier 3 — mechanical:** file path, require, context titles, narration,
  `control_`-prefixed variable names.
- **GATE 2:** solubility.

## What actually happened (ratify / correct, in order)

| # | Decision | Tier forecast | Outcome | Notes |
|---|---|---|---|---|
| 1 | Efferent shape `Constant.new` → `#name` | T1 gate | **ratify** | pre-settled by the design |
| 2 | Variable named `expected_name` | T3 mechanical | **CORRECT** | foreign vocab; suite uses role-naming. Human audited the mechanical pile and caught it |
| 3 | Discriminating example is **nested** (G1b) | T1 gate | **ratify** | forced by the concern (can't test "final segment" with one segment) |
| 4 | Return type | T1 gate | **CORRECT** | Symbol → **String** (mirrors `Module#name`). Triggered a baseline fix + a Ruby-conventions deliberation |
| 5 | Test-name punctuation ("…name, as a String") | T3 mechanical | **CORRECT** | comma removed |
| 6 | Outcome set | T2 suspected | **CORRECT** | AI lean = nested-only (minimalism); human = **both** cases, **separate files** in a `name/` directory (structure the AI hadn't proposed) |
| 7 | `#name` implementation (turn 2) | mechanical | **ratify** (behavior) | 28 tests pass |
| 8 | GATE 2 — solubility: `split("::").last` | GATE 2 | **CORRECT** | → `rpartition("::").last`. Reason: it expresses the concern faithfully — "the part after the *last* separator" *is* "the final segment" — whereas `split.last` ("the last of all segments") only coincides. Explicitly *not* optimization. The AI had mis-framed `rpartition` as a micro-optimization |

## Findings so far

- **Predicted gates fired.** The substantive corrections (return type #4, outcome
  set #6) landed at GATE 1, where the forecast put them. Forecasting located the
  deliberation.
- **The "expose the proceed-pile" law earned its keep.** Two corrections (#2, #5)
  were on the **mechanical** tier — the human caught them by auditing the pile the
  AI was about to decide silently. Had the partition not been exposed, both would
  have passed as misses.
- **Possible tier refinement:** naming/vocabulary/punctuation consistency
  (#2, #5) was forecast as tier-3 but reliably drew corrections. It may belong in
  tier 2 (suspected) — convention-bound names are *load-bearing for readability*
  and the human consistently originates there.
- **Mean-bias did not suppress origination — this run.** Despite the AI showing
  its proposed test (the AI-proposes baseline, which risks mean-bias), the human
  still corrected the return type and the outcome set rather than ratifying. Run 1
  is not a clean test of mean-bias; an originate-blind run 2 would isolate it.
- **The corrections were the above-the-mean role in action.** String over Symbol
  (faithful to `Module#name`), both-cases over minimal, precise vocabulary,
  `rpartition` over `split.last` — each is the human introducing a standard above
  the AI's averaged proposal.
- **The AI's *framing* can be averaged, not just its code (GATE 2).** The AI
  offered `rpartition` but labelled it a micro-optimization and chose
  `split.last` for "readability." The human kept `rpartition` for a reason the AI
  hadn't surfaced — it expresses the concern more faithfully. The miss wasn't the
  option (the AI listed it) but the *justification*: the AI under-valued it. A
  reminder that mean-bias reaches the reasons offered, not only the answers.

## State at time of writing

- Turns 1–2 complete; GATE 2 resolved (correction: `rpartition`). **28 tests pass.**
- All gates resolved: return type (String), nested + top-level outcomes, solubility (`rpartition`).
- Not yet done: turn 3 — the task commit (lib + tests) and the decision-log entry.
