# Loop record — Import shadow_inherited

A name the destination reached through an ancestor did not collide, and the import shadowed
it silently. This records the passes that refused it. The design had been settled on the
deferred item the day before; what the passes found is that its stated **mechanism** could
not work. The feature's lifecycle is
`waytide/local/features/2026-08-01T23-01-47Z-import-shadow-inherited.md`.

Written live.

**The parameter was renamed to `override_ancestor` on Sat Aug 1 2026.** This record keeps
`shadow_inherited` throughout, because that is the name that was decided and built here; a
record rewritten to the later name would say a decision was made that was not. See
`waytide/local/log/`'s rename entry of that date.

## Pass 0 — the settled mechanism does not work

**Hinge** — the deferred item's *How to apply* said the change was that "the second argument
to `const_defined?` changes". Before building, that was checked rather than taken.

**Options** — none at first; this was a factual check that turned into a decision.

**Decision / chat** — **it cannot work.** `const_defined?(name, true)` does not only search
ancestors. For a module it falls back to top-level constants:

```
Module.new.const_defined?(:String, true)   # => true
```

That module has no ancestors and includes nothing. So the check would refuse importing any
constant whose name matches anything at top level — and `Object` defines `Log`, which means
`import EnvVar` into any module would have been refused. **The fix would have broken the
case the refusal exists for.**

Two other shapes were measured against a module and a class destination:

| | `SomeInnerConstant` via ancestry | `String` |
|---|---|---|
| `target.ancestors` — module destination | found | not found |
| `target.ancestors` — class destination | found | **found** |
| `target.ancestors - ::Object.ancestors` — either | found | not found |

A class's ancestors genuinely include `Object`, so the second row is Ruby being correct
rather than quirky. That made it a real choice, not a defect to route around, and it was put
to the developer as one: does *inherited* mean **from a module you included or a superclass
you wrote**, or **whatever Ruby calls an ancestor**?

**Decision — whatever Ruby calls an ancestor.** `target.ancestors`, plain. A class
destination therefore also refuses names `Object` defines. Class destinations are reachable
here: the refinement on an instance sets the destination to the object's class.

## Pass 1 — actuation and placement

**Hinge** — where the two cases live. The refusal is now the **default** and the shadowing is
the opt-in, so the refusal raises and is the exceptional path.

**Options** — `inherited/`, named for the condition, or `shadow_inherited/`, named for the
parameter.

**Decision / chat** — **`shadow_inherited/`**, matching how `except/` and `only/` are named
after their keywords.

## Pass 2 — observation

**Hinge** — what the permitting file reads once `shadow_inherited: true` lets the import
through.

**Options** — that the name is now defined **directly** on the destination, which before the
import it was not, so a direct definition can only have come from the import; or that the
name now holds the **source's** constant.

**Decision / chat** — **the source's constant.** Definedness proves shadowing happened; the
value proves which constant won, and which one wins is the harm the refusal exists to
prevent.

## Pass 3 — controls

**Hinge** — how a destination that reaches a name only through ancestry is built.

**Options** — none — not gated. `Controls::Constant.example` already takes an `ancestor:`
parameter, added during the 3 July coverage audit for exactly this: a constant reachable
only via ancestry. Verified before use — the destination owns nothing,
`const_defined?(name, false)` is false, and the name is found through its one ancestor.

## Pass 4 — the message

**Hinge** — both collisions now raise from the same site, and the existing wording says the
constant "is already defined on" the destination. For an inherited name it is defined on the
**ancestor**.

**Options** — one message for both, which still discriminates against the other three
`Constant::Error` sites but misstates where the constant lives; or a second message naming
the ancestor.

**Decision / chat** — **its own message.** It tells the developer where the name actually
lives, which is what they would otherwise go looking for.

## Pass 5 — implementation

**The red was contained and was confirmed so rather than assumed.** Running before
implementing gave exactly one failure, in the new collision file, with every stable test
passing — no existing test having depended on an inherited name being shadowed.

The permitting file was **green on arrival**, and for an instructive reason: `**kwargs`
swallows an unrecognized keyword, so `shadow_inherited: true` was ignored and the import
proceeded. It covers the opt-in rather than driving it. That is the same swallowing noted
when `except:` was declared — the cost of keeping `**kwargs` for `alias`.

`target.ancestors` leads with the target itself, so **one search covers both cases** and
`equal?(target)` distinguishes them for the message:

```ruby
defining_constant = collision_constants.find do |collision_constant|
  collision_constant.const_defined?(import_constant_name, false)
end
```

## Pass 6 — naming

`Is the source's constant, rather than the ancestor's` — a value comparison, so the `Is`
form is available, and the developer chose the form naming both sides of what changed. The
refusal was named `Fails` under a `When the destination inherits the constant` context when
it was written.

## Outcome

`Constant::Import.call` gains `shadow_inherited:`, defaulting to `false`. An inherited name
collides; `shadow_inherited: true` restores the previous behavior. An inherited collision
raises its own message naming the ancestor. `shadow_inherited/shadow_inherited.rb` and
`shadow_inherited/collision.rb` cover both values. The suite moves from **117 to 119
tests**, all passing.

---

Authored by Scott Bellware on Sat Aug 1 2026 at 4:20:07 PM PT
Changed by Scott Bellware on Sat Aug 1 2026 at 5:51:26 PM PT
