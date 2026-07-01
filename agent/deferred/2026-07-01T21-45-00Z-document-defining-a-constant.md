# Document defining a constant in the README

The README documents `Constant::Import` but not the **define** capability
(`lib/constant/define.rb` and its `test/automated/` tests). Add README
documentation for **defining a constant** — the macro/usage surface for creating a
constant — so the define feature is documented alongside import.

**How to apply:** read `lib/constant/define.rb` (and `lib/constant/import/macro.rb`
/ the define tests) to capture the actual API and its options, then write a README
section documenting it, mirroring the style of the `Constant::Import` section
(intro + example + macro form). Place it near the Import documentation. Docs only —
no code, no test impact. Delete this file and add an `agent/log/` entry.

**Why:** completeness — the library's define surface should be documented, not just
import; a user reading the README currently sees no way to define a constant.

**Related:** coordinate with the "move Import docs to the top of the README"
deferred item (`2026-07-01T21-40-00Z-readme-import-docs-first.md`) if both are done
together — decide where the define docs sit relative to the reordered Import docs.
