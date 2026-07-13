# Observation: rule categories name the surface a rule acts on, not the purpose it serves — and "mindset" cuts across them

**Status:** PROMOTED to a binding rule on 2026-07-13 → `agent/rules/methodology/2026-07-13T21-22-51Z-rules-install-a-mindset-purpose-over-category.md`. This file is kept as the discovery record (extracted from dialogue while placing the subject-first commit-message rule). Edit the rule, not this file, for the binding statement.

## The framing

The rule folders — `terminology/`, `methodology/`, `git/`, `test-writing/`, `code/` — are named for **where a rule applies** (words, commits, tests, code), not for **why the rule exists**. A large share of the rules exist for the same reason underneath the surface: to install a **mental stance** — a way of thinking about the code and the work — rather than to standardize a mechanic. The category names the surface; the purpose is the mindset, and mindset cuts across every category.

## The evidence

**Terminology is the purest case.** Every terminology rule is an X-not-Y substitution — controls-not-factories, controls-not-fixtures, efferent-not-caller, actuation-not-call, normal-path-not-happy-path, verified-not-green, install-packages-not-vendor, control-not-arrange, convey-not-thread, protect-not-guard, mediates-not-wrap, name-literally-not-by-analogy. None change what the code *does*. Each swaps a word to swap the concept the word installs. The `name-literally` rule says it outright — *"the terminology is the conveyable output of this work"* — and rejects academic jargon not for being incorrect but for being "preachy," i.e. for the stance it puts the reader in. That is a mindset criterion, not a correctness one. Vocabulary is simply the most direct lever on a mental model, which is why terminology reads as the clearest instance.

**But the same purpose appears under other categories, through other levers:**

- **subject-first commit messages** is filed under `methodology/`, yet its whole point — *state what changed about the code, not what the developer did, because centering the developer reinforces anthropocentrism* — is a mindset rule. Its lever is grammar (passive voice, indicative mood) instead of vocabulary, but the target is identical: decenter the developer.
- **no-slang-mediates** (terminology) explicitly extends its reach to *conversation with the user*, not only what lands in the codebase — because the mindset it protects lives in the person, not in the artifact.

## The sharper claim

Many rules are **mindset rules wearing a category that names their surface rather than their purpose.** Terminology is the purest instance because words are the most direct lever on thought; methodology, test-writing, and naming rules are often the same thing reached through a different lever (grammar, structure, sequence). The operative question for such a rule is not "what does it standardize?" but "what stance does it install?"

## Why record it

This reframes how rules relate to one another: two rules in different folders can be doing the same work, and a rule's real justification may not be visible from its category. It also gives a lens for future rules — when writing one, ask whether its purpose is a mechanic or a stance, because a stance-installing rule is judged by the mindset it produces, not by surface conformance. Left implicit, the folder taxonomy invites reading each rule as a local convention rather than as one expression of a shared stance.

## Open question

Settled at promotion: the framing is adopted as doctrine (a rule's purpose may cut across its category; judge stance-installing rules by the mindset they install), and the "how to apply" lives in the rule. What remains deliberately unresolved is any *structural* response — a cross-cutting marker or a "mindset" note on affected rules. The rule directs cross-referencing sibling rules by shared stance rather than reorganizing the folders, so no reorganization is implied. Related: the terminology rules as a set, `name-literally-not-by-analogy` (rule and observation), `no-slang-mediates`, and the subject-first commit-message rule.
