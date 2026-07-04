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
