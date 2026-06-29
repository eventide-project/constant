# Terminology: no slang — "wrap" and "sweep" are retired; "mediates" (not "mediates for") is the canonical relation verb

Names, prose, comments, commit messages — **and conversation with the user** — use literal, non-slang terms. The no-slang standard governs phrasing addressed *to* the human, not only what lands in the codebase. Retired figurative words, each with a literal replacement:

| Retired (slang) | Use instead |
|---|---|
| **wrap** / **wrapper** | **mediates** — a `Constant` *mediates* a module |
| **sweep** | **conform** — bring code or prose into line with a convention (also *reconcile* / *propagate* where they read more exactly) |
| **land** / **lands** (e.g. "does that land?") | state it plainly — "is that right?", "does that work?", "is that correct?" |
| **arm** (of a method/feature, e.g. "the name arm") | **scenario** — "the name scenario", "the module scenario" |

**"mediates", not "mediates for".** The canonical verb for the `Constant`↔module relation is the bare **mediates**: *a `Constant` mediates a module*. This drops the trailing "for" the earlier decision had carried, and supersedes the "mediates for" wording in the `…22-39-10Z-mediates-for-verb.md` log and the `…06-33-29Z-no-prepositions-in-method-names.md` rule's example. (Other established phrasings stand — "sent to" is unaffected.)

**Why:** Slang and figurative terms are imprecise and import baggage — "wrap/wrapper" reads as a generic decorator and hides the accessor relationship "mediates" names exactly; "sweep" is loose where "conform" states the actual intent (matching a convention). Literal naming is the house style; this is the prose-and-process counterpart of the name-literally-not-by-analogy rule. Reserving "constant" for `Constant` instances and using "module"/"mod" for the raw module (the namespace-variable-suffix rule) is the same impulse applied to the domain nouns.

**How to apply:** Don't write "wrap"/"wrapper" or "sweep" in new names, prose, comments, commit messages, or replies to the user; write "mediates"/"conform". Don't ask whether something "lands" — ask plainly whether it is right or works. Don't call a method's or feature's variant an "arm" — call it a **scenario** (the name scenario, the module scenario). Use the bare "mediates" for the relation, never "mediates for". A historical record that *documents* a decision keeps the original word it quotes (rewriting it would erase the record) — only live, forward-looking prose conforms. Live prose still carrying "wrap"/"sweep"/"mediates for" (the design doc, the plan, a session, the `agent/deferred/…control-comment-prefix.md` item) is being conformed in a deferred pass. Related: the namespace-variable-suffix rule, the name-literally-not-by-analogy rule, and the mediates-for-verb log.
