# The `Import` and `Define` test controls are conformed to the module-variable suffix rule

The tests under `test/automated/import_constant/` and `test/automated/define_constant/`
name their controls `origin_constant` and `destination_constant`. Both hold raw
`Module`s, built by `Controls::Constant.example`. Two rules bear on them and neither is
followed:

- The **module-variable suffix rule** (`2026-06-28T17-11-02Z-namespace-variable-suffix`)
  reserves `_constant` for `Constant` instances and gives a raw module the **bare** form.
- The testing package's **`control_` prefix rule** gives a `control_` prefix to any local
  holding a value a control built.

Together they make these `control_origin` and `control_destination`.

## What is in scope

**Test controls only.** The rule was settled on 2026-07-30 as governing test controls, not
implementation locals or method parameters (see
`waytide/local/log/2026-07-30T21-28-46Z-suffix-rule-governs-test-controls-only.md`). So
`Constant::Import.call`'s own parameters and its `import_constant` local are **not** part
of this pass, and neither are result variables in the tests — `defined_constant`,
`returned_constants`, `imported_constant` — which are not controls.

The 14 files carrying the control names:

```
test/automated/define_constant/literal.rb
test/automated/define_constant/module.rb
test/automated/define_constant/symbol_name.rb
test/automated/import_constant/alias.rb
test/automated/import_constant/collision.rb
test/automated/import_constant/except.rb
test/automated/import_constant/import_constant.rb
test/automated/import_constant/instance.rb
test/automated/import_constant/already_included/alias.rb
test/automated/import_constant/already_included/already_included.rb
test/automated/import_constant/macro/alias.rb
test/automated/import_constant/macro/macro.rb
test/automated/import_constant/refinement/instance.rb
test/automated/import_constant/refinement/refinement.rb
```

`refinement/instance.rb` is the file that most needs it: `origin_constant` is a raw
module while `imported_constant` and `origin_inner_constant` are `Constant::Module`
instances, all three carrying the same suffix. That is the ambiguity the rule was written
to prevent, present in one file.

## A second item, unresolved, found alongside it

`Constant::Import` copies **literal constants** as well as module constants — an origin
owning `SomeLiteral = "some value"` has that string assigned onto the destination — and
**no test exercises it**. Whether that warrants coverage is a separate decision from this
renaming, and is not settled here.

**Gated on:** the `import-collision-refusal` feature. Renaming controls across 14 files
while that feature is adding tests to the same directory would put a behavior-neutral
rename in the same diff as new behavior.

**Why:** two binding rules are unobserved across a whole test directory, and one file
carries the exact ambiguity the suffix rule exists to prevent. Conforming in one pass,
after the feature settles, keeps the rename behavior-neutral and reviewable on its own,
rather than spreading it through a feature's commits or leaving the suite carrying two
spellings of the same control.

**How to apply:** once the feature concludes, rename `origin_constant` to
`control_origin` and `destination_constant` to `control_destination` across the 14 files,
leaving implementation locals, method parameters, and non-control result variables alone.
Run the suite to confirm the rename is behavior-neutral. Then delete this file and record
an entry in `waytide/local/log/`. Related: the namespace-variable-suffix rule, the testing
package's `control_` prefix rule, the literal-constants-terminology rule, and the feature
record `2026-07-30T19-48-47Z-import-collision-refusal.md`.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 2:28:46 PM PT
Changed by Scott Bellware on Thu Jul 30 2026 at 2:41:07 PM PT
