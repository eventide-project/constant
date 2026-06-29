# Constant::Literal — a literal-constant type alongside the module-mediating Constant

**Status:** **Settled (2026-06-29)** and folded into the design doc (Section 5). This file is kept as the discovery record; the binding direction now lives in `agent/design/2026-05-22-constant-class-design.md` Section 5, and the resolutions are logged at `agent/log/2026-06-29T19-34-57Z-constant-literal-design-questions-settled.md`. The open questions below were resolved: shared-module = equality protocol + contract; value accessor = `#raw` universal / `#mod` Module-only; literal equality = by binding location (`full_name`); `Constant::Module` name kept (`::Module` where Ruby's is meant); `build` = universal factory (the `non_module` error removed); `#constant_names` gains the `include_literal_constants` symmetry; the type model is sequenced before Task 10.

## What prompted it

`#constants` is being extended with an `include_literal_constants:` keyword (default `false`). When `true`, the result also includes **literal constants** (constants bound to non-module values — see the literal-constants terminology rule). A literal can't be mediated the way a module is: a module knows its qualified name (`mod.name`); a literal value does not — its name lives in the binding, not the value. So literals get their own domain type.

## Settled (dictated)

- There is a distinct type **`Constant::Literal`** for literal constants, nested under `Constant`.
- `Constant` (the existing class) is the **module constant**.
- `#constants(include_literal_constants: false)` → module constants only (as `Constant`s). With `true`, literal constants (as `Constant::Literal`) are included too.
- `Constant::Literal` answers the container view **degenerately but truthfully**:
  - `#constants` → `[]` (a literal contains no inner constants)
  - `#defined?(...)` → `false` (nothing is defined within a literal)
- This keeps the returned list **uniform** — every element answers the full interface — rather than heterogeneous.

## The interface split (the rationale)

- **Binding view** (every constant): `#name`, `#full_name`, `#namespace`, the bound value, value-equality.
- **Container view** (a constant that is itself a namespace): `#constants`, `#constant_names`, `#defined?`. `Constant::Literal` implements these degenerately.

## Direction (likely) — `Constant` morphs from a class into a mixin module

`Constant` will likely stop being the module-mediating *class* and become a **mixin module** carrying the shared binding behavior, **included into two concrete classes**:

- `Constant::Module` — the **module constant** (inherits today's `Constant` behavior: mediates a module, derives name/namespace from `mod.name`, real `#constants`/`#defined?`).
- `Constant::Literal` — the **literal constant** (binding from a supplied name + namespace; degenerate `#constants` → `[]`, `#defined?` → `false`).

The shared `Constant` module would hold the common algorithms expressed in terms of subtype-provided primitives (template-method style) — e.g. `==`/`eql?`/`#hash` over a subtype key, possibly `#full_name` as `namespace`+`name` — while each subtype supplies its own derivation source.

## Open questions

- **Public API migration (the big one).** Today `Constant.new(mod)`, `Constant.build`, and `Constant.defined?` are the surface. If `Constant` becomes a module, `Constant.new` is gone (a module can't be instantiated). Where do these go? Candidate: `Constant.build(value)` becomes a **factory** that inspects the value and returns a `Constant::Module` or `Constant::Literal`; direct construction is `Constant::Module.new(mod)` / `Constant::Literal.new(value, name, namespace)`. `Constant.defined?` (class predicate) and `Constant.name`/`Constant.namespace` (static helpers) also need rehoming. This is a **breaking change** to the published surface — acceptable only because the `Constant` class is newly introduced by this very plan.
- **What the mixin actually contains.** The two subtypes share little raw code (each derives binding queries from different sources), so the module is mostly the common algorithms + the interface contract. Confirm it earns its keep vs. duck typing.
- **`Constant::Module` naming.** `Constant::Module` shadows the conceptual "Module" within the namespace — confirm the name reads right (it is unambiguous as `Constant::Module`, but worth a deliberate check).
- **Construction.** `Constant::Literal` can't derive its name from its value — built with name + namespace, discovered by `#constants` from the container. Initializer shape?
- **Value accessor.** `#mod`/`#raw` — "mod" is a misnomer for a literal. `Constant::Literal` exposes `#raw` (the raw value); does the `#mod` reader become `Constant::Module`-only?
- **Equality.** How two `Constant::Literal`s compare — by value, by (namespace, name), by binding identity?
- **`#constant_names` (Task 11)** and the `include_literal_constants` symmetry there.
- **Sequencing.** This type-model redesign now precedes Task 10's implementation; the design doc needs updating and Tasks 10–11 re-scoping before code.
