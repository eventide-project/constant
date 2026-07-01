# Loop record — Constant::Module#constant_names (restructure Task 7)

Recorded live. The inner-constant *names* query — parallel to `#constants`, but
returning name Strings.

---

## Pass 1 — Actuation + placement *(no gate)*

`constant.constant_names(include_literal_constants:, inherit:)`; tests under
`constant/module/constant_names/`. Shape dictated by the plan and the `#constants`
parallel.

## Pass 2 — Outcome 1: default, module names only

**Hinge:** same discriminating control as `#constants` (a module inner + a literal
inner); default `#constant_names` returns just the module inner's name — as a
**String** (`constant_symbol.to_s`), excluding the literal. Assertion
`constant_names == [control_module_inner_name]` pins the selection, the String
normalization, and the exclusion.

**Implementation:** mirrors `#constants` — `filter_map` over `value.constants`,
`const_get` each, return `constant_symbol.to_s` for modules. Per the efficiency
choice from Task 6, it returns names **without constructing any Constant
objects**.

## Pass 3 — Outcome 2: include literals

**Hinge:** `include_literal_constants: true` also returns the literal names.
Simplified to one condition: `if resolved.is_a?(::Module) || include_literal_constants`
(a module name always, a literal name only when included). Assertion
`constant_names == [module_name, literal_name]`.

## Pass 4 — Naming

Two named-test outcomes (via options): **"Is the names of the module inner
constants"** and **"Is the names of the module and literal inner constants."**

---

**Outcome:** `Constant::Module#constant_names` returns its module inners' names as
Strings, plus the literal names when included — 1:1 with `#constants`, built
without allocating Constant objects. Suite green (64).
