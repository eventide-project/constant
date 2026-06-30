# Loop record — Constant#get and the build/new construction interface

Recorded live. This feature started as "normalize a literal's name to a String"
and, through the loop, turned into the construction interface: `build`
(forgiving constructor) over `new` (strict initializer), and a `#get` resolution
primitive. Several passes were chat (no options) that produced new conventions.

---

## Pass 1 — Where does the `.to_s` normalization live? *(chat)*

**Hinge:** a `Constant::Literal` built from a Symbol name would have a Symbol
`#name`, breaking String-outputs.

**Chat:** the AI proposed normalizing in `build`. The developer asked why the AI
claimed `#constants` doesn't go through `build`; the AI conceded it *could* (an
open Task 6 choice) and that the real case for normalizing inside the literal was
independence from that decision.

**Decision (dictated):** add a `build` **constructor** to each subtype that
**normalizes inputs and delegates to the strict `new`** — `Constant::Literal.build`
coerces the name, `Constant::Module.build` for symmetry. Recorded as a rule.

## Pass 2 — The construction interface shape *(chat → re-grounding)*

**Hinge:** what `build` receives.

**Chat:** the AI over-built `Literal.build(name, value, namespace)` and tangled
the namespace into normalization; the developer re-grounded: "the construction
interface receives a name or a Ruby constant." The AI confirmed the model —
`build` resolves and normalizes, `new` is strict on resolved pieces — and noted
a literal can only be built by *name* (its value isn't self-describing).

## Pass 3 — Introduce `#get` *(chat → untangles the architecture)*

**Hinge:** the AI wrote `namespace_constant.value.const_get(...)` — reaching into
raw Ruby internals the library exists to absorb.

**Chat:** the developer asked whether `Constant::Module` should have a `#get`
(and `Constant::Literal` too). The AI affirmed: `#get` is the resolution
primitive; with it owning resolution, the subtype `build`s go back to the 3-arg
normalizing constructors (resolution in `#get`, not `build` — the knot).

**Decisions (dictated):** `#get` **returns a Constant**; **raises** when not
found. `Constant::Literal#get` exists but is degenerate (a literal contains
nothing).

## Pass 4 — Drive `Constant::Module#get` (3 outcomes)

- **module** → a `Constant::Module` mediating the resolved inner module.
- **literal** → a `Constant::Literal` mediating the resolved inner literal
  constant.
- **undefined** → raises `Constant::Error`.

## Pass 5 — Naming *(chat → a new convention)*

The module/literal outcomes: **"Is a Constant mediating the resolved inner
module"** / **"… inner literal constant"** (named tests). For the error outcome,
the developer set a convention: an `assert_raises` test is named exactly **"Is an
error"**, and its condition is promoted to a **context** ("When the name is not
defined"). Recorded as a rule.

---

**Outcome (so far):** `Constant::Module#get` resolves an inner constant to the
right Constant subtype, raising on undefined; `Module.build`/`Literal.build`
constructors exist. Suite green (57). Still to come this feature: the `.to_s`
normalization (driven by its own test), `Constant::Literal#get` (degenerate), and
wiring `Constant.build` to delegate to `#get`.
