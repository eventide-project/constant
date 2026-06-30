# Consider a `Constant()` coercion method

A `Constant()` method (Ruby's `Integer()` / `String()` / `Array()` coercion
idiom) that takes either a **String** (a name) or a **Ruby constant** (a module)
and coerces it into a `Constant` instance — returning the matching subtype
(`Constant::Module` / `Constant::Literal`).

It would be the lenient, conversion-flavored front door over the existing
construction surface — most likely delegating to `Constant.build` (the factory)
— so callers can write `Constant(x)` to normalize an unknown-shaped reference
into the domain object.

**Open questions to settle if taken up:**
- Where it lives — a `Kernel`-style method (global, like `Integer()`), or
  namespaced. The library's ethos avoids polluting global scope, so a global
  `Constant()` deserves a deliberate decision.
- How it relates to `Constant.build` (probably a thin alias/delegate) and to a
  bare value with no resolvable name (a literal value alone can't be coerced —
  same constraint as `build`).

**Gated on:** the construction interface settling (`build`/`new`/`#get` —
in flight now). Revisit once that's stable.

**Why:** a coercion method is the idiomatic Ruby way to say "give me this as a
`Constant`, whatever shape it arrives in," and it would round out the
construction surface.

**How to apply:** decide placement and the relationship to `build`, then
implement test-first; delete this file and add an `agent/log/` entry.
