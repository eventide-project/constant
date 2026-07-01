# Loop record — Constant::Literal #full_name (restructure Task 2)

> **Backfill** — reconstructed retroactively from memory after the work, not
> captured live. Lossier than a live record; some passes/detail may be missing.

Feature: `Constant::Literal` construction `(name, value, namespace)` and the one
computed binding query, `#full_name` (the others — `#value`/`#name`/`#namespace`
— are mechanical `initializer` readers, untested by convention).

---

## Pass 1 — Actuation + placement

**Hinge:** the AI noted `#value`/`#name`/`#namespace` are mechanical readers, so
`#full_name` is the one drivable binding query; actuation `literal.full_name`.
The live decision was **placement**, given the existing `Constant::Module` tests
sat directly under `constant/`.

**Options:** put Literal tests under `constant/literal/` (defer a Module reorg) /
**reorg both now** (move Module tests under `constant/module/`, add `literal/`).

**Decision:** **reorg both now.** (The AI scoped the reorg to the instance
binding/equality tests, leaving `build/` and `defined_predicate/` — which are
`Constant`-module-level, not subtype — at `constant/`.)

## Pass 2 — Include order *(developer-initiated)*

**Hinge:** the order of `include Constant` vs `include Initializer`. **Chat:**
the developer directed that the domain mixin (`Constant`) has more primacy than
the infrastructure mixin (`Initializer`) and should be listed first.

**Decision:** `include Constant` then `include Initializer`; recorded as a
convention and applied to `Constant::Module` too.

## Pass 3 — Nested #full_name (implementation)

**Hinge:** `#full_name` assembles `namespace.full_name` + `name`. No genuine
fork (mirrors the `Constant::Module` full-name test). Implemented; green.

## Pass 4 — Top-level fixpoint

**Hinge:** a literal whose namespace is `Object` should get the name alone, not
`"Object::name"`. **Decision (dictated "drive it"):** detect top-level by
`namespace.value.equal?(Object)`; return `name`. Driven as a second outcome.

## Pass 5 — Naming (feature close)

- Nested: **"Is the namespace-qualified name as a String"** (developer note).
- Top-level: **"Is the name alone for a top-level constant"** (chosen).

---

**Outcome:** `Constant::Literal` with `#full_name` across both topologies; suite
green (48). Committed `279a051`. (The `(name, value, namespace)` initializer
order was set later, in `1d55ae3`.)
