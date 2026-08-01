# The `Import` and `Define` test vocabulary is settled and applied before further tests are added there

**Start here.** Four outstanding items touch `test/automated/import_constant/`, and they
interact in one direction. Two of them **rename** across the directory; two of them **add
files to it**. Whatever is added first is written in the old vocabulary and then has to be
renamed, so the renaming pass goes first and the rest follow it.

This item does not introduce work of its own. It names the order, and states the settled
target so the two renaming items are carried out as one pass rather than two.

## The target vocabulary

Confirmed against the suffix rule on 2026-07-31 by reading what each variable is assigned
from. The first table this item carried was wrong on two rows and is corrected here.

| Now | Becomes | Holds |
|---|---|---|
| `origin_constant` | `control_source` | a raw `Module` |
| `destination_constant` | `control_destination` | a raw `Module` |
| `origin_inner_constant` | `control_source_inner_constant` | a **`Constant` instance** |
| `control_origin_inner_constant` | `control_source_inner` | a raw `Module` |
| `control_origin_name` | `control_source_name` | a `String` |
| `name: "Origin"` | `name: "Source"` | the control's example-module name |
| `"SomeOrigin"` | `"SomeSource"` | a control string value |
| the five `context` / `test` titles saying *origin* | *source* | |

**The two `_inner` rows are not the same variable and do not collapse to one name.**
`origin_inner_constant` (`instance.rb:27`, `refinement/instance.rb:22`) is assigned from
`Constant.get(…)`, so it holds a `Constant` instance and the `_constant` suffix is
**correct** — it keeps it, and gains the `control_` prefix as an expected operand.
`control_origin_inner_constant` (`except/except.rb:23`) is assigned from
`origin_constant.const_get(…)`, so it holds a raw module and the `_constant` suffix is
**wrong** — it goes bare. Mapping both to one name, as the first table did, would have
collided them and stripped a correct suffix from two `Constant` instances.

`destination` is unchanged — settled 2026-07-31, recorded in the source item. The
`control_` prefix and the bare form come from the suffix rule; the word comes from the
source item.

## `origin_name` is a control's keyword, not a test variable — and it is in scope

The single `origin_name` in the tests (`refinement/top_level.rb:14`) is a keyword argument
passed to a control, not a local. The parameter belongs to
`lib/constant/controls/script.rb`:

```
top_level_import(origin_name: nil, …)
top_level_refinement_import(origin_name: nil, …)
```

Both default it to `"SomeOrigin"` and interpolate it into the Ruby they generate — 8
occurrences, the whole of `origin` under `lib/` outside the library proper.

**Settled 2026-07-31: controls are in scope wherever they live.** The keyword becomes
`source_name:` and the default becomes `"SomeSource"`. The source item's "`lib/` keeps
`origin`" is narrowed accordingly: it means the **library proper** —
`lib/constant/import.rb` and `lib/constant/import/macro.rb`, 11 occurrences of
`origin_constant`, including `Import.call`'s own parameter — which is untouched.

## The order

**First — the renaming pass**, carrying out both of these together and deleting both files:

- `2026-07-30T21-28-46Z-import-test-controls-conform-to-the-suffix-rule`
- `2026-08-01T02-57-18Z-tests-say-source-rather-than-origin`

They target the same identifiers. Run separately, every affected file is edited twice for
one net change.

**Then — the items that add tests to the same directory**, each written in the new
vocabulary from the start:

- `2026-07-30T22-11-13Z-whether-an-inherited-name-collides-on-import`, which adds a test
  whose destination reaches the colliding name through an ancestor.
- The **literal-constants** gap, noted inside the test-controls item and not registered
  anywhere as work: `Constant::Import` copies a literal constant as readily as a module —
  an origin owning `SomeLiteral = "some value"` has that string assigned onto the
  destination — and no test exercises it. It needs an item of its own, or folding into the
  inherited-name one.

Both would use the source and destination controls, so both are cheaper after the rename
than before it.

## Why this is written down rather than assumed

The overlap has been missed twice. The `error-tests-named-fails` feature carried a note
asking for exactly this coordination against the test-controls item; the decision was never
made and both `already_included.rb` and `alias.rb` were edited by that feature and will be
edited again by the rename. Then the source item was written against the same identifiers as
the test-controls item without either knowing about the other until they were compared.

Each item names its neighbour now, but a reader picking one up still has to reconstruct the
ordering from three files. This states it once.

**Gated on:** nothing.

**Why:** a behavior-neutral rename over a whole directory is cheapest when nothing is being
added to that directory at the same time, and every test written before it is a test that
has to be edited by it. Ordering the four is worth more than any one of them, and it is the
part that has repeatedly gone undecided.

**How to apply:** carry out the two renaming items as one pass, confirm the suite holds at
its current count, delete both their files, and log the resolution. Then take up the
inherited-name item and register the literal-constants gap. Delete this file once the
renaming pass is done and the remaining items are written in the new vocabulary — it is a
sequencing note, not a permanent record. Related: the four items it orders, the local
namespace-variable-suffix rule, and the testing package's `control_` prefix rule.

---

Authored by Scott Bellware on Fri Jul 31 2026 at 10:44:31 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 11:06:34 PM PT
