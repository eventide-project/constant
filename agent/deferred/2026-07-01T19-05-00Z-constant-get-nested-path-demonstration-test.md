# Additional `Constant.get` test demonstrating nested-path use

The nested-path recursion is implemented in the instance `Constant::Module#get`,
and its outcomes are witnessed there (`test/automated/constant/module/get/`).
`Constant.get` (the class-level entry point) inherits path support by delegating
to the instance primitive.

Add an **additional test at the `Constant.get` level** that demonstrates the
nested-path use directly — e.g. `test/automated/constant/get/nested.rb` exercising
`Constant.get("Foo::Bar::Baz", namespace)` — so the public entry point the feature
was requested against is shown resolving a path, and the delegation is guarded.

**Why:** the instance tests prove the behavior where it lives; a class-level test
documents and protects the entry point callers actually use (`Constant.get`), and
would catch a regression in the delegation even if the primitive stays correct.

**How to apply:** once the instance recursion is built and green, add the
`get/nested.rb` demonstration test (module-valued or literal-valued path, whichever
reads best as the canonical example); keep the suite green. Delete this file and
add an `agent/log/` entry.
