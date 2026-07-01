# Constant Class — Design

Date: 2026-05-22

> **Status (2026-07-01): implemented, and evolved past this document.** The
> `Constant` domain object shipped and then morphed from a single class into a
> **mixin module** included by `Constant::Module` (a module constant) and
> `Constant::Literal` (a literal constant) — the direction recorded in
> **Section 5**, now built (`build`/`new`/`#get`, `#constants`/`#constant_names`
> with `include_literal_constants`, equality by identity/binding-location).
> **Sections 2–4 below describe the initial single-class design and are
> superseded by Section 5**; the `README` and the code are the authoritative
> current reference. This document is kept as the design record.

## Summary

Add a `Constant` class to the `constant` library: a stateful object that
encapsulates the operations done with constants, so callers work through a
domain object instead of reaching into Ruby's low-level constant internals
(`const_get`, `const_set`, `const_defined?`, `constants`).

This first increment is **query-focused**. A `Constant` instance mediates a resolved
module or class and answers questions about it: its name, its namespace,
whether its name is present in some other namespace, and what module/class
constants it contains.

## Background & Motivation

The library currently exposes two stateless module-function utilities,
`Constant::Import` and `Constant::Define`, each invoked through `.call`. Both
reach directly into Ruby's constant internals.

`notes.md` proposes the complementary shape: a stateful `Constant` object that
is built once and then queried. This design covers that object, scoped to the
operations confirmed during brainstorming. Operations noted but not selected
for this increment are listed under "Out of Scope" below.

## Vocabulary

Precise terms, used consistently throughout this document:

- **module** — a Ruby `Module` or `Class` (`Class` is a subclass of `Module`;
  "module/class" means exactly this). The raw Ruby object a `Constant::Module`
  mediates. (Under the initial single-class design a `Constant` mediated *only* a
  module; the mixin/subtype design of Section 5 adds `Constant::Literal`, which
  mediates a **literal** value. "raw constant" is retired in favor of "module".
  "value" was retired here too but is **reintroduced** as the bound-value
  accessor `#value` — see Section 5.)
- **mod** — the variable spelling of a bare module. `module` is a Ruby reserved
  word, so an identifier that would otherwise be the bare word `module` is
  written `mod`.
- **`Constant`** — the stateful domain object that mediates a module. Always
  written capitalized (or in code font); a lowercase "constant" never refers to
  an instance — that is "a `Constant`".
- **constant** (lowercase, Ruby's own term) — a name bound within a module's
  scope, in Ruby's language sense (`const_get`, `Module#constants`, "inner
  constants"). Used only in this sense, and sparingly; where it reads more
  plainly, "a name bound to a module" is preferred. Never used for the raw
  module (that is "module") nor for the domain object (that is "`Constant`").
- **namespace** — the role a module plays when it contains other constants.
- **inherit** — Ruby's constant-lookup flag (the second argument to
  `const_defined?`, `const_get`, `constants`). `false` consults only the
  module's own constant table; `true` follows the ancestor chain. This library
  defaults `inherit` to `false` everywhere.
- **mediates** — the relation verb: a `Constant` *mediates* a module.

## Section 1 — Structure & File Layout

### `Constant` becomes a class

The top-level `Constant` is converted from a module to a class. A class is a
module, so everything currently nested under `Constant` (`Import`, `Define`,
`Log`, `Controls`) continues to work unchanged — only the namespace keyword
changes. `Import`, `Define`, `Macro`, and `Log` keep their current `.call`
semantics, their behavior, and their existing tests. The conversion is
behavior-neutral for them.

### New file

`lib/constant/constant.rb` holds the `class Constant` body: its class methods,
its instance methods, and `Constant::Error`.

### Require manifest

`lib/constant.rb` gains `require "initializer"` (the `evt-initializer`
dependency, used by the `Constant` class) and `require "constant/constant"` as
the first library requires, before `log`, `define`, `import`, and
`import/macro`. All files that open the namespace then agree on `class
Constant`, so require order is not otherwise sensitive.

### Package Dependency

`Constant` builds its initializer with the `evt-initializer` library, so the
gemspec gains `evt-initializer` as a runtime dependency. (It was already present
transitively, by way of `evt-log`; the class's direct use makes it a direct
dependency.)

### Mechanical edits — `module Constant` → `class Constant`

The five files that open the namespace at top level switch the keyword:

- `lib/constant/define.rb`
- `lib/constant/import.rb`
- `lib/constant/import/macro.rb`
- `lib/constant/log.rb`
- `lib/constant/controls/constant.rb`

### Test harness edit

