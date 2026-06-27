# Add `Constant#==` value equality comparing the underlying raw constants

`Constant` should define `==` so that two `Constant` instances are equal when they wrap the same underlying raw constant — i.e. compare `raw_constant`. Today `Constant` has only identity equality (`Constant.new(Object) == Constant.new(Object)` is `false`), which forces tests on `Constant`-returning methods (e.g. `namespace`) to reach into `.raw_constant` to assert.

**Gated on:** the current `namespace` feature being settled.

**Why:** the user wants `Constant` to behave as a value object over its raw constant, so equality compares the wrapped constants. This lets efferent use — and the tests — compare `Constant`s directly (`namespace == Constant.new(control_module)`) instead of unwrapping.

**How to apply:** define `==` on `Constant` comparing `raw_constant`; consider `eql?` + `hash` for hash-key parity (decide whether that's in scope). Then simplify the `namespace` tests to assert `namespace == Constant.new(control_module)` and `== Constant.new(Object)` instead of `.raw_constant ==`. Then delete this file.
