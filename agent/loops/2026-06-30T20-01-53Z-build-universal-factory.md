# Loop record — Constant.build universal factory (restructure Task 5)

Recorded live. The passes through the loop for making `Constant.build` dispatch
a resolved value to the right subtype — a name resolving to a literal now yields
a `Constant::Literal`, and the `non_module` error is removed.

---

## Pass 1 — Actuation + placement *(no gate)*

**Hinge:** the actuation is the existing `Constant.build(name, namespace)`; the
change is the *outcome*. `build/non_module.rb` ("Raises … non-module value")
becomes `build/literal.rb` (literal terminology), now asserting a returned
`Constant::Literal` instead of a raised `Constant::Error`.

**Options / decision:** none — the actuation shape is unchanged, so nothing
forked; the rename + behavior change follow from the settled design.

## Pass 2 — Assertion

**Hinge:** how to witness that `build` returned the right `Constant::Literal`,
given literal equality is by binding location (so equality ignores the value).

**Options:** equality only (one outcome — proves the binding, not the value) /
**equality + value** (two outcomes — also `constant.value == control_value`).

**Decision:** **equality + value** — two outcomes.

## Pass 3 — Test structure *(chat → a new convention)*

**Hinge:** whether each named outcome needs a `context` block.

**Chat:** the developer asked *"does it require a context block around the test
block?"* The AI showed that TestBench allows a directly-named `test "…" do`
(used by the legacy `Import` tests) as well as the Constant-class
`context "…" do test do … end end`. The developer set the convention: **a
context is justified only when the outcome needs local instrumentation** (an
explaining variable derived for it, or a `comment`/`detail` specific to it); a
single assertion over in-scope values is a directly-named test, no context.

**Decision:** recorded as a rule; `build/literal.rb`'s two outcomes are
**named tests, no context**. (Existing over-wrapped tests deferred for conforming.)

## Pass 4 — Implementation *(chat → accept, with a follow-up deferred)*

**Hinge:** the `build` branch — resolve the name, then dispatch on the value
(module → `Constant::Module`, else → `Constant::Literal`); remove the
`non_module` error.

**Chat:** the AI flagged that it was *not* normalizing the literal's name with
`.to_s` — untested (the test uses a String name), and best driven where it
becomes load-bearing: Tasks 6–7 mint literals from `mod.constants` (Symbols) and
`#constant_names` must return Strings.

**Decision:** the developer **accepted the implementation as-is** and queued the
`.to_s` normalization as the **next** outcome to drive.

## Pass 5 — Naming

Two named-test outcomes (via options): **"Is the literal constant the name
resolves to"** and **"Is the value the name resolves to."**

---

**Outcome:** `Constant.build` is the universal factory; the `non_module` error is
removed; `build/literal.rb` has two named-test outcomes. Suite green (54).
