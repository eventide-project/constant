# Loop record — Constant::Module#constants (restructure Task 6)

Recorded live. The passes through the loop for `Constant::Module#constants` — the
inner-constant query, with `include_literal_constants`.

---

## Pass 1 — Actuation + placement *(no gate)*

**Hinge:** the actuation is `constant.constants(include_literal_constants:,
inherit:)`; tests under `constant/module/constants/`. Shape dictated by the plan;
nothing forked.

## Pass 2 — Outcome 1: default excludes literals

**Hinge:** the discriminating control — a namespace with **both** a module inner
and a literal inner, so the default `#constants` returns only the module inner
(proving both that modules come back and that literals are excluded). Assertion:
`constants == [control_module_constant]`.

## Pass 3 — Efficiency *(chat)*

**Chat:** the AI first proposed map-every-inner-via-`#get`-then-`select`. The
developer asked whether filtering the non-module Ruby constants *before*
constructing `Constant` instances performs better. The AI confirmed: yes — it
avoids allocating `Constant::Literal` objects that are then discarded (the
default case). Tradeoff: `#constants` does its own `const_get` + type dispatch
(not via `#get`, which wraps unconditionally and runs a redundant
`const_defined?`), a small duplication of the dispatch.

**Decision:** use the `filter_map` version **as-is** (no extracted shared helper).

## Pass 4 — Outcome 2: include literals

**Hinge:** `include_literal_constants: true` also returns the literal inners (as
`Constant::Literal`). Added the `elsif include_literal_constants` branch to the
`filter_map`. Assertion: `constants == [module_constant, literal_constant]`.
(Inherited-excluded-by-default is green-on-arrival — `value.constants(false)`
already excludes them — so not driven.)

## Pass 5 — Naming

Two named-test outcomes (via options): **"Is the module inner constants"** and
**"Is the module and literal inner constants."**

---

**Outcome:** `Constant::Module#constants` returns its module inners, plus the
literals when `include_literal_constants: true`, filtering before constructing.
The `Module`/`Literal` `#constants` asymmetry is resolved. Suite green (62).
