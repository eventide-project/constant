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

The 19 files carrying the control names, re-derived 2026-07-31 — the list first written here
named 14 and predated the `except/` and `only/` files the `import-collision-refusal` feature
added:

```
test/automated/define_constant/literal.rb
test/automated/define_constant/module.rb
test/automated/define_constant/symbol_name.rb
test/automated/import_constant/alias.rb
test/automated/import_constant/collision.rb
test/automated/import_constant/import_constant.rb
test/automated/import_constant/instance.rb
test/automated/import_constant/only_and_except_conflict.rb
test/automated/import_constant/already_included/alias.rb
test/automated/import_constant/already_included/already_included.rb
test/automated/import_constant/except/collision.rb
test/automated/import_constant/except/except.rb
test/automated/import_constant/macro/alias.rb
test/automated/import_constant/macro/macro.rb
test/automated/import_constant/only/collision.rb
test/automated/import_constant/only/only.rb
test/automated/import_constant/only/undefined.rb
test/automated/import_constant/refinement/instance.rb
test/automated/import_constant/refinement/refinement.rb
```

Re-derive it again before starting rather than trusting this list; it has already gone stale
once.

`refinement/instance.rb` is the file that most needs it: `origin_constant` is a raw
module while `imported_constant` and `origin_inner_constant` are `Constant::Module`
instances, all three carrying the same suffix. That is the ambiguity the rule was written
to prevent, present in one file.

## This item cannot be applied on its own

`2026-08-01T02-57-18Z-tests-say-source-rather-than-origin` renames the same identifier —
`origin_constant` — to **`source`**, where this item renames it to **`control_origin`**.
Applied in sequence they would produce `control_origin` and then `control_source`, editing
every affected file twice for one net change.

**The two are one rename with a common target, `control_source`**: the `control_` prefix and
bare form from the suffix rule, the word from that item. Read it before starting this one.
Whichever is taken up first carries out both, and both files are then deleted together.

That item reaches further than the identifiers this one covers: the five `context` and
`test` titles carrying the word, and the `"Origin"` and `"SomeOrigin"` strings given to the
control. It also settles that **`destination` does not change** — so this item's
`control_destination` stands as written, and only its `control_origin` becomes
`control_source`.

## A second item, unresolved, found alongside it

`Constant::Import` copies **literal constants** as well as module constants — an origin
owning `SomeLiteral = "some value"` has that string assigned onto the destination — and
**no test exercises it**. Whether that warrants coverage is a separate decision from this
renaming, and is not settled here.

**Start with `2026-08-01T05-44-31Z-the-import-test-vocabulary-is-settled-first`**, which
orders this item against the others touching the same test directory.

**Gated on:** nothing outstanding. The original gate — the `import-collision-refusal`
feature, which was adding tests to the same directory — cleared when that feature was
completed and integrated on 2026-07-30. What remains is not a gate but a dependency: the
`source` rename above must be settled with this one, since both target the same identifier.

**Why:** two binding rules are unobserved across a whole test directory, and one file
carries the exact ambiguity the suffix rule exists to prevent. Conforming in one pass keeps
the rename behavior-neutral and reviewable on its own, rather than spreading it through a
feature's commits or leaving the suite carrying two spellings of the same control.

**How to apply:** settle the `source` rename with this one first — they target the same
identifier and the combined target is `control_source`. Re-derive the file list, then rename
`origin_constant` and `destination_constant` across it, leaving implementation locals,
method parameters, and non-control result variables alone. Run the suite to confirm the
rename is behavior-neutral; the count must not move. Then delete both files and record an
entry in `waytide/local/log/`. Related: the deferred item
`2026-08-01T02-57-18Z-tests-say-source-rather-than-origin`, the namespace-variable-suffix
rule, the testing package's `control_` prefix rule, the literal-constants-terminology rule,
and the feature record `2026-07-30T19-48-47Z-import-collision-refusal.md`.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 2:28:46 PM PT
Changed by Scott Bellware on Thu Jul 30 2026 at 2:41:07 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 8:02:19 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 8:05:52 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 8:10:57 PM PT
Changed by Scott Bellware on Fri Jul 31 2026 at 10:44:31 PM PT