`test/test_init.rb` line 14 does `include Constant`. A class cannot be
`include`d, so this becomes `Controls = Constant::Controls` — a constant
assignment that gives the test files the unqualified `Controls` they already
use. This also removes an `include`-as-import of the kind this library exists
to discourage.

## Section 2 — Construction

### `Constant.new(mod)` — the initializer

The initializer is generated by the `evt-initializer` library: the class does
`include Initializer` and declares `initializer :mod`. This yields a
`Constant.new(mod)` that records the module (`@mod = mod`) and a `#mod` reader —
nothing else: no validation, no deconstruction. Passing an invalid argument (a
non-module, an anonymous module) to the initializer is developer misuse and is
not accounted for in the implementation. The recorded module is the single
piece of state the object holds.

Because the initializer is purely mechanical state-recording — it makes no
decision the library is responsible for — it is not test-driven and carries no
test of its own.

### Instance state

A single instance variable, `@mod`: the mediated module/class.

### `#mod` (alias `#raw`)

The reader generated by `initializer :mod`, returning the recorded module — the
raw Ruby module behind the domain object. It is reader-only — no writer is
generated. `#raw` is an alias for `#mod` — the same reader under a shorter,
adjectival name (the *raw* module).

The reader is named `mod`, the keyword-safe spelling of the raw module it
returns (`module` is a Ruby reserved word). It is the escape hatch back to the
underlying Ruby object, where a generic name like `value` would say less.

### `#name`

Instance method, computed from `mod` on each call: the last
`::`-separated segment of `mod.name`, as a String (`Foo::Bar::Baz` →
`"Baz"`). This mirrors `Module#name` (a String, the type `#name` is derived
from). Every constant name the library *returns* is a String — including the
inner-constant listing `#constant_names`, which normalizes the Symbols of
`Module#constants` to Strings. Ruby itself ships a String/Symbol split
(`Module#name` a String, `Module#constants` Symbols), but the library presents
uniform String **outputs**; on **input** it accepts either type wherever the
delegated Ruby method does.

### `#full_name`

Instance method, computed from `mod` on each call: the full, `::`-qualified name
as a String (`mod.name` in full; `Foo::Bar::Baz` → `"Foo::Bar::Baz"`), where
`#name` returns only the final segment. Added test-first, after the original
task sequence.

### `#namespace`

Instance method, computed from `mod` on each call: the **`Constant`** for the
module named by the leading path of `mod.name` (`Foo::Bar::Baz` → a `Constant`
mediating `Foo::Bar`); `Constant.new(Object)` for a top-level module (a method
that must return a `Constant` cannot return `nil`, so `Object` is the top-level
fixpoint). The path-to-module resolution is encapsulated inside the class —
callers never touch `const_get`.

Because `#name` and `#namespace` are always computed from the mediated module
(`mod`), the instance's identity is the module's canonical identity. `build`'s
`name` argument (below) *locates* a module; it does not *rename* the resulting
instance.

### `Constant.build(name_or_module, namespace=Object, inherit: false)` — the constructor

The developer-facing constructor. It owns all convenience behavior and all
validation in the system.

- Given a **module/class** → delegates to `new` (the `namespace` and `inherit`
  arguments are not used).
- Given a **Symbol or String name** → resolves it within `namespace`, honoring
  `inherit`:
  - resolves to a module/class → `new(resolved)`
  - the name is not defined, or it resolves to a non-module value → raises
    `Constant::Error`
- `build(:Name)` → `namespace` defaults to `Object`.
- The `namespace` argument may itself be given as a **name or a module**: a name
  is resolved to its module through `build` recursively (defaulting to
  `Object`), so `build(:Inner, :Outer)` and `build(:Inner, Outer)` are
  equivalent.
- Accepts a **single** constant name only — nested-path strings (`"Foo::Bar"`)
  are out of scope.
- `inherit` is an optional keyword parameter, last in the parameter list,
  defaulting to `false`. It governs the name-resolution lookup within
  `namespace`.

## Section 3 — Instance Query API

### `#defined?(in: namespace, inherit: false)`

Answers: *does `namespace` contain a constant whose name is this instance's
`#name`?* Returns a boolean.

- The namespace is **required**, supplied through the `in:` keyword. (`in` is a
  Ruby reserved word, so the implementation reads it from `**kwargs` — the same
  technique `Import` already uses for the reserved `alias:` keyword.) Omitting
  `in:` raises `ArgumentError` — a missing required argument is a programming
  error, mirroring how Ruby treats a missing required keyword, not an
  applicative `Constant::Error`.
