# `comment` lines that print a control value should start with "Control ..."

A test `comment` that prints a **control** value should label it with a "Control " prefix. E.g. `comment "Namespace Name: #{control_namespace_name.inspect}"` → `comment "Control Namespace Name: #{control_namespace_name.inspect}"`.

The prefix marks that the printed value is a control (a known, set-up reference), parallel to the `control_` variable prefix. Comments that print a value that is **not** a control — e.g. the actuation result (`comment "Constant: #{constant.inspect}"`) — are left unprefixed.

**Scope:** the `Constant`-class tests under `test/automated/constant/` (build/, namespace/, name/, full_name, equality/). The `import_constant/` tests already use the "Control ..." form in places; reconcile for consistency if swept. This pairs with the namespace-variable-suffix reconciliation and the broader control-naming sweep.

**Process:** a mechanical pass over the `comment` lines; keep the suite green. Then delete this file.
