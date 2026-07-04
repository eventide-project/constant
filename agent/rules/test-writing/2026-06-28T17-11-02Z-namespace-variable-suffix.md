# Suffix a module variable by the form it holds: module (bare), name (`_name`), or `Constant` (`_constant`) — and reserve "constant" for `Constant` instances

Two words, kept distinct:

- **module** — a raw Ruby `Module`/`Class`. This is the base noun for the raw module itself; "raw constant"/"value" are retired. A `Class` qualifies (`Class < Module`) and the term covers both, but in practice the term is exact: the controls only ever build a `Module` (`Controls::Constant.example` returns `Module.new`), and **no test exercises a `Class`** — the implementation is Class/Module-agnostic by construction (`is_a?(Module)` guard, accessors on `Module#name`), so a `Class` test would be green-on-arrival, asserting Ruby's `Class < Module` guarantee rather than driving any design. A `Class` test earns its place only once behavior *distinguishes* a class.
- **constant** — an instance of the `Constant` class. The word "constant" is **reserved** for `Constant` instances and never names the raw module.

A variable for a module — and by extension any module-ish control, e.g. one playing a **namespace** role — carries a suffix that says **which form of the thing it holds**, consistently throughout the code:

| Holds | Suffix | `module` base | `namespace` base |
|---|---|---|---|
| a **module** (raw `Module`/`Class`) | *(none — bare)* | `control_module` | `control_namespace` |
| its **name** (String) | `_name` | `control_module_name` | `control_namespace_name` |
| the **`Constant`** that mediates it | `_constant` | `control_module_constant` | `control_namespace_constant` |

So the three forms of one namespace are `control_namespace` (the module), `control_namespace_name` (its name), `control_namespace_constant` (the `Constant` that mediates it). The bare name is the module itself; the suffix marks the name or the mediating `Constant`.

**Bare `module` is a Ruby keyword — spell it `mod`.** `module = …` is a SyntaxError, so any variable whose bare name would be `module` is spelled **`mod`** instead (e.g. the unprefixed under-test result for a raw module, or a reader accessed bare). "module" is only illegal standing *alone* — decorated forms (`control_module`, `module_name`) are legal and keep the full word. `mod` is the keyword-safe spelling of the bare slot only.

**Expected operands are controls.** A value an assertion compares against — e.g. `Constant::Module.new(control_module)` extracted out of the `test` block — is a **control** (a known, deterministic reference), so it takes the `control_` prefix, never an `other_` prefix. `other_constant`/`other_namespace` were mis-named; they are `control_constant` / `control_namespace_constant`. The `control_` prefix names the variable's *nature* (a control); `other_` named only its incidental *position* (the other operand). The thing **under test** (the actuation result) stays unprefixed (`constant`, `namespace`, `name`, `mod`), so the assertion reads as output-vs-control.

**Why:** With the `Constant` library, the same module appears as a raw module, a name, and a `Constant` within one test; an unsuffixed `control_module` everywhere would be ambiguous about which form is in hand, and an overloaded "constant" would blur the raw module against the `Constant` that mediates it. A consistent suffix makes the form legible at every use, and reserving "constant" for `Constant` instances keeps the two layers distinct. Builds on the `control_` test-variable prefix rule (controls get `control_`) and the test-block-is-assertion-only rule (operands are explaining variables in the context).

**How to apply:** When a control holds a module (or a namespace, or any module-ish value), suffix it `_name` (String name), `_constant` (the mediating `Constant`), or leave it bare (the raw module) — and write `mod` wherever a bare `module` would otherwise appear. Never call a raw module a "constant"; "constant" is a `Constant` instance. Extracted expected operands are controls — `control_`-prefix them by the form they hold. Keep the under-test result unprefixed. Related: the `control_` test-variable prefix rule, the test-block-is-assertion-only rule, and the no-inline-method-call-arguments rule.
