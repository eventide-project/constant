# Session — Naming the methodology, and the mindset framing (Mon Jul 27 2026 23:19)

**Backfill.** This record is written after the fact, from the durable records, and
covers **Mon 13 Jul 2026** — a short session, roughly two hours of afternoon work with
one late-evening addition — together with its **coda on Fri 17 Jul 2026**, a single
sweep that carried out the deferred item the session queued. Its title carries the
date it was *written*, per the record-title-date-format rule; the period it narrates
is the one named here.

The session was not feature work. It began by giving the project's variant of TDD its
canonical name — **Design By Efferent** — and then, by way of a question about where a
single new rule belonged, produced a piece of doctrine about how the whole rule set
relates to itself: a rule's folder names the **surface** it acts on, not the
**purpose** it serves, and a large share of the rules exist to install a mental stance
rather than to standardize a mechanic.

This document is the communicable record of that work: a chronological account of what
was asked and what was concluded at each step, with the settled vocabulary defined as
it arises. Pointers to the durable records are given throughout; this narrative is the
guided tour, those files are the source of truth.

> **On following the pointers.** Everything under `agent/` at the time now lives under
> `waytide/` — the working state under `waytide/local/`, and the rules as installed
> packages under `waytide/system/`. The log entries quoted below name their paths as
> they were written; the log is never reformatted.

---

## 1. The methodology gets its name

The project's variant of TDD had been called "efferent-oriented design" — descriptive,
but a phrase rather than a name. It was replaced entirely by **Design By Efferent
(DBE)**, recorded as a terminology rule, with the superseded
`say-efferent-oriented-design-not-development` rule removed and its still-valid
"design, not development" point folded into the new rule
(`2026-07-13T20-50-37Z-name-methodology-design-by-efferent`; commit `a771e3d`).

The scope of the retirement was drawn deliberately: only the **methodology's name**
changes. The lexicon term **efferent** — the use-site view, designing a unit from the
outside in — is untouched, and so is "efferent-oriented" used as an adjective for
*code*. The two live rules still carrying the old phrase were queued for a later
conformance pass rather than swept immediately, at the engineer's choice, and
historical log entries keep their words.

The name is now the one the whole system is organized around: the installed package is
`waytide/system/design-by-efferent/`.

## 2. A commit-message rule, and the question of where it belongs

Four minutes later, a rule on commit-message form: subjects lead with **the changed
thing**, in passive voice and indicative mood — "Widget reconciliation is corrected",
not "Fix …" and not "Fixed …" — omitting the verb entirely for a new item, using "is
corrected" for a defect and "is clarified" for a refactor, and dropping the
50-character subject limit (`2026-07-13T20-54-39Z-subject-first-commit-messages-rule`;
commit `6cbaa05`).

Then the question that turned the session: **where does this rule go?** The other
commit rules lived in `git/`. The engineer placed this one in `methodology/`, with the
new rule cross-referencing its siblings in `git/`.

That placement is the whole hinge. A rule about the wording of commit subjects looks
like a `git/` rule by every surface test — and it was filed elsewhere.

## 3. Rule folders name the surface, not the purpose

The framing extracted from the dialogue about that placement, recorded as an
observation with status DISCOVERY — not promoted, left to incubate
(`waytide/local/observations/2026-07-13T21-04-41Z-rule-categories-name-surface-not-purpose.md`;
log entry `2026-07-13T21-04-41Z`; commit `e5deab9`).

The claim: the rule folders — `terminology/`, `methodology/`, `git/`, `test-writing/`,
`code/` — are named for **where a rule applies**, not for **why it exists**. A large
share of the rules exist for the same underlying reason: to install a **mental
stance**, not to standardize a mechanic. The category names the surface; the purpose is
the mindset, and mindset cuts across every category.

