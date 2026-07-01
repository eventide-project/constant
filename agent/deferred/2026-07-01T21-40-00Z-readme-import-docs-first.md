# Move the `Import` documentation above the Constant class/module docs in the README

The README currently leads with **"The Constant Class"** (its Getting-a-Constant,
Coercion, Queries subsections) and places the **`Constant::Import`** documentation
*after* it. Reorder so the **Import documentation comes first** — above the
documentation for the `Constant` classes and module.

**How to apply:** move the `Constant::Import` section (and all its subsections) so
it sits above "The Constant Class" section, directly under the README's opening
intro. Keep any intra-document links/anchors consistent after the move, and check
the transition reads cleanly (the intro → Import → the Constant class/module).
Purely a documentation reordering — no code, no test impact. Delete this file and
add an `agent/log/` entry.

**Why:** the developer wants `Import` — the primary entry point for most users — to
lead the README, ahead of the lower-level `Constant` class/module surface.
