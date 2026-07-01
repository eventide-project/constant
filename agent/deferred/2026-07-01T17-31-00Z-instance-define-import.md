# Instance commands `#define` / `#import` on a `Constant`

`#get` is the resolution primitive on `Constant::Module`; `#define` and `#import`
are its **mutating** siblings — commands that write into the mediated module:

```ruby
constant.define("SomeInnerConstant", some_value)   # const_set into the mediated module
constant.import(source_constant, ...)              # import inner constants into it
```

`Constant::Literal` is degenerate for both (a literal contains nothing) — they
raise, mirroring `Literal#get`.

**Open questions to settle if taken up:**
- **Return values.** `#define` → the newly defined `Constant` (so it composes)?
  or the raw value? `#import` → the receiver, a summary, or the imported
  `Constant`s?
- **Relation to `Constant::Import`.** That command is **settled to stay in raw
  Ruby constants** (log 2026-07-01, import-negotiates-in-ruby-constants).
  `constant.import` is the *object-oriented* face — decide whether it delegates to
  `Constant::Import` internally or is independent, and what currency it exposes.
- **Redefinition / collision.** Does `#define` overwrite, raise, or check first
  (the `defined?` collision-check use the design doc mentions)?
- **`inherit:` / path arguments** — interaction with nested-path strings if that
  ships first.

**Gated on:** nothing hard; best sequenced **after** nested-path strings (shared
name-argument handling).

**Why:** rounds out the instance command surface — `#get` reads, `#define` /
`#import` write — so a `Constant` is a full handle on its module, not read-only.

**How to apply:** build test-first, one command at a time; `Literal` degenerate
form for each. Delete this file and add an `agent/log/` entry.
