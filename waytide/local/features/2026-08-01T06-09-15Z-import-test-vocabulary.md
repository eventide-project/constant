# Feature — Import test vocabulary

## Intent

Conform the `Import` and `Define` test vocabulary in one pass, carrying out two deferred
items together because they rename the same identifiers:

- `2026-07-30T21-28-46Z-import-test-controls-conform-to-the-suffix-rule` — the **form**:
  the `control_` prefix from the testing package's rule, and the bare form the local
  module-variable suffix rule gives a raw module, where the tests currently write
  `_constant`.
- `2026-08-01T02-57-18Z-tests-say-source-rather-than-origin` — the **word**: `origin`
  becomes `source`, `origin` being the conventional name of a git remote and so carrying
  that association wherever it appears in a repository.

Run separately, every affected file would be edited twice for one net change. Both items
are deleted when this feature concludes, along with the sequencing item
`2026-08-01T05-44-31Z-the-import-test-vocabulary-is-settled-first` that ordered them.

The change is behavior-neutral. The suite must hold at **114 tests**.

## Setup

- **State:** Completed
- **Upstream branch:** `master`
- **Feature branch:** `feature/import-test-vocabulary`
- **Base:** `4a508286a2fabcffc71f4c612ce6066584d575a9` on `master`
- **Working location:** Branch only — this working tree switched to the feature branch,
  and switches back to `master` at the conclusion.

## The target vocabulary

Confirmed against the suffix rule by reading what each variable is assigned from, before
the branch was cut.

| Now | Becomes | Holds |
|---|---|---|
| `origin_constant` | `control_source` | a raw `Module` |
| `destination_constant` | `control_destination` | a raw `Module` |
| `origin_inner_constant` | `control_source_inner_constant` | a `Constant` instance |
| `control_origin_inner_constant` | `control_source_inner` | a raw `Module` |
| `control_origin_name` | `control_source_name` | a `String` |
| `name: "Origin"` | `name: "Source"` | the control's example-module name |
| `"SomeOrigin"` | `"SomeSource"` | a control string value |
| `origin_name:` on the two `Controls::Script` methods | `source_name:` | a control's keyword |
| the five `context` / `test` titles saying *origin* | *source* | |

The two `_inner` variables are different things and do not collapse to one name:
`origin_inner_constant` holds a `Constant` instance, so its `_constant` suffix is correct
and it keeps it while gaining the `control_` prefix as an expected operand;
`control_origin_inner_constant` holds a raw module, so its suffix is wrong and it goes bare.

## What is out of scope

- **`destination` is unchanged** as a word — settled 2026-07-31. Only its form changes,
  `destination_constant` to `control_destination`.
- **The library proper keeps `origin`** — `lib/constant/import.rb` and
  `lib/constant/import/macro.rb`, 11 occurrences including `Import.call`'s own parameter.
  A test will build `control_source` and pass it to a parameter named `origin_constant`.
  That is the instruction and its consequence; changing the library is a separate decision.
- **`lib/constant/controls/script.rb` is in scope**, though it sits under `lib/` — controls
  are in scope wherever they live, settled 2026-07-31. It is the whole of `origin` under
  `lib/` outside the library proper.
- **Implementation locals, method parameters, and non-control result variables** are outside
  the suffix rule, settled 2026-07-30 — so `defined_constant`, `returned_constants`, and
  `imported_constant` in the tests keep their names.

## Confirmations

- **Fri Jul 31 2026 at 11:09:15 PM PT** — working location chosen at initiation: **branch
  only**.
- **Fri Jul 31 2026 at 11:14:20 PM PT** — controls are in scope wherever they live, so
  `Controls::Script`'s keyword is renamed though it sits under `lib/`.
- **Fri Jul 31 2026 at 11:14:20 PM PT** — the feature is concluded as **Completed** and
  integrated into `master`.

## Conclusion

**Completed** — integrated into `master` on Fri Jul 31 2026 at 11:12:11 PM PT. 21 files,
**182 insertions against 182 deletions**, line for line. The suite holds at **114 tests**,
which is what a behavior-neutral rename requires.

**Three deferred items are deleted**, their resolution recorded at
`waytide/local/log/2026-08-01T06-12-11Z-import-test-vocabulary-is-conformed.md`:

- `2026-07-30T21-28-46Z-import-test-controls-conform-to-the-suffix-rule` — carried out
- `2026-08-01T02-57-18Z-tests-say-source-rather-than-origin` — carried out
- `2026-08-01T05-44-31Z-the-import-test-vocabulary-is-settled-first` — the sequencing item,
  both halves discharged: the renaming pass is done, and the two follow-on items now exist
  as items of their own, so they will be written against the current vocabulary without
  needing to be told.

**One item is registered** that had only ever been an aside inside items now deleted:
`2026-08-01T06-12-11Z-import-copies-literal-constants-untested`. `Constant::Import` copies a
literal constant as readily as a module, no test exercises it, and nothing records whether
that is intended or incidental. Both items that mentioned it have been deleted, so without
registering it the observation would have gone with them.

**One gate is cleared.** `2026-07-30T22-11-13Z-whether-an-inherited-name-collides-on-import`
still named the `import-collision-refusal` feature, which concluded a day earlier. It is now
ungated, and a test added to it is written in the new vocabulary from the start — which is
what the sequencing item existed to ensure.

## Design record

Recorded in `waytide/local/loops/2026-08-01T06-12-11Z-import-test-vocabulary.md`, in three
passes, written live. Pass 3 records a mechanical failure worth keeping: BSD `sed` has no
`\b`, so the first attempt silently renamed nothing while reporting success.

---

Authored by Scott Bellware on Fri Jul 31 2026 at 11:09:15 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 11:14:20 PM PT