- `inherit` keyword, default `false`.
- There is no no-argument form. A `Constant` always mediates a resolved module, so
  asking whether it is defined in its *own* namespace is degenerate; the method
  only ever answers the useful question — whether the name is present in some
  *other* namespace. The motivating use is collision-checking: before a future
  `import`, `source.defined?(in: receiver)` reports whether the name is already
  taken in the receiver.

### `#constant_names(inherit: false)`

Returns the names, as Strings, of the mediated module's inner constants **whose
values are themselves modules or classes**. Inner constants holding non-module
values are excluded. (`Module#constants` returns Symbols; they are normalized to
Strings on the way out, per the String-outputs convention.)

### `#constants(inherit: false)`

Returns `Constant` objects, one for each inner constant whose value is a module
or class. Because a `Constant` only ever mediates a module, inner constants
holding non-module values cannot be mediated and are excluded.

`#constants` and `#constant_names` cover the same set of inner constants and
correspond 1:1 — `#constant_names` gives their names, `#constants` gives them
as `Constant` objects.

Both default `inherit` to `false`.

## Section 4 — Class-Level API

### `Constant.defined?(name, namespace=Object, inherit: false)`

Returns a boolean: `true` if `namespace` binds a constant called `name`.

- A query — it **never raises**. An undefined name yields `false`.
- A pure **name-existence** check: it reports whether the name is bound,
  regardless of the bound value's type. Unlike `#constants` /
  `#constant_names`, it does *not* filter by value type — a name-collision
  check cares that a name is *taken*, not what it holds.
- `namespace` defaults to `Object` (checking top-level constants is a genuine
  use, so this default is not degenerate — in contrast to the instance
  `#defined?`, which has no default namespace).
- `name` is a single Symbol or String — no nested paths.
- This is the primitive that the instance `#defined?` delegates to: the
  instance supplies its own `#name`, the `in:` namespace, and `inherit`.

## Equality

Added test-first, after the original task sequence. Two `Constant`s are equal
when they mediate the same module: `#==` and `#eql?` compare by the mediated
`mod`, and a non-`Constant` operand compares `false` without raising; `#hash` is
the mediated module's `hash`. So equal `Constant`s compare equal, dedupe in a
`Set`, and interchange as `Hash` keys.

## Error Handling

`Constant::Error = Class.new(RuntimeError)` — defined in
`lib/constant/constant.rb`, extending `RuntimeError` directly, consistent with
the project's convention for applicative errors (e.g. `Constant::Import::Error`).

`Constant::Error` is raised from exactly one place: `Constant.build`, when a
name cannot be resolved within its namespace or resolves to a non-module value.
The message names the unresolved constant and the namespace, e.g.
`"SomeName is not defined in SomeNamespace"`.

`new` raises nothing — it trusts its input.

## Testing

Tests use TestBench and live in `test/automated/`. A new directory,
`test/automated/constant/`, mirrors the existing `import_constant/` layout:

- `build/` — one file per outcome: `value` (the module form), `name`
  (name+namespace), `namespace_name` (the namespace itself given as a name),
  `undefined` and `non_module` (the two `Constant::Error` cases).
- `name/` — `#name` computed from `#mod`, with `top_level` and `nested` cases.
- `namespace/` — `#namespace` computed from `#mod`, with `top_level` and
  `nested` cases (the latter covering a non-`Object` namespace).
- `full_name.rb` — `#full_name`.
- `equality/` — `#==`, `#eql?`, `#hash`: `equal`, `eql`, `hash`, `unequal`, and
  `non_constant`.
- `defined.rb` *(pending Tasks 7–8)* — instance `#defined?` (`in:` namespace,
  `inherit`) and class-level `Constant.defined?` (default namespace, `inherit`,
  `false` for an undefined name).
- `constants.rb` *(pending Tasks 10–11)* — `#constants` and `#constant_names`,
  both restricted to module/class inner constants and corresponding 1:1;
  non-module inner constants excluded.

`Controls::Constant.example` supplies example modules with inner constants.
`add_inner_constants` seeds module-valued inner constants from an Array of names
(each a fresh `Module.new`) and **non-module** inner constants from a Hash of
`name => value` — the Hash form added to exercise the exclusion behavior of
`#constants` / `#constant_names`.

The existing `Import` and `Define` tests must continue to pass unchanged —
that is the proof that converting `Constant` from a module to a class is
behavior-neutral.

`README.md` gains a new section documenting the `Constant` class.

## File-by-File Change Summary

New:

