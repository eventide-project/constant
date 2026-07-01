# Loop record — instance `Constant#defined?` (Task 8)

> **Backfill** — reconstructed retroactively from memory after the work, not
> captured live. Lossier than a live record; some passes/detail may be missing.

Feature: an instance predicate `Constant#defined?` reporting whether an argument
is defined within the mediated module. (Predates the mixin restructure, so it
lived on the `Constant` class; the behavior later moved to `Constant::Module`.)

---

## Pass 1 — Actuation, and a challenge to the feature's purpose

**Hinge:** the efferent shape of the instance predicate.

**Options / chat:** the AI first mis-presented the gate (controls bled in, hinges
bundled); the developer corrected the presentation. Then the developer
challenged the feature itself — *"what is its purpose?"* — and the AI gave an
honest read: the design-doc framing (`#defined?(in: namespace)`, instance as the
thing looked for) was a speculative collision-check primitive with no present
consumer. Offered: defer / drop / build-as-specified / **rework purpose**.

**Decision:** the developer chose **rework**, then dictated the semantics: the
predicate receives a **name or a Ruby module** and reports whether it is defined
**within the module the instance mediates** (the instance is the *namespace
searched*, not the thing looked for).

## Pass 2 — Module-argument semantics

**Hinge:** what a *module* argument means.

**Options:** name-existence (reduce the module to its name, check presence) vs.
**identity/containment** (the exact module must be nested within).

**Decision:** **identity/containment** — `Foo::Bar` counts only if that exact
module object is nested in the mediated module.

## Pass 3 — `inherit` and placement

**Hinge:** signature + test layout. **Decision (dictated):** support an
`inherit` keyword (default `false`); lay the tests out **nested-by-receiver** —
`defined_predicate/class.rb` plus `defined_predicate/instance/{name,module}/`.

## Pass 4 — Name scenario: assertion, controls, implementation

- **Assertion:** `assert(defined)` (chosen over `assert(defined == true)`).
- **Controls:** module-valued vs **literal-valued** inner constant. After the
  developer asked *what changes for the literal option* (answer: nothing — the
  Hash control form already exists, and `const_defined?` is type-agnostic), the
  developer chose the **literal-valued** inner.
- **Implementation:** minimal (name-only delegation) vs branch-now. **Decision:**
  **minimal** — add the module branch when its outcome is driven.

## Pass 5 — Module scenario: outcome set

**Hinge:** which module outcomes to drive, given only the refuting one
discriminates identity from name-existence.

**Options:** Both / Refuting only / Affirming only.

**Decision:** **Both** — affirming (nested module → true) and the discriminating
refuting (a different module sharing a nested constant's name → false).

## Pass 6 — Naming (feature close)

Name-scenario outcome dictated: **"Affirms a constant defined in the mediated
module by name."** Module outcomes (via options): **"Affirms a module nested in
the mediated module"** and **"Refutes a module not defined in the mediated
module."**

## Pass 7 — Name refute (green-on-arrival, added on request)

**Hinge:** the developer asked for a refute case in the name scenario. **Chat:**
the AI flagged it as **green-on-arrival** (`const_defined?` already returns false;
Task 7 dropped the identical class-predicate outcome). **Options:** skip / add
anyway. **Decision:** **add anyway** — a deliberate, logged green-on-arrival
exception for symmetry/documentation.

---

**Outcome:** `Constant#defined?` taking a name (name-existence) or module
(identity); `inherit` threaded; four outcomes named, suite green. Committed
`ec0120e`, `3c67bcf`.
