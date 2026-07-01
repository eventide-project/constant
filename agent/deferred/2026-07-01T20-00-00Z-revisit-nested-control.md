# Revisit `Controls::Constant::Nested` — it may be doable with the base control

`Controls::Constant::Nested.example(inner_name:, leaf_name:, leaf_value:)` was
added to build a genuinely-nested `NS::Inner::leaf` (the inner module first-bound
inside its parent so Ruby assigns it the nested name). But the base
`Controls::Constant.example` may already be able to express this — or be extended
to, more cheaply than a dedicated helper.

**Angle to explore:** the base `example`'s `inner_constants:` already takes a Hash
(`{name => value}`). If it recursed — a Hash *value* treated as a further nesting
level, e.g. `example(inner_constants: { "Inner" => { "Leaf" => "some string" } })`
→ `NS::Inner::Leaf` — then the nested structure would come from the base control
and `Controls::Constant::Nested` could be **dropped**, with the nested-path tests
switched over. Confirm the recursion still binds each inner module *inside its
parent first* (so the nested `.name` is correct), which is the one subtlety the
dedicated helper currently guarantees.

**Also reconsider here:** the `leaf_value` parameter name (reads literal-ish though
it accepts a module too) — moot if the helper is dropped; otherwise rename to
something kind-neutral (e.g. `leaf`).

**Why:** fewer controls surfaces to maintain; a single `example` that composes to
any depth is more soluble than a separate helper per nesting shape.

**How to apply:** try expressing the nested-path fixtures with the base control
(extending `inner_constants:` to recurse if needed); if it works and reads well,
drop `Controls::Constant::Nested` and update `module/get/nested_*.rb` and
`get/nested.rb`; keep the suite green. Delete this file and add an `agent/log/`
entry.