**Terminology is the purest case.** Every terminology rule is an X-not-Y substitution —
controls-not-fixtures, actuation-not-call, normal-path-not-happy-path,
mediates-not-wrap, name-literally-not-by-analogy. None of them change what the code
*does*. Each swaps a word in order to swap the concept the word installs. The
`name-literally` rule says it outright — the terminology is the conveyable output of the
work — and rejects academic jargon not for being incorrect but for being preachy, which
is a criterion about the stance it puts the reader in, not about correctness.

**And the same purpose appears under other categories, through other levers.** The
subject-first commit rule is filed under `methodology/`, yet its point is to decenter
the developer — the identical target, reached through **grammar** (passive voice,
indicative mood) instead of vocabulary. The no-slang rule, filed under terminology,
explicitly extends its reach to conversation with the engineer and not only to what
lands in the codebase, because the mindset it protects lives in the person rather than
in the artifact.

So the operative question for such a rule is not "what does it standardize?" but **"what
stance does it install?"**

## 4. Promoted to a binding rule, then surfaced where rules are read

Half an hour later the framing was promoted from observation to binding rule: a rule's
purpose may cut across its category, and many rules install a mental stance rather than
standardize a mechanic — so a stance-installing rule is judged by **the mindset it
produces, not by surface conformance**. Filed in `methodology/`, being a rule about
rules (`2026-07-13T21-22-51Z-promote-rules-install-a-mindset-rule`; commit `2faf995`).

The observation was flipped to PROMOTED and **kept** as the discovery record rather
than deleted, following the pattern already established by the name-literally rule: the
rule carries the binding statement, the observation preserves the reasoning that
produced it.

One question was deliberately left open. The framing is adopted as doctrine, but any
*structural* response — a cross-cutting marker, a "mindset" note on affected rules, a
reorganization of the folders — is declined. The rule directs cross-referencing sibling
rules by shared stance instead.

Two hours later it was surfaced where it would actually be read: `AGENTS.md`'s Rules
section gained a **reading principle** — the folder names the surface a rule acts on,
not its purpose, so a stance-installing rule is judged by the mindset it installs —
placed after the "read every file" instruction, since it governs how the whole folder
is read (`2026-07-13T22-52-25Z`; commits `9fd4aeb`, `8d6a330`).

That placement is the point of the whole sequence. A doctrine about how rules relate is
useless where only rule-writers see it; it belongs at the entrance, where the rules are
read.

## 5. The rationale is sharpened

Late that evening, the subject-first rule's rationale was restated: it is about writing
**about the code, not about the developer**, because centering the developer reinforces
anthropocentrism in the mindset. This sharpens the earlier "what changed about the code,
not what the developer did" phrasing from a stylistic preference into the stance the
rule exists to install (`2026-07-14T05-28-41Z`; commit `0390e7e`).

The refinement is the new doctrine applied to the rule that provoked it: once
stance-installing rules are judged by the mindset they produce, the rule's own statement
of purpose has to name that mindset rather than the mechanic.

## 6. Coda — the conformance sweep

Four days later, the deferred item queued in §1 was carried out and deleted
(`2026-07-18T00-36-23Z-conformed-efferent-oriented-design-to-dbe`; commit `116b6d5`).

The sweep is smaller than the queue entry implied, and the reason is the scope note
from §1. Exactly **one** live use of the retired methodology *name* needed changing —
in the contained-red-green rule. The other candidate,
`tdd-as-design-tool`'s "efferent-oriented, high-solubility code", was **left alone**:
there "efferent-oriented" is an adjective describing *code* designed from the efferent
side, not the methodology's name, which the DBE rule's scope note explicitly excludes.
The DBE rule's own pointer to "a later pass" was repointed to "conformed on sight" now
that the pass was done, and historical log entries keep their words.

A one-line sweep, but it is the evidence that the scope note in §1 was doing real work:
a blanket find-and-replace would have retired a word the rule deliberately kept.

---

## Takeaways