- `lib/constant/constant.rb` — `class Constant`: `Error`, `initialize`/`new`,
  `build`, class `defined?`, `#mod`/`#raw`, `#name`, `#full_name`, `#namespace`,
  `#==`/`#eql?`/`#hash`, instance `#defined?`, `#constants`, `#constant_names`.
- `test/automated/constant/build/` — `value`, `name`, `namespace_name`,
  `undefined`, `non_module`.
- `test/automated/constant/name/` — `top_level`, `nested`.
- `test/automated/constant/namespace/` — `top_level`, `nested`.
- `test/automated/constant/full_name.rb`
- `test/automated/constant/equality/` — `equal`, `eql`, `hash`, `unequal`,
  `non_constant`.
- `test/automated/constant/defined.rb` *(pending Tasks 7–8)*
- `test/automated/constant/constants.rb` *(pending Tasks 10–11)*

Modified:

- `constant.gemspec` — add `evt-initializer` as a runtime dependency.
- `lib/constant.rb` — add `require "initializer"` and `require
  "constant/constant"` as the first library requires.
- `lib/constant/define.rb` — `module Constant` → `class Constant`.
- `lib/constant/import.rb` — `module Constant` → `class Constant`.
- `lib/constant/import/macro.rb` — `module Constant` → `class Constant`.
- `lib/constant/log.rb` — `module Constant` → `class Constant`.
- `lib/constant/controls/constant.rb` — `module Constant` → `class Constant`;
  extend the control so a non-module inner constant can be seeded.
- `test/test_init.rb` — `include Constant` → `Controls = Constant::Controls`.
- `README.md` — add a `Constant` class section.

## Section 5 — Intended Direction: `Constant` as a mixin, with `Module` and `Literal` subtypes

*Added 2026-06-29, while starting Task 10. This is an **intended direction**, still
forming — it supersedes Sections 2–4 where they conflict once adopted. Some
points are settled (dictated); others are open. The working record, with the
open questions, is `agent/observations/2026-06-29T19-13-17Z-constant-literal-type.md`.*

### What prompted it

`#constants` is to gain an `include_literal_constants:` keyword (default
`false`). When `true`, the result also includes **literal constants** —
constants bound to a value that is not a module or class (per the
literal-constants terminology rule; this retires "non-module" in live prose).

A literal cannot be mediated the way a module is. A module knows its own
qualified name (`mod.name`), from which `#name`/`#full_name`/`#namespace` are
derived; a literal value does not — its name lives in the *binding* (the
containing namespace's constant table), not in the value. So a literal constant
needs its own domain type, constructed with its name and namespace.

### The two views of a constant

- **Binding view** — *a constant is a name bound to a value in a namespace.*
  Shared by every constant: `#name`, `#full_name`, `#namespace`, the bound
  value, value-equality.
- **Container view** — *a constant that is itself a namespace holding inner
  constants.* Meaningful only for a module: `#constants`, `#constant_names`,
  `#defined?`.

### The type model

`Constant` stops being the module-mediating *class* and becomes a **mixin
module** carrying the shared binding behavior, **included into two concrete
classes**:

- **`Constant::Module`** — the module constant. Inherits today's `Constant`
  behavior: mediates a module, derives name/namespace from `mod.name`, and
  answers the container view for real (`#constants`, `#constant_names`,
  `#defined?`).
- **`Constant::Literal`** — the literal constant. Its binding comes from a
  supplied name + namespace. It answers the container view **degenerately but
  truthfully**: `#constants` → `[]`, `#defined?(…)` → `false` (a literal
  contains nothing). This keeps `#constants`' result **uniform** — every element
  answers the full interface — rather than heterogeneous.

The shared `Constant` module holds the common algorithms expressed over
subtype-provided primitives (template-method style), while each subtype supplies
its own derivation source. Settled specifics:

- **Equality protocol (shared).** The module defines `==`/`eql?`/`#hash` over a
  subtype-provided `#equality_key`. `Constant::Module`'s key is its `#value` (the
  module — whose object identity already encodes its location);
  `Constant::Literal`'s
  key is its `full_name` — so two literals are equal iff they share a **binding
  location** (same namespace + name), regardless of the bound value. Different
  key types make cross-subtype operands unequal; a non-`Constant` operand
  compares `false` without raising.
