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

## Also in scope, settled 2026-07-31

**The names in `context` and `test` titles.** `origin` appears five times as English rather
than as an identifier, and each becomes `source`:

```
refinement/top_level.rb:28        test "Are the origin's inner constants"
refinement/instance.rb:29         test "Is the origin's inner constant"
instance.rb:32                    test "Are the origin's inner constants"
already_included.rb:19            context "When the destination already includes the origin"
only/undefined.rb:5               context "When a named constant is not defined on the origin"
```

The instruction named **contexts**, and two of the five are contexts while three are `test`
names. They are treated together here, the word being the same and the reason for changing
it the same. If the intent was the narrower one, this is the place to correct it — otherwise
three test names would keep saying *origin* beside a variable saying *source*.

**The example module's name.** The string given to `Controls::Constant.example` becomes
`"Source"`:

- `name: "Origin"` — 16 occurrences, one per file. This is what the module is actually
  called at run time, so it shows in every `comment` line of the output; leaving it while
  the variable holding it says `control_source` would be the inconsistency most often read.
- `"SomeOrigin"` — one occurrence, `refinement/top_level.rb`, a control string value passed
  through `Controls::Script`. It becomes `"SomeSource"`, keeping the "some" prefix the
  control-string convention requires.

## `destination` stays — settled 2026-07-31

`origin` and `destination` are a pair, so renaming one raised the question of the other. It
is answered: **`destination` is unchanged**, in identifiers, titles, and strings alike.

`origin` earned the rename for a reason `destination` does not share — `origin` is the
conventional name of a git remote, so the word carries that association wherever it appears
in a repository. `destination` carries no competing meaning here. The resulting pair,
`source`/`destination`, is the more conventional of the two, not the less.

**`target` was considered and is unavailable.** `Constant::Import.call` already uses it for
a narrower thing — the module the assignments actually land on, which is the alias module
when `alias:` is given and the destination otherwise (`lib/constant/import.rb`, lines 30–34).
Renaming `destination` to `target` would collapse a distinction the method depends on.
`recipient` is literal and free of collisions but buys nothing over `destination`; `host` and
`sink` are metaphors, which `name-literally-not-by-analogy` argues against.

Nothing in this item touches `destination_constant` (86 occurrences),
`name: "Destination"` (14), or the `destination`-named locals around them.

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
`control_source` as the target, or whether one supersedes the other — the one thing left to
decide. Then rename the identifiers, the five `context` and `test` titles, and the
`"Origin"` and `"SomeOrigin"` strings together, so the suite does not end up half-conformed.
Leave every `destination` alone. Run the suite to confirm the rename is
behavior-neutral; the count must not move. Then delete this file and record an entry in
`waytide/local/log/`. Related: the deferred item
`2026-07-30T21-28-46Z-import-test-controls-conform-to-the-suffix-rule`, the local
namespace-variable-suffix rule, and the testing package's `control_` prefix rule.

---

Authored by Scott Bellware on Fri Jul 31 2026 at 7:57:18 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 8:05:52 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 8:10:57 PM PT
