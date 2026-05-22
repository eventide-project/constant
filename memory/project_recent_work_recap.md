---
name: Recent work recap (as of 2026-05-22)
description: Snapshot of the recent arc of work on constant — import macro, terminology fix, test cleanup, and the in-flight logging branch. Frozen in time; verify against git before acting on it.
type: project
originSessionId: 0f147931-fef4-458c-bf6a-b68a73947755
---
Snapshot taken 2026-05-22. This is a frozen activity summary — git log is authoritative for anything beyond this date.

**Why:** User asked to save the full recap verbatim after a long gap away from the project, to ease re-entry in a future session.
**How to apply:** Use as orientation when returning to this repo. Re-verify branch, uncommitted state, and any named files/symbols against the current tree before recommending action.

**Recent arc (most recent first):**
- **Import macro** — added `Constant::Import::Macro` so `include Constant::Import` extends the receiver with an `import` macro. Lives in its own file at `lib/constant/import/macro.rb` (commit `9926ffb`). Demo updated with macro + API examples (`3640959`).
- **Macro tests** — covered the basic macro flow (`469bc6a`) and the alias variant (`c987d00`).
- **Terminology fix** — renamed the "already imported" error case/tests to "already included" (`a3e3ef2`, `e1c8cbb`), matching the actual wording in `Constant::Import::Error`.
- **Test infrastructure cleanup** — constant control now takes inner-constant names instead of a block to eval (`8fc2b5c`); test exclusion pattern corrected (`0d86311`).
- **Housekeeping** — `.tool-versions` removed, local Claude settings gitignored, `CLAUDE.md` added, planning docs added then deleted, `notes.md` maintained.

**Where things stand right now:**
- Branch: `logging` (not master).
- Uncommitted change in `lib/constant/import.rb`: adds a `self.logger` (lazy `Log.build(self)`) and emits `trace` on entry and `info` on completion of `Import.call`. No `require` for `Log` has been added yet, and no tests touched. This is the in-flight work on this branch — looks like instrumenting the import flow.
