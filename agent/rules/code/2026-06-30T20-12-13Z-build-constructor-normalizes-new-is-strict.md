# `build` is the normalizing constructor; `new` is the strict initializer

Each domain class has two construction paths, with distinct jobs:

- **`new` (the initializer)** — **strict**. It records its inputs as-is: no
  normalization, no validation (per the design's stance that the initializer is
  "purely mechanical state-recording"). Passing a malformed input to `new` is
  developer misuse, not accounted for.
- **`build` (the constructor)** — the **forgiving, user-friendly front door**. It
  **normalizes** its inputs into the strict form the initializer expects, then
  delegates to `new`. Construction is lenient where initialization is strict.

So every domain class carries **both** `new` and `build`. The `build` methods are
largely passthroughs to `new`, but they do the work a constructor should — coerce
the inputs so callers don't have to match `new`'s strictness. Examples:

- `Constant::Literal.build` coerces a Symbol name to a String (per the
  String-outputs convention) before calling `new`.
- `Constant::Module.build` is near-passthrough (a module is already a module) but
  exists for symmetry, so the construction surface is uniform across subtypes.

The `build`/`new` distinction lives on the **subtypes** (`Constant::Module`,
`Constant::Literal`) — the abstract `Constant` module has no class-level `build`
of its own. The class-level universal accessor is **`Constant.get`**: it takes a
name-or-module and **delegates to the right subtype's `build`** (constructing a
module directly, or resolving a name and building the mediating subtype) — so
normalization flows through every construction path, including callers that build
constants on their own (e.g. `#constants`). (The former class-level
`Constant.build` was dropped as a duplicate of `Constant.get(mod)`; a value in
hand is constructed through the subtype `build`s.)

**Why:** separating a strict initializer from a forgiving constructor keeps `new`
simple and predictable (just records state) while giving callers a lenient,
normalized entry point. Normalization lives in one place per class (`build`),
not scattered across call sites, so it can't be forgotten by a path that bypasses
the factory.

**How to apply:** give each domain class a `build` that normalizes its inputs and
delegates to `new`; keep `new` strict. Construct through the subtype `build`s (or
`Constant.get`, the universal class-level accessor, which routes to them); reserve
`new` for the internal, strict primitive. Related: the design doc (Section 2 —
`new` as mechanical state-recording) and Section 5 (the accessor).

## Within the `Constant` family, the supertype factory may call a subtype's `new` directly

The "construct through `build`" instruction governs **callers outside the family**.
Inside the family, the abstract `Constant` supertype **is** a factory of its
subtypes (`Constant::Module`, `Constant::Literal`), and its own factory code is
allowed to invoke a subtype's `new` **directly** — skipping that subtype's
`build` — **when it already holds the input in the strict, normalized form `new`
expects.**

`build`'s job is the **determination/normalization logic** (is this already a
`Constant`? is the name a Symbol to coerce?). When the supertype's factory code
has just produced a value that is known to be in strict form — e.g. a raw
`::Module` resolved via `Object.const_get` — that determination logic has nothing
left to decide, so routing through `build` only adds a dead branch. The supertype
may go straight to the initializer.

Example: `Constant.namespace` resolves a raw module and constructs
`Constant::Module.new(namespace_mod)` (and `Constant::Module.new(Object)` for the
top level) directly. It *could* call `Constant::Module.build`, and would get the
same result — but the input is already a bare module, so `build`'s "is it already
a `Constant`?" check is guaranteed to fall through to `new`. Calling `new` states
"I already hold the strict form" and elides the needless determination.

**The boundary:** this is an **intra-family privilege**, not a general license to
skip `build`. It applies only to (a) code *within* the `Constant` family
constructing (b) its *own* subtypes from (c) an input already in strict form. Any
path that still needs normalization — a name that might be a Symbol, a value that
might already be a `Constant` — must go through `build`. External callers always
use `build` / `Constant.get`.

**Why:** the supertype-as-factory relationship makes `new` a legitimate internal
seam *for the family itself*, the way a class may use its own private constructor.
The strict/forgiving split protects callers from `new`'s strictness; family code
that has already satisfied that strictness is not a caller in that sense — it is
the factory. Forcing it back through `build` would run determination logic whose
outcome is already known.

**How to apply:** if you are inside the `Constant` family, constructing a family
subtype, and the input is already the exact strict form the initializer records,
`new` is allowed and preferable to a `build` call whose normalization is a no-op.
If any normalization remains to be done, use `build`. Related: the review that
settled this (`agent/log/2026-07-04T05-49-40Z-whole-project-code-review.md`,
finding #2).
