# Loop record — the Constant::Literal type design

> **Backfill** — reconstructed retroactively from memory after the work, not
> captured live. Lossier than a live record; some passes/detail may be missing.

Feature: the design (no code) that settled how literal constants enter the
model — culminating in `Constant` becoming a mixin module included by
`Constant::Module` and `Constant::Literal`. Recorded in design-doc Section 5.

---

## Pass 1 — Should literals be included at all?

**Hinge:** the developer proposed an `include_literal_constants:` keyword
(default false) on `#constants`. **Chat:** the AI surfaced the consequence — the
list currently holds `Constant` objects; a literal can't be mediated like a
module (its name lives in the binding, not the value), so *how is a literal
represented?* Options weighed: expand `Constant` to mediate any value / raw value
/ name string.

**Decision (dictated):** the instance receives a name or module and reports
within the mediated module; and — pivoting to representation — literals get their
own type.

## Pass 2 — Subtypes, and the degenerate container

**Hinge:** does the design need distinct subtypes for module vs literal
constants? **Chat:** the AI laid out the binding-view (shared) vs container-view
(module-only) split.

**Decision (dictated):** `Constant::Literal` is a distinct type that answers the
container view **degenerately but truthfully** — `#constants` → `[]`,
`#defined?` → `false`.

## Pass 3 — The type relationship

**Hinge:** subclass / shared base / independent? **Options** offered. **Decision
(dictated):** `Constant` **morphs into a mixin module** included by
`Constant::Module` and `Constant::Literal`.

## Pass 4 — The value accessor

**Hinge:** the bound-value reader across subtypes. The AI first settled
`#raw` universal + `#mod` Module-only. **Decision (dictated):** rename to
**`#value`** as the sole accessor on both subtypes (a module *is* the value of a
module constant; a literal *is* the value of a literal constant) — no `#mod`, no
`#raw`.

## Pass 5 — The three forks (gated together)

**Hinges:** (a) `Constant::Module` name vs the Ruby `Module` shadow; (b) does
`build` produce literals; (c) literal equality.

**Options / decisions:**
- **Name:** keep `Constant::Module` (write `::Module` where Ruby's is meant).
- **build:** **universal factory** — a name resolving to a literal yields a
  `Constant::Literal`; the `non_module` error is removed.
- **Equality:** **by binding location** (`full_name`) — `Foo::Bar` ≠ `Baz::Bar`.

## Pass 6 — Sequencing

The type model is built **before** the `#constants` work; Tasks 10–11 re-scope
around it. A dedicated restructure plan was written.

---

**Outcome:** design-doc Section 5 (the intended direction, settled). Committed
`70d11e2`, `32e088c`; restructure plan `f9bdf71`.
