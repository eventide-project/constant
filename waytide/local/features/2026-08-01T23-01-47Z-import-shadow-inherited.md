# Feature — Import shadow_inherited

## Intent

`Constant::Import`'s collision refusal calls `target.const_defined?(import_constant_name,
false)`. The `false` restricts the test to names defined **directly** on the destination, so
a name the destination reaches through an ancestor does not collide and the import shadows
it — with no error and, unlike the direct case, **no Ruby warning either**, since shadowing
an inherited constant is ordinary Ruby.

`Constant::Import.call` gains a **`shadow_inherited`** parameter, defaulting to **`false`**,
so an inherited name collides unless the caller asks for shadowing.

The feature originates in the deferred item
`2026-07-30T22-11-13Z-whether-an-inherited-name-collides-on-import.md`, which is deleted and
logged when this feature concludes.

## Setup

- **State:** In flight
- **Upstream branch:** `master`
- **Feature branch:** `feature/import-shadow-inherited`
- **Base:** `03cff1222077b907ec64edf6075349fd6b5aa811` on `master`
- **Working location:** Branch only — this working tree switched to the feature branch,
  and switches back to `master` at the conclusion.

## Settled before building

The design was settled on the deferred item over 2026-07-31, and is not reopened here.

**The name is `shadow_inherited`, not `inherit`.** `inherit:` is already a keyword on seven
methods across the library — `Constant.get`, `Constant.defined?`, `Constant()`, and
`Constant::Module`'s `#get`, `#constants`, `#constant_names`, `#defined?` — where it means
*resolve through the ancestry*. This parameter means *treat an inherited name as already
taken*. `Import` also already holds an `inherit` local.

**It is destination-only.** The name cannot be read as governing what gets imported, which
settles what a single `inherit:` would have bundled. The source keeps its hard-coded
`inherit = false` at `lib/constant/import.rb:36`; whether that should become a parameter too
is a separate question this feature does not raise.

**The default is `false`, so adding the parameter changes behavior.** That is deliberate:
today's silent shadowing is the case with no diagnostic of any kind, so the library's
refusal is the only signal there can be. Defaulting to `true` would have protected only the
caller who already suspected it. The cost is accepted — shadowing an inherited constant is
an ordinary Ruby pattern and now has to be asked for. The parameter is what makes that
affordable; the behavior is refused, not removed.

**The symmetry argument is deliberately given up.** The source's `inherit` answers "which
constants belong to this module"; the destination's answers "which names are already taken
here". Symmetry between them was a resemblance, not a reason, and the destination side is
where the silent failure lives. That the two sides no longer agree is now a stated choice.

## This is design, not coverage

New behavior is being brought into existence, so a **contained red** is available — the
failure would be isolated to the new test, no stable test depending on an inherited name
being shadowed. That is worth confirming rather than assuming: no existing test builds a
destination that reaches a colliding name through an ancestor.

## Confirmations

- **Sat Aug 1 2026 at 4:01:47 PM PT** — working location chosen at initiation: **branch
  only**.

## Design record

Recorded in this feature's loop record under `waytide/local/loops/`, added when the first
hinge is worked.

---

Authored by Scott Bellware on Sat Aug 1 2026 at 4:01:47 PM PT
