# Move the name/namespace calculation into static methods that receive a raw_constant

The computation behind `Constant#name` and `Constant#namespace` should live in **static (class) methods** that take a `raw_constant` argument — e.g. `Constant.name(raw_constant)` and `Constant.namespace(raw_constant)` — with the instance methods delegating to them (passing their own `raw_constant`).

**Gated on:** the current outer-namespace-constant feature being settled.

**Why:** the user wants the calculation expressed as static methods receiving a `raw_constant`, so the logic is callable without constructing an instance and the instance methods become thin delegators.

**How to apply:** extract the `rpartition("::")`-based calculations into class methods taking `raw_constant`; have `#name`/`#namespace` (and the new outer-constant method) delegate. Keep the tests green; consider whether the static methods warrant their own efferent tests. Then delete this file.
