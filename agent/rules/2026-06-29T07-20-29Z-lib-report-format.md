# "Lib report" classifies the library source by category

When the human asks for a **lib report**, classify the library source (`lib/`) along the axes below — a category analysis paralleling the test report. **Re-derive everything from the current files** — read the source and recompute membership; do not report stale buckets from memory. The framework below is the discovered shape as of this rule's writing; the library evolves, so treat the axes as the lens and recompute what falls where. Do not write the rendered report to a file — it is printed output only.

Produce these sections, in order:

1. **By role / layer** — package wiring (pure `require` files, e.g. `constant.rb`, `controls.rb`); the domain object (`constant/constant.rb`, the `Constant` class); operations (`define.rb`, `import.rb`, `import/macro.rb`); infrastructure (`log.rb`); test support (`controls/constant.rb`).

2. **By Ruby construct** — the stateful **class** (`Constant`, plus the `Log` subclass); **module-function namespaces** that carry behavior through `self.` methods (`Define`, `Import`, `Controls::Constant`); **mixin modules** (`Import::Macro`, extended into receivers; and `Import`'s own `included` hook).

3. **By method style** — instance methods on `Constant` (operate on the mediated `mod`); class/module functions (`self.`); macro/hook methods; and the **dual class+instance delegation pairs** (`Constant.name`/`#name`, `Constant.namespace`/`#namespace`, where the instance method delegates to the class method with its own `mod`).

4. **By API currency (what methods take and return)** — methods trading in **raw modules** (`Define`, `Import`, the macro — the legacy currency); methods returning **`Constant` objects** (`build`, `namespace` — the new currency); methods returning **Strings** (`name`, `full_name` — the string-outputs convention); **predicates** returning booleans (`defined?`, `==`, `eql?`). This is the surface the import-negotiate deferred question targets.

5. **Error taxonomy** — the applicative error classes (`Constant::Error`, `Constant::Import::Error`), both `Class.new(RuntimeError)` per the applicative-errors-extend-`RuntimeError` convention; note which operations raise which.

6. **Idioms / conventions visible** — e.g. the `Initializer` mixin (`initializer :mod`); the `__`-prefix-then-`alias` shadow-preservation pattern (`alias __name name` to keep `Module.name` reachable; `__import_constant`/`import`; `alias raw mod`); `if not` over `unless`; absence of the safe-navigation operator.

Keep each section tight.

**Why:** the library has a discoverable structure — layers, construct kinds, and an API-currency split (raw modules vs. `Constant` objects) that frames the import-negotiate question — worth surfacing on demand. Fixing the report's shape makes it repeatable and steers reading to the source rather than recollection.

**How to apply:** on a lib-report request, read `lib/` and render the six sections from current state, confirming membership by reading the files rather than asserting it. Companion to the test-report rule (`agent/rules/2026-06-29T07-15-32Z-test-report-format.md`); neither report is written to a file.
