# Whether a name the destination *inherits* collides on import

`Constant::Import`'s collision refusal calls `target.const_defined?(import_constant_name,
false)`. The `false` restricts the test to names defined **directly** on the destination,
so a name the destination reaches through an ancestor does not collide, and the import
shadows it. Whether that is right is undecided, and it is untested either way.

## What happens now

Verified on 2026-07-30. A destination that includes an ancestor defining
`SomeInnerConstant`, importing an origin that also defines it:

```
before, inherited from ancestor: Ancestor_9AF9::SomeInnerConstant
const_defined? strict:  false
const_defined? inherit: true
after import:           Origin_5E1E::SomeInnerConstant
defined directly now:   true
```

The name resolved to the ancestor's constant before the import and to the origin's after
it. No error is raised.

**And no Ruby warning is emitted.** Ruby warns on `already initialized constant` only when
a constant is redefined on the module that defines it; shadowing an inherited one is
ordinary and silent. So this case is **quieter than the case the feature was built for** —
the `env-var` collision at least produced two warning lines, which is how it was noticed at
all. Here there is nothing.

## The case for leaving it

The library already takes "own, not inherited" as its stance on the **origin** side:
`origin_constant.constants(inherit)` is called with `inherit` fixed to `false`, so an
origin's inherited constants are not imported. Applying the same stance to the destination
gives exactly the present behavior. Read that way the `false` is coherent rather than an
oversight, and the two sides agree.

Shadowing an inherited constant is also a normal Ruby pattern, frequently intentional —
it is much of what inclusion is for. Refusing it would refuse something callers do on
purpose.

## The case for changing it

The harm is identical to the case that motivated the refusal. A name that resolved to one
thing resolves to another afterward, and the caller never enumerated the names. That a
library obtained its `Log` by including a module rather than defining one is an
implementation detail of that library; it should not decide whether the import warns them.
And because Ruby is silent here, the library's refusal is the *only* possible signal,
where in the direct case it merely replaces a warning that was already firing.

## What is not settled

Whether the two sides should even be symmetric. The origin's `inherit: false` answers
"which constants belong to this module"; the destination's answers "which names are already
taken here". Those are different questions and the same answer may not serve both.

**Gated on:** nothing. Both earlier gates have cleared — the `import-collision-refusal`
feature was completed on 2026-07-30, and the test vocabulary was conformed on 2026-07-31, so
a test added now is written as `control_source` and `control_destination` from the start.

**Why:** the refusal exists so that an import cannot quietly take a name that belongs to
something else. There is a whole class of that failure the refusal does not reach, it is
the class with no diagnostic of any kind, and nothing in the suite records which behavior
was intended. Whichever way it is settled, it should be settled deliberately and covered,
rather than left as a consequence of an argument nobody weighed.

**How to apply:** once the feature concludes, decide whether an inherited name collides,
and cover the decision with a test either way — a destination whose colliding name comes
from an ancestor rather than from itself. If the answer is that it collides, the second
argument to `const_defined?` changes and the origin-side symmetry argument above should be
answered in the record. Then delete this file and record an entry in `waytide/local/log/`.
Related: `lib/constant/import.rb`, the feature record
`2026-07-30T19-48-47Z-import-collision-refusal.md`, and
`test/automated/import_constant/collision.rb`.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 3:11:13 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 10:44:31 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 11:13:42 PM PT
