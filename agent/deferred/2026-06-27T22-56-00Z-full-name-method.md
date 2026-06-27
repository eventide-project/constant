# Add a `Constant#full_name` method returning the fully-qualified constant name

`Constant` should expose `full_name` returning the **whole qualified name** as a String — the full path including all enclosing namespaces (e.g. `"Some::Nested::Thing"`) — where the existing `#name` returns only the final segment (`"Thing"`). It is `raw_constant.name` in full; for a top-level constant `full_name == name`.

**Gated on:** the current task being settled.

**Why:** the user wants the qualified name available directly, not only the leaf segment. `#name` deliberately returns the final segment; `full_name` is the complementary whole-path accessor.

**How to apply:** implement `full_name` as `raw_constant.name` (a String — consistent with the outputs-are-Strings convention). Build it test-first through the gates one outcome at a time: a nested constant (asserts the full `::`-qualified path) and a top-level constant (where `full_name == name == raw_constant.name`). Decide at the actuation gate whether the name is `full_name` (vs `qualified_name`). Consider whether the `rpartition("::")` calculation in `#name`/`#namespace` should be expressed in terms of `full_name` (relates to the deferred static-methods item). Then delete this file.
