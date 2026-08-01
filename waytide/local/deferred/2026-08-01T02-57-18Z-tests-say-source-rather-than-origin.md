# The tests say "source" rather than "origin"

The `origin` prefix in the test suite becomes **`source`** — the control names and the other
test-local identifiers built on it. **Tests only.** `lib/` keeps `origin`.

## What is in scope

17 files under `test/automated/import_constant/`, carrying these identifiers:

| Identifier | Count |
|---|---|
| `origin_constant` | 74 |
| `origin_inner_constant` | 6 |
| `control_origin_name` | 3 |
| `control_origin_inner_constant` | 3 |
| `origin_name` | 1 |

## What is out of scope

`lib/` keeps `origin` — `origin_constant` (11 occurrences) and `origin_name` (8), including
`Constant::Import.call`'s own parameter. That is the instruction, and it has a consequence
worth stating plainly: **the tests and the library will name the same thing differently.** A
test will build `control_source` and pass it to a parameter called `origin_constant`. If
that is unwanted, the library rename is a separate decision and a separate item; this one
does not make it.

## Three things this does not settle

**The five prose occurrences.** `origin` appears in five `context` and `test` names, as
English rather than as an identifier:

```
refinement/top_level.rb:28        test "Are the origin's inner constants"
refinement/instance.rb:29         test "Is the origin's inner constant"
instance.rb:32                    test "Are the origin's inner constants"
already_included.rb:19            context "When the destination already includes the origin"
only/undefined.rb:5               context "When a named constant is not defined on the origin"
```

Renaming an identifier does not decide these. Left as they are, a test name says *origin*
while the variable beside it says *source*.

**The example module's name.** `Controls::Constant.example(name: "Origin", …)` appears 16
times, against 14 for `"Destination"`. The string is what the module is actually called at
run time and shows in every comment line of the output, so leaving it as `"Origin"` while
the variable holding it is `control_source` is legible but inconsistent.

**Whether `Destination` follows.** `origin` and `destination` are a pair. Renaming one and
not the other leaves a pair whose halves come from different vocabularies. Nothing here
proposes renaming `destination`; the question is simply not answered by this item.

## The overlap with the test-controls conformance item

`2026-07-30T21-28-46Z-import-test-controls-conform-to-the-suffix-rule` renames
`origin_constant` to **`control_origin`** across 14 of these same files. This item renames
the same identifier to a different word. **They cannot both be applied independently** — run
in sequence they would produce `control_origin` and then `control_source`, editing every one
of those files twice for one net change.

The two are one rename with a common target, **`control_source`**: the `control_` prefix and
bare form from the suffix rule, the word from this item.

The immediately preceding feature carried a note asking for exactly this kind of
coordination and it went unmade, so the two items were applied to overlapping files without
a decision. That is the failure to avoid here.

**Gated on:** nothing. Actionable whenever the coordination with the test-controls item is
settled.

**Why:** `origin` is the git remote's name and the word carries that association wherever it
appears in a repository, while `source` says what the module actually is — the module being
imported from. The tests are where the word is read most often, being the only place the
pairing with `destination` is set up explicitly.

**How to apply:** settle first whether this and the test-controls item run as one pass with
`control_source` as the target, or whether one supersedes the other. Then decide the three
open questions above — the five prose occurrences, the `"Origin"` example name, and whether
`destination` follows — before editing, so the suite does not end up half-conformed. Run the
suite to confirm the rename is behavior-neutral; the count must not move. Then delete this
file and record an entry in `waytide/local/log/`. Related: the deferred item
`2026-07-30T21-28-46Z-import-test-controls-conform-to-the-suffix-rule`, the local
namespace-variable-suffix rule, and the testing package's `control_` prefix rule.

---

Authored by Scott Bellware on Fri Jul 31 2026 at 7:57:18 PM PT
