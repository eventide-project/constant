# Include the primary domain mixin before infrastructure mixins

When a class includes both a **domain mixin** (the type's defining abstraction —
e.g. `Constant`) and an **infrastructure mixin** (a mechanical capability — e.g.
`Initializer`), list the domain mixin **first**. The domain mixin has more
primacy to what the class *is*; the infrastructure mixin is a supporting
mechanism. Reading order should reflect that priority.

So `Constant::Module` and `Constant::Literal` open with `include Constant`, then
`include Initializer` — not the reverse.

(Ruby requires only that `include Initializer` precede the `initializer` macro
call; the relative order of the two includes is otherwise free, so it is chosen
for primacy/readability, not mechanics.)

**Why:** The order in which includes are listed reads as a statement of what
matters most to the type. Leading with the domain mixin says "this is a
`Constant`, mechanically assembled by `Initializer`," not "this is an
`Initializer` thing that also happens to be a `Constant`." Primacy first.

**How to apply:** In a class that mixes in both, write the domain mixin's
`include` before any infrastructure mixin's. Put the `initializer` (or other
macro) call after the infrastructure `include` it depends on. Related: the
Constant::Literal restructure plan and the namespace/type conventions.
