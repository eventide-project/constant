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
| 7 | `#name` implementation `split("::").last` | mechanical (turn 2) | **pending** | 28 tests pass; awaiting GATE 2 solubility verdict |

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
  (faithful to `Module#name`), both-cases over minimal, precise vocabulary — each
  is the human introducing a standard above the AI's averaged proposal.

## State at time of writing

- Turn 1 (test files) and turn 2 (implementation) complete; **28 tests pass**.
- Paused at **GATE 2 (solubility)** — human verdict pending.
- Not yet done: GATE 2 resolution, turn 3 (task commit + decision-log entry).
