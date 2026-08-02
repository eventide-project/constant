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

**The parameter was renamed to `override_ancestor` on Sat Aug 1 2026.** This record keeps
`shadow_inherited` throughout, because that is the name that was decided and built here; a
record rewritten to the later name would say a decision was made that was not. See
`waytide/local/log/`'s rename entry of that date.

## Setup

- **State:** Completed
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
- **Sat Aug 1 2026 at 4:20:07 PM PT** — *inherited* means whatever Ruby calls an ancestor,
  so a class destination also refuses names `Object` defines.
- **Sat Aug 1 2026 at 4:20:07 PM PT** — an inherited collision raises its own message,
  naming the ancestor.
- **Sat Aug 1 2026 at 4:20:07 PM PT** — the feature is concluded as **Completed** and
  integrated into `master`.
- **Sat Aug 1 2026 at 4:22:11 PM PT** — the branch `feature/import-shadow-inherited` is deleted,
  having been fully merged. No worktree to remove and no remote copy.

## Conclusion

**Completed** — integrated into `master` on Sat Aug 1 2026 at 4:20:07 PM PT. The suite moves
from **117 to 119 tests**, all passing.

**The settled design held; its stated mechanism did not.** The deferred item said the change
was that "the second argument to `const_defined?` changes". Checked before building, that
turns out to be unbuildable: `const_defined?(name, true)` does not only search ancestors but
falls back to top-level constants, so `Module.new.const_defined?(:String, true)` is true. A
check written that way would have refused importing any constant whose name matches anything
at top level — and `Object` defines `Log`, so `import EnvVar` into any module would have been
refused. **The fix would have broken the case the refusal exists for.**

The check walks `target.ancestors` instead. That list leads with the target itself, so one
search covers the direct and inherited cases, and `equal?(target)` tells them apart for the
message. *Inherited* was settled as **whatever Ruby calls an ancestor**, so a class
destination — reachable through the refinement on an instance — also refuses names `Object`
defines.

An inherited collision raises its own message, naming the ancestor the constant is actually
defined on rather than claiming it is on the destination.

**Designed with a contained red**, confirmed rather than assumed: running before implementing
gave exactly one failure, in the new collision file, every stable test passing. The
permitting file was green on arrival, because `**kwargs` swallows an unrecognized keyword —
so it covers the opt-in rather than driving it, which is the standing cost of keeping
`**kwargs` for `alias`.

**The originating deferred item is deleted**, its resolution recorded at
`waytide/local/log/2026-08-01T23-20-07Z-inherited-name-collides-on-import.md`. It was the
last item in the queue, which is now empty.

## Design record

Recorded in `waytide/local/loops/2026-08-01T23-20-07Z-import-shadow-inherited.md`, in seven
passes, written live.

---

Authored by Scott Bellware on Sat Aug 1 2026 at 4:01:47 PM PT
Changed by Scott Bellware on Sat Aug 1 2026 at 4:20:07 PM PT
Changed by Scott Bellware on Sat Aug 1 2026 at 4:22:11 PM PT
Changed by Scott Bellware on Sat Aug 1 2026 at 5:51:26 PM PT