- **A placement question is a design question.** Asking where the subject-first rule
  belonged surfaced that the folder taxonomy had never claimed to organize rules by
  purpose — and that a large share of the rules share a purpose their folders do not
  express.
- **A rule's category names its surface; its purpose may cut across.** Terminology,
  grammar, structure, and sequence are different **levers** on the same target. Two
  rules in different folders can be doing identical work.
- **Judge a stance-installing rule by the mindset it produces, not by surface
  conformance.** This is the operative consequence, and it is why the framing was
  promoted rather than left as an observation.
- **The doctrine was declined a structural response.** No reorganization, no
  cross-cutting marker — cross-reference by shared stance instead. Recognizing a
  cross-cutting concern is not by itself a reason to restructure around it.
- **Naming the methodology was scoped, not swept.** Retiring "efferent-oriented design"
  as the methodology's *name* deliberately left "efferent" the lexicon term and
  "efferent-oriented" the adjective for code — which is why the eventual conformance
  pass changed exactly one line.
- **The observation was kept after promotion.** The rule carries the binding statement;
  the observation preserves the reasoning. Deleting the discovery record would have left
  the doctrine without its argument.

## Glossary

Terms settled or sharpened during this session:

- **Design By Efferent (DBE)** — the canonical name for this project's variant of TDD,
  replacing "efferent-oriented design" entirely. The methodology's name only: the
  lexicon term **efferent** (the use-site view) and the adjective "efferent-oriented"
  applied to *code* are unaffected.
- **subject-first** — the commit-message form in which the subject is the software and
  its new state, stated in passive voice and indicative mood, never a leading verb.
- **mindset rule** — a rule whose purpose is to install a mental stance rather than
  standardize a mechanic. Judged by the stance it produces, not by surface conformance.
- **surface / purpose** — the distinction the session turns on. A rule's **surface** is
  where it applies (words, commits, tests, code) and is what its folder names; its
  **purpose** is why it exists, and may cut across categories.
- **lever** — the means by which a mindset rule acts: vocabulary, grammar, structure,
  sequence. Different levers, same target.

## Where the durable records live

- **Observation** —
  `waytide/local/observations/2026-07-13T21-04-41Z-rule-categories-name-surface-not-purpose.md`,
  status PROMOTED, kept as the discovery record. It carries the evidence — the list of
  X-not-Y terminology rules, and the two cross-category cases — that the binding rule
  compresses.
- **Decision log** — `waytide/local/log/`, entries `2026-07-13T20-50-37Z`,
  `2026-07-13T20-54-39Z`, `2026-07-13T21-04-41Z`, `2026-07-13T21-22-51Z`,
  `2026-07-13T22-52-25Z`, `2026-07-14T05-28-41Z`, and `2026-07-18T00-36-23Z`.
- **Rules** — the DBE naming rule and the rules-install-a-mindset rule are now installed
  under `waytide/system/` (`design-by-efferent/` and `foundation/`); the subject-first
  commit rule is in `waytide/system/git/subject-first-commit-messages.md`, which carries
  the anthropocentrism rationale from §5.
- **`AGENTS.md`** — the reading principle from §4 was placed in its Rules section. The
  file has since been rewritten for the Waytide system layout, so the principle now
  reaches readers through the installed rule rather than through that text.
- **Commits** — `a771e3d`, `6cbaa05`, `e5deab9`, `2faf995`, `9fd4aeb`, `8d6a330`,
  `0390e7e` on 13 Jul; `116b6d5` on 17 Jul.

## A closing note

Two hours' work, and no code changed in any of it. What the session produced is a lens:
the recognition that a rule set organized by surface will hide the fact that many of its
rules are doing one job. It arrived the way the useful things in this project tend to —
not from setting out to theorize the rule set, but from a small, concrete question about
where one file should sit, asked at the moment the answer was cheap.

---

Authored by Scott Bellware on Mon Jul 27 2026 at 11:19:37 PM PT
