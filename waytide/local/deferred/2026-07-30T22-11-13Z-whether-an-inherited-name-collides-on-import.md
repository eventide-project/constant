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

## The proposal: `Import` takes a `shadow_inherited` parameter

Rather than fixing the answer, `Constant::Import` takes a **`shadow_inherited`** parameter,
naming whether the import may shadow a constant the destination reaches through an ancestor.

```ruby
import EnvVar, shadow_inherited: false
```

Proposed 2026-07-31. The name was settled at the same time; the default was not.

**It is not called `inherit`, and that was deliberate.** `inherit:` is already a keyword on
seven methods across the library — `Constant.get`, `Constant.defined?`, `Constant()`, and
`Constant::Module`'s `#get`, `#constants`, `#constant_names`, and `#defined?` — where it
means *resolve through the ancestry*. This parameter means *treat an inherited name as
already taken*. Reusing the word for a second question would make the library's most
widely-shared keyword mean two things. `Import` also already holds an `inherit` local, so a
parameter of that name would sit beside it.

**Naming it this way settles the one-parameter-or-two question.** The word `inherit` covered
two distinct effects — whether the **source's** inherited constants are imported, and
whether the **destination's** inherited names are taken — and a single flag would have
bundled them. `shadow_inherited` cannot be read as governing what gets imported. So the
source side keeps its own arrangement, and this parameter is **destination-only**.

`lib/constant/import.rb:36` sets `inherit = false`, used twice, both on the source:

```ruby
import_constant_names = origin_constant.constants(inherit)
import_constant = origin_constant.const_get(import_constant_name, inherit)
```

Whether that hard-coded local should itself become a parameter is a **separate question**
this item does not raise. The destination check is the one this parameter reaches, and it
currently passes a bare literal:

```ruby
if target.const_defined?(import_constant_name, false)
```

**The default is open, and the earlier argument for it no longer applies.** While the
parameter was called `inherit`, `false` looked like plain consistency — every other
`inherit` in the library defaults to `false`. That argument does not survive the rename:
`shadow_inherited` asks a different question with the opposite polarity.

- `shadow_inherited: true` is **today's behavior** — the import shadows an inherited name
  silently.
- `shadow_inherited: false` makes an inherited name **collide**, which is a change.

So the default decides whether adding the parameter preserves current behavior or changes
it, and neither value can claim consistency with the rest of the library.

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

**How to apply:** decide first whether the answer is **fixed or given to the caller**. If
fixed, decide which way and change the second argument to `const_defined?` if an inherited
name is to collide. If given to the caller, add `shadow_inherited:` — the name is settled —
and settle its **default**, which decides whether the change preserves today's behavior
(`true`) or alters it (`false`); no consistency argument reaches it either way. Default it
to `nil` in the signature and coalesce in the body, per the optional-params rule. Either
way, answer the source-side symmetry argument in the record, and cover the decision with a
test whose destination reaches the colliding name through an ancestor rather than defining
it — covering both values where the parameter exists. Then delete this file and record an
entry in `waytide/local/log/`. Related: `lib/constant/import.rb`, `lib/constant/module.rb`
and `lib/constant/constant.rb` (where `inherit` means the other thing), the
optional-params-default-in-body rule, the feature record
`2026-07-30T19-48-47Z-import-collision-refusal.md`, and
`test/automated/import_constant/collision.rb`.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 3:11:13 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 10:44:31 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 11:13:42 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 11:34:16 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 11:40:43 PM PT
