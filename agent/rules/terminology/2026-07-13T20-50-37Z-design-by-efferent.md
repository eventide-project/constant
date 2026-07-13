# The methodology is Design By Efferent (DBE)

The variant of TDD practiced here has a name: **Design By Efferent**, abbreviated **DBE**. That is the canonical name of the methodology — the whole approach these rules, the lexicon, and the loop describe.

The name states the essence. It is a **design** discipline (tests drive design — see the "TDD designs, coverage protects" rule), which is why the name says *Design*, not "Development"; and the design is driven **by the efferent** — the use-site view (per the TDD lexicon's `efferent`). The **actuation**, the first efferent reference to the unit, is written before any implementation, forcing the interface outside-in. DBE is a variant *of* TDD (tests are the vehicle), but its name foregrounds what makes it distinct: design originated from the efferent reference.

Use **Design By Efferent** in full, or **DBE** as shorthand, wherever you name the methodology — code, tests, rules, designs, commits, and prose. The three capitalized words give the acronym: **D**esign **B**y **E**fferent.

This **replaces** the term "efferent-oriented design," which is **retired** — it is no longer a name for the methodology (the earlier `say-efferent-oriented-design-not-development` rule is superseded and removed). The lexicon term **efferent** (the use-site perspective) is unaffected and still used as before; only the *name of the methodology* changes.

**Why:** the methodology needs one settled proper name with an acronym so it can be referred to and taught without circumlocution — the same conveyance motive behind the TDD lexicon. "Design By Efferent" names the essence literally (design, from the efferent), the same literal-naming discipline as the lexicon rules, and "DBE" gives a compact handle. Two competing "the name" declarations (efferent-oriented design vs. Design By Efferent) would drift; DBE is the single canonical name.

**How to apply:** call the methodology **Design By Efferent** or **DBE**. Do not use "efferent-oriented design" (retired), and do not name the methodology "test-driven development" or "development" — TDD is the genus it belongs to, DBE is its name. Existing rules, observations, design docs, and README prose that still say "efferent-oriented design" (or lean on "TDD"/"development" as the name) refer to DBE and are conformed in a later pass (see the queued deferred item). Related: the TDD lexicon rule (the vocabulary of DBE), the efferent-not-caller rule, the "TDD designs, coverage protects" rule, the hinge-cycle rule, and the human-in-the-loop rule.
