# Loop record — Macro's top-level idiom (`extend Constant::Import::Macro`)

Recorded live. `Constant::Import`'s macro form (`include Constant::Import; import
SomeOrigin`) doesn't work at the top level of a plain script — `self` there is
`main`, and Ruby's top-level `include` silently redirects to `Object.include`,
which only makes `import` a singleton method of `Object`, not callable from
`main` (an *instance* of `Object`). Extending `Macro` directly gets past the
`NoMethodError: undefined method 'import' for main`, but then
`Macro#__import_constant` called `Import.(origin_constant, self, **kwargs)` with
`self == main`, and `Import.call` does `destination_constant.ancestors…`, which
raises because `main` isn't a `Module`/`Class`.

---

## Pass 1 — Direction: extend-based vs. include-based *(options)*

**Hinge:** two viable fixes, presented before any test-writing (per the
actuation-gate rule, ahead of hinge 1):

- **Option A (extend-based):** new top-level idiom
  `extend Constant::Import::Macro; import EnvVar`. Only needs
  `Macro#__import_constant` to fall back to `self.class` as the destination when
  `self` isn't already a `Module`/`Class`. Zero blast radius.
- **Option B (include-based):** makes `include Constant::Import; import EnvVar`
  work verbatim at top level, matching the README literally, but installs
  `import`/`__import_constant` as public instance methods on every object in the
  process for its lifetime — the same flavor of global reach the library's own
  README disclaims for constants, here applied to a method.

**Decision:** Option A (extend-based).

## Pass 2 — Build (hinge cycle)

- **Actuation** (options): explicit-receiver calls —
  `control_destination_object.extend(Constant::Import::Macro)` then
  `control_destination_object.import(origin_constant)` — over a
  self-rebinding `instance_eval` block that would have read closer to the literal
  top-level syntax.
- **Assertion** (options, revisited once — the developer flagged that the
  library already has its own `const_get` wrapper): resolve both sides through
  `Constant.get`/`Constant::Module#get` (`Constant.get(inner_constant_name,
  control_destination_class)` vs. `Constant.get(inner_constant_name,
  origin_constant)`) and assert `Constant` value-equality (`==`), rather than a
  raw `const_defined?`/`const_get` check or the library's own `#defined?`
  predicate.
- **Controls** (options): destination stand-in is an unnamed `::Class.new`
  instance (since `Controls::Constant.example` only ever builds `Module.new`,
  which can't be instantiated) — over naming it via `Object.const_set` to match
  the sibling tests' narration convention.
- **Red confirmed contained:** running the assembled test against the
  unpatched library reproduced the exact empirically-diagnosed failure
  (`NoMethodError: undefined method 'ancestors' for #<#<Class:…>:…>`), isolated to
  the new test file; the existing suite was untouched.
- **Implementation** (options): inline conditional in
  `Macro#__import_constant` (`destination = self; if not self.is_a?(::Module);
  destination = self.class; end`) over extracting a private
  `__import_destination` helper for the single call site.
- **Loop-continuation gate** (options): close after this one outcome — over
  adding a second, alias-variant outcome mirroring `macro.rb` → `alias.rb` —
  since the single outcome already demonstrates the fix dissolves into the real
  top-level use.
- **Naming** (options): "Imported constants are accessible via the destination
  class" — over the literal "Is the origin's corresponding inner constant" and
  the descriptive "Imported constants resolve to the origin's inner constants".

---

**Outcome:** `Constant::Import::Macro#__import_constant`
(`lib/constant/import/macro.rb`) falls back to `self.class` when `self` isn't a
`Module`/`Class`, so `extend Constant::Import::Macro; import SomeOrigin` now
works at the top level of a plain script. New test:
`test/automated/import_constant/macro/extend.rb`. Verified: 97 tests, 0 failed.
