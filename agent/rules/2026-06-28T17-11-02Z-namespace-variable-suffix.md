# Suffix a namespace (and constant) variable by what it holds: raw constant (bare), name (`_name`), or Constant (`_constant`)

A variable naming a namespace — and by extension any constant-ish control — carries a suffix that says **which form of the thing it holds**, consistently throughout the code:

| Holds | Suffix | Example |
|---|---|---|
| a **raw constant** (Module / Class) | *(none — bare)* | `control_namespace` |
| a **name** (String) | `_name` | `control_namespace_name` |
| a **`Constant`** object | `_constant` | `control_namespace_constant` |

So the three forms of one namespace are `control_namespace` (the module), `control_namespace_name` (its name), `control_namespace_constant` (it wrapped in a `Constant`). The bare name is the raw constant; the suffix marks the name or the wrapped form.

**Expected operands are controls.** A value an assertion compares against — e.g. `Constant.new(control_namespace)` extracted out of the `test` block — is a **control** (a known, deterministic reference), so it takes the `control_` prefix, never an `other_` prefix. `other_constant`/`other_namespace` were mis-named; they are `control_constant` / `control_namespace_constant`. The `control_` prefix names the variable's *nature* (a control); `other_` named only its incidental *position* (the other operand). The thing **under test** (the actuation result) stays unprefixed (`constant`, `namespace`), so the assertion reads as output-vs-control.

**Why:** With the `Constant` library, the same namespace appears as a module, a name, and a `Constant` within one test; an unsuffixed `control_namespace` everywhere would be ambiguous about which form is in hand. A consistent suffix makes the type legible at every use and forces the writer to be clear about which form an argument or assertion operand is. Builds on the `control_` test-variable prefix rule (controls get `control_`) and the test-block-is-assertion-only rule (operands are explaining variables in the context).

**How to apply:** When a control holds a namespace or constant, suffix it `_name` (String name), `_constant` (`Constant` object), or leave it bare (raw module/class). Extracted expected operands are controls — `control_`-prefix them by the form they hold. Keep the under-test result unprefixed. Related: the `control_` test-variable prefix rule, the test-block-is-assertion-only rule, and the no-inline-method-call-arguments rule.
