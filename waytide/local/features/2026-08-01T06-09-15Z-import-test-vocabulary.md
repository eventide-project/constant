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

- **State:** In flight
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

## Design record

Recorded in this feature's loop record under `waytide/local/loops/`, added when the first
hinge is worked.

---

Authored by Scott Bellware on Fri Jul 31 2026 at 11:09:15 PM PT
