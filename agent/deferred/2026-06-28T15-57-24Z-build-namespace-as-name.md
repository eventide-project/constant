# `build`'s namespace parameter should also accept a namespace name (String), not only a raw constant

Make `Constant.build`'s second parameter polymorphic, mirroring the first. Today it takes only a raw constant (a module/class) as the namespace; it should **also accept a namespace name as a String**, which `build` resolves to its raw constant. Rename the parameter `namespace` → **`namespace_name_or_raw_constant`**. The signature becomes symmetric:

```ruby
def self.build(name_or_raw_constant, namespace_name_or_raw_constant = Object, inherit: false)
```

e.g. `build("Child", "Parent")` resolves `"Parent"` to the `Parent` module, then resolves `"Child"` within it.

**Gated on:** finishing the in-progress defaulted-namespace outcome.

**Open questions to settle at its hinges (do not pre-decide):**
- How the namespace *name* resolves — assume top-level (against `Object`), the same way the first name resolves *within* the namespace. Confirm.
- Whether `inherit` applies to the namespace resolution as well as the first-name resolution.
- The error cases for the namespace name (undefined; resolves to a non-module value) — likely the same `Constant::Error` shape as the first-name arm.
- Likely implementation: resolve `namespace_name_or_raw_constant` to a raw constant first (reuse the `is_a?(Module)` discriminator / the same resolution path), then proceed as today.

**Process:** run a fresh four-hinge cycle (actuation → assertion → controls → implementation), one outcome at a time. Then delete this file.
