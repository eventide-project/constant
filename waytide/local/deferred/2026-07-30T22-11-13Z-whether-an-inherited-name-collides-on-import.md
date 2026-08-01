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

## The proposal: `Import` takes an `inherit` parameter

Rather than fixing the answer, `Constant::Import` could take an **`inherit`** parameter
controlling whether ancestry is taken into consideration. Proposed 2026-07-31. The default
may be `false`; that is not settled.

**The keyword already exists throughout the library**, and always with the same default:

```
Constant.get(value, namespace=nil, inherit: nil)
Constant.defined?(name, namespace_name_or_module=nil, inherit: nil)
Constant(value, namespace=nil, inherit: nil)
Constant::Module#get(name, inherit: nil)
Constant::Module#constants(include_literal_constants: nil, inherit: nil)
Constant::Module#constant_names(include_literal_constants: nil, inherit: nil)
Constant::Module#defined?(name_or_module, inherit: nil)
```

Every one of them coalesces `inherit ||= false` in the body, per the
optional-params-default-in-body rule. **So `false` is what the rest of the library already
does**, and choosing it would make `Import` consistent rather than making a fresh decision.
Choosing anything else would make `Import` the one method whose ancestry default differs,
which is a claim worth stating if it is made.

**`Import` already has the value — as a hard-coded local governing only one side.**
`lib/constant/import.rb:36` sets `inherit = false` and uses it twice, both on the **source**:

```ruby
import_constant_names = origin_constant.constants(inherit)
import_constant = origin_constant.const_get(import_constant_name, inherit)
```

The **destination** check does not use it. It passes a bare literal:

```ruby
if target.const_defined?(import_constant_name, false)
```

So making `inherit` a parameter is nearly free on the source side — the local becomes the
argument — and is a real change on the destination side, where the literal has to become the
parameter.

**One parameter or two is the question the proposal raises.** The word covers two distinct
effects:

- **Source side** — whether the constants a module *inherits* are imported along with the
  ones it owns. Today they are not.
- **Destination side** — whether a name the destination *inherits* counts as already taken.
  Today it does not, which is what this item is about.

A single `inherit:` reading as "take ancestry into consideration" is coherent and matches how
the proposal was put, but it does bundle the two: `inherit: true` would then both widen what
is imported and widen what refuses. Whether a caller ever wants one without the other is not
known, and the symmetry argument above cuts both ways — it is the reason a single flag reads
naturally, and the reason the two sides might deserve separate control.

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
fixed, decide which way, change the second argument to `const_defined?` if it is to collide,
and answer the source-side symmetry argument in the record. If given to the caller, settle
whether `inherit` is one parameter or two, and settle the default — `false` matches every
other method in the library and needs no argument, anything else needs one. Either way,
cover the decision with a test whose destination reaches the colliding name through an
ancestor rather than defining it, and where the parameter exists, cover both of its values.
Then delete this file and record an entry in `waytide/local/log/`. Related:
`lib/constant/import.rb`, `lib/constant/module.rb` and `lib/constant/constant.rb` (where
`inherit` is already a keyword), the optional-params-default-in-body rule, the feature record
`2026-07-30T19-48-47Z-import-collision-refusal.md`, and
`test/automated/import_constant/collision.rb`.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 3:11:13 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 10:44:31 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 11:13:42 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 11:34:16 PM PT
