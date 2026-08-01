# Loop record — Import literal constants

`Constant::Import` copies a literal constant as readily as a module, and no test said so.
This records the passes that covered it. The feature's lifecycle is
`waytide/local/features/2026-08-01T22-34-47Z-import-literal-constants.md`.

Written live.

## Pass 0 — whether there was anything to test

**Hinge** — the deferred item asked whether copying literals is intended or incidental, and
proposed covering it. The developer challenged the premise: *is there significant behavioral
drift between implementing a module constant test and a literal constant test?*

**Options** — resolve the item as transparent and write no test; keep only the design
question of whether `Import` should restrict itself to modules; or restrict `Import`.

**Decision / chat** — the challenge was **correct on its own terms**. Reading
`Constant::Import.call`, the imported value appears exactly three times — read with
`const_get`, written with `const_set`, returned. Nothing branches on what it is; the only
`is_a?(::Module)` in the file tests the destination. A literal traverses byte-identical code,
so a test asserting that a literal survives `const_set` asserts Ruby's indifference, which
`do-not-test-the-platform` forbids. That was put to the developer along with the resolution
it implied.

The developer then **reframed rather than accepted it**: *consider a shallow test with just
enough coverage to prove that the literal and module constants are imported.* That is a
different claim, and it is the library's — `origin_constant.constants(inherit)` is a
**selection** `Import` makes, which could have been narrowed to modules. The platform
objection had been aimed at the wrong sentence.

**The distinction that resulted:** "a literal survives `const_set`" is the platform's;
"`Import`'s scope is every constant the source owns, whatever kind" is the library's. The
second is what the test states.

## Pass 1 — actuation

Not gated. `import_constant.rb` actuates the function with two arguments and this test does
the same; no second candidate existed.

## Pass 2 — observation

**Hinge** — whether the literal outcome reads only that the name is defined, or also that it
holds the value the source held.

**Decision / chat** — the developer asked **whether literal constant values are tested
anywhere else**. They are, repeatedly: `define_constant/literal.rb` asserts a defined literal
equals the value it was given, `constant/module/get/literal.rb` asserts a resolved
`Constant::Literal` carries its value, thirteen tests use the control's Hash form and twenty
mention literals. So the value round-trip is covered, and reading it here would re-prove it
on a path where `Import` contributes nothing to it. **Definedness of both names**, which is
also exactly what discriminates a module filter.

## Pass 3 — controls, and the scope widening

**Hinge** — the controls are a source owning one of each kind and an empty destination,
using the established `control_module_inner_name` / `control_literal_inner_name` pair. What
was open is whether the feature also covers the **refusal** side.

**Why it was raised:** all three existing collision tests build their destination with the
control's Array form, which binds `::Module.new` to every name. So every collision the suite
covers is module against module, and whether a *literal* name on the destination refuses an
import is untested. The check reads no value, so it presumably does — but a value-aware
change would pass everything.

**Decision / chat** — **widen it**, adding an exceptional-path file. `literal/` becomes a
folder, per the normal-path-and-exceptional-paths convention.

Asked which control the collision file should use, the developer asked **which is
preferable** rather than choosing, and the recommendation was given with its reason: a
literal on **both** sides, because a value-aware check can require a module on either side
and only the both-literals case catches both. A module on the destination would miss a check
requiring the destination's existing value to be a module, since it is one.

## Pass 4 — implementation

**Degenerate**, the behavior already existing. The hinges still gated the test's design, per
the hinges-gate-coverage rule, and the implementation hinge reduced to running it.

**Solubility was judged against a deliberate break rather than asserted.** A
`select { … .is_a?(Module) }` was added to the name set, the suite run, the literal outcome
observed failing while the module outcome passed, and the change backed out. The test
protects what it claims to.

## Pass 5 — naming

`Module constants are imported` and `Literal constants are imported`. The exceptional path's
outcome was named `Fails` under a
`When the destination already defines the literal constant` context when it was written, the
error-test rule fixing the name and `collision.rb` having set the condition-context shape.

## Outcome

`test/automated/import_constant/literal/literal.rb` and
`test/automated/import_constant/literal/collision.rb`. Three outcomes, all green on arrival,
which is correct when protecting behavior rather than designing it. The suite moves from
**114 to 117 tests**. The library is unchanged.

---

Authored by Scott Bellware on Sat Aug 1 2026 at 3:52:18 PM PT
