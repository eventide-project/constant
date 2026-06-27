# Observation: name concepts literally — no analogies, no codes, no academic jargon

**Status:** PROMOTED to a binding rule on 2026-06-26 → `agent/rules/2026-06-26T19-55-19Z-name-literally-not-by-analogy.md`. This file is kept as the discovery record (extracted from repeated user correction during the TDD-AI dialogue). Edit the rule, not this file, for the binding statement. Sharpens the lexicon rule's existing solubility criterion.

## The principle

Name a concept with a **direct, literal description of what it is**. Avoid three things, all of which force the reader to memorize an arbitrary mapping back to the actual idea:

1. **Real-world analogies / metaphors** (e.g. "the menu problem", "menu trap", "dishes", "cooking"). A metaphor is *itself* jargon: the reader must learn and hold the mapping (menu = the AI's option list, dish = option, cooking = originating). That is *more* to carry, not less — the opposite of soluble. Reasoning through an IRL analogy requires arbitrary memorization of yet more terms.
2. **Opaque codes** (e.g. "A1 / A2", "limit A"). A code carries no meaning; the reader must look up a key.
3. **Academic jargon** (e.g. "irreducible", "intrinsic", "recall / precision", "anchoring"). Off-axis, imported, and read as preachy to a working-engineer audience.

## The test

For any candidate name, ask: *can the reader understand it without being taught a mapping?* If they must memorize "X stands for Y," it fails. A literal description ("unreachable options") passes; an analogy ("the menu problem") fails even though it is vivid.

## Worked example (this is where the principle was extracted)

| Rejected | Why it failed | Adopted (literal) |
|---|---|---|
| "the menu problem" / "menu trap" | analogy — memorize menu=list, dish=option | *(describe directly: showing a list makes the person pick instead of produce)* |
| "A1" / "A2" | opaque codes | **reached** / **missed** / **unreachable** (the three-rung ladder) |
| "recoverable" / "irreducible" (of options) | academic | **missed** (the AI could reach it, fixable) / **unreachable** (the AI can't, ever) |

## Why

The terminology is the conveyable output of this work — how it is taught to other engineers. Every analogy, code, or academic term is a toll the reader pays on each encounter. Literal names are free at the point of use: the name *is* the explanation. (Consistent with the lexicon rule's solubility rationale; this is the concrete "no metaphors, no codes, no academic words" test.)

## Caveat

A few established framework terms are coined and slightly non-literal (e.g. **hinge**, **gate**, **cradle**, **mean-bias**). They are kept because they are short handles for ideas defined precisely elsewhere and are in active use — but each should still be the most literal short handle available, and new terms should default to plain description over fresh metaphor.