- **Value accessor — `#value`.** The bound-value reader is **`#value`**,
  universal across both subtypes: `Constant::Module#value` returns the module,
  `Constant::Literal#value` returns the literal value. This **renames the
  as-built `#mod` reader back to `#value`** — one accessor whose name spans both
  a module-value and a literal-value, which is precisely why the literal subtype
  can answer it. (This narrows the Vocabulary's earlier retirement of "value":
  the *term* for a bare module is still "module"/"mod", but the *method*
  returning the bound value — module or literal — is `#value`. **`#value` is the
  sole accessor on both subtypes — no `#mod`, no `#raw`.** This removes the
  as-built `#mod` reader and the `#raw` alias (the "Raw alias" added-feature),
  both superseded by `#value` under this restructure.)
- **Construction.** `Constant::Module.new(mod)` (as today). `Constant::Literal.new(name, value, namespace)`
  records its final-segment name, the raw value, and its namespace (a
  `Constant::Module`) — name first (more primary than the value); a literal is
  only built where the binding is known.
- **Name/full_name/namespace** stay per-subtype (each derives from a different
  source); the module earns its keep through the equality protocol and the
  interface contract, not forced reuse.

### Public API migration (breaking)

Morphing `Constant` into a module removes `Constant.new` (a module cannot be
instantiated). The current class-level surface is rehomed:

- **`Constant.build` becomes the universal factory.** `build(module)` →
  `Constant::Module`. `build(name, namespace)` resolves the name and dispatches
  on the resolved value: a module → `Constant::Module`, a literal →
  `Constant::Literal` (which now has its name + namespace + value). The
  **`non_module` error is removed** — a name resolving to a literal is no longer
  a `Constant::Error`; it is a valid `Constant::Literal` result. The
  **undefined-name** error remains. (`build/non_module.rb` is re-scoped from
  asserting `Constant::Error` to asserting a `Constant::Literal`.)
- Direct construction is `Constant::Module.new(mod)` /
  `Constant::Literal.new(name, value, namespace)`.
- `Constant::Module` shadows Ruby's `Module` inside the namespace, so code that
  means Ruby's `Module` (e.g. `build`'s value dispatch) writes **`::Module`**.
- `Constant.defined?` (class predicate) and the `Constant.name` /
  `Constant.namespace` static helpers also need a home (on the `Constant` module
  as module-functions, or on `Constant::Module`).

This is a **breaking change** to the published surface — tolerable only because
the `Constant` class is newly introduced by this same plan; nothing external
depends on it yet.

### Settled (2026-06-29)

The open questions are resolved (decisions at
`agent/log/2026-06-29T19-34-57Z-…`):

- **Shared module contents** — the equality protocol (over `#equality_key`) plus
  the interface contract; per-subtype name/full_name/namespace/value derivation.
- **Value accessor** — `#value` universal (both subtypes), renaming the as-built
  `#mod` reader back to `#value`; `#raw`/`#mod` superseded.
- **Literal equality** — by binding location (`full_name`).
- **`Constant::Module` name** — kept; Ruby's `Module` is written `::Module`
  where meant.
- **`build`** — universal factory; the `non_module` error is removed.
- **`#constant_names`** — gains `include_literal_constants:` (default `false`),
  1:1 with `#constants`.
- **Sequencing** — the type model is built before Task 10's `#constants`; Tasks
  10–11 re-scope around it, and `build/non_module.rb` is re-scoped to assert a
  `Constant::Literal`.

`include_literal_constants:` defaults `false` on both `#constants` and
`#constant_names`; with `true`, literal constants are included (as
`Constant::Literal` / their names).

### Relation to the as-built `#defined?`

The instance `#defined?` was already reworked in Task 8 away from this doc's
Section 3 (`#defined?(in: namespace)` collision-check) to *the instance is the
namespace searched* — `constant.defined?(name_or_module)` reports whether the
argument is defined within the mediated module (name → name-existence; module →
identity/containment). Under this direction, that lives on `Constant::Module`,
and `Constant::Literal#defined?` returns `false`. Section 3 is to be conformed.

## Out of Scope / Deferred

The following appear in `notes.md` but are deliberately excluded from this increment:

- Instance commands — `#get`, `#define`, `#import`.
- Class-level resolution helpers — `Constant::Get`, `Constant.resolve`.
- Nested-path strings (`"Foo::Bar::Baz"`) for any name argument.
- Logging for the `Constant` class. The library's logging guidance targets
  `.call`-style actuators; `Constant` is a stateful object, not an actuator.
  This can be revisited later.
- Refactoring `Import` / `Define` to delegate to the `Constant` class.
  **Settled (2026-07-01):** `Constant::Import` will **not** negotiate in
  `Constant` instances — it takes and returns **raw Ruby constants**, the way a
  native Ruby `import` would if the language had one. `Import` stays in Ruby's
  own currency (modules/classes), independent of the `Constant` domain object.
