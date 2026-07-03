# Say "efferent-oriented design", not "development"

The methodology practiced here is **efferent-oriented design** — not
"development," and not "test-driven development." Two corrections are packed into
the name:

- **Design, not development.** It is a *design* activity — tests used as proofs
  for design (see the "TDD designs, coverage protects" rule) — not "development,"
  which frames it as building or coding. "Development" mischaracterizes the
  essence.
- **Efferent-oriented.** The design is driven from the **efferent** (use-site)
  view: the actuation — the first efferent reference to the unit — is written
  before any implementation, forcing the interface outside-in. The tests are the
  vehicle; the efferent orientation is the essence. (See the efferent-not-caller
  rule.)

**Why:** calling it "development" (or leaning on "test-driven development") buries
what the practice actually is — designing an interface from its use site.
"Efferent-oriented design" states it literally. Same literal-naming discipline as
the lexicon rules (green → verified, vendor → install, arrange → control, thread →
convey, guard → protect).

**How to apply:** call the methodology **efferent-oriented design**; say "design,"
not "development." Existing rules, logs, and loop records that say "TDD" or
"development" refer to this same practice and can be conformed to the term in a
later pass. Related: the efferent-not-caller rule, the "TDD designs, coverage
protects" rule, the hinge-cycle rule, and the other lexicon rules.
