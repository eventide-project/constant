# The Constant control should take its constant-name input as a String, not a Symbol

`Controls::Constant.example` (and `add_inner_constants`) currently receive constant names as Symbols — e.g. tests pass `inner_constants: [:SomeConstant]` and bind `control_inner_constant_name = :SomeConstant`. The input should be a String instead (`"SomeConstant"`).

**Gated on:** the current `Constant#namespace` TDD task being settled.

**Why:** the control's efferent input should be a String rather than a Symbol. (`const_set` accepts both, so this is a convention choice, not a correctness fix.)

**How to apply:** change the control's name input to a String, update the call sites in the namespace and name tests (the `control_inner_constant_name` literals and `inner_constants:` arguments), and adjust any assertion that compares against `.to_s` of the former symbol. Then delete this file.
