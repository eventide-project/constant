# Loop record — Macro's top-level idiom (`include Constant::Import`)

Recorded live. `Constant::Import`'s macro form (`include Constant::Import; import
SomeOrigin`) doesn't work at the top level of a plain script — `self` there is
`main`, and Ruby's top-level `include` silently redirects to `Object.include`,
which only makes `import` a singleton method of `Object`, not callable from
`main` (an *instance* of `Object`). Extending `Macro` directly gets past the
`NoMethodError: undefined method 'import' for main`, but then
`Macro#__import_constant` called `Import.(origin_constant, self, **kwargs)` with
`self == main`, and `Import.call` does `destination_constant.ancestors…`, which
raises because `main` isn't a `Module`/`Class`.

---

## Pass 1 — Direction: extend-based vs. include-based *(options)*

**Hinge:** two viable fixes, presented before any test-writing (per the
actuation-gate rule, ahead of hinge 1):

- **Option A (extend-based):** new top-level idiom
  `extend Constant::Import::Macro; import EnvVar`. Only needs
  `Macro#__import_constant` to fall back to `self.class` as the destination when
  `self` isn't already a `Module`/`Class`. Zero blast radius.
- **Option B (include-based):** makes `include Constant::Import; import EnvVar`
  work verbatim at top level, matching the README literally, but installs
  `import`/`__import_constant` as public instance methods on every object in the
  process for its lifetime — the same flavor of global reach the library's own
  README disclaims for constants, here applied to a method.

**Decision:** Option A (extend-based).

## Pass 2 — Build (hinge cycle)

- **Actuation** (options): explicit-receiver calls —
  `control_destination_object.extend(Constant::Import::Macro)` then
  `control_destination_object.import(origin_constant)` — over a
  self-rebinding `instance_eval` block that would have read closer to the literal
  top-level syntax.
- **Assertion** (options, revisited once — the developer flagged that the
  library already has its own `const_get` wrapper): resolve both sides through
  `Constant.get`/`Constant::Module#get` (`Constant.get(inner_constant_name,
  control_destination_class)` vs. `Constant.get(inner_constant_name,
  origin_constant)`) and assert `Constant` value-equality (`==`), rather than a
  raw `const_defined?`/`const_get` check or the library's own `#defined?`
  predicate.
- **Controls** (options): destination stand-in is an unnamed `::Class.new`
  instance (since `Controls::Constant.example` only ever builds `Module.new`,
  which can't be instantiated) — over naming it via `Object.const_set` to match
  the sibling tests' narration convention.
- **Red confirmed contained:** running the assembled test against the
  unpatched library reproduced the exact empirically-diagnosed failure
  (`NoMethodError: undefined method 'ancestors' for #<#<Class:…>:…>`), isolated to
  the new test file; the existing suite was untouched.
- **Implementation** (options): inline conditional in
  `Macro#__import_constant` (`destination = self; if not self.is_a?(::Module);
  destination = self.class; end`) over extracting a private
  `__import_destination` helper for the single call site.
- **Loop-continuation gate** (options): close after this one outcome — over
  adding a second, alias-variant outcome mirroring `macro.rb` → `alias.rb` —
  since the single outcome already demonstrates the fix dissolves into the real
  top-level use.
- **Naming** (options): "Imported constants are accessible via the destination
  class" — over the literal "Is the origin's corresponding inner constant" and
  the descriptive "Imported constants resolve to the origin's inner constants".

---

## Pass 3 — Review reopens the direction *(chat)*

**Hinge:** the review of the pass-1/pass-2 work surfaced that the implementation
was broader than what was documented and logged — the fallback fires for *any*
non-module receiver, not only the top level — and that the README's idiom had no
test behind it (the test stood in an anonymous object for `main`).

**Chat:** the developer supplied the missing use case: this is done in a
`test_init` file, where the library-under-test's root namespace is imported so
every test file can reach it — written as `include Constant::Import; import
EnvVar`. That named the *include* form as the intended idiom, which pass 1 had
rejected.

**Decision:** reopen pass 1's direction on the strength of the use case.

## Pass 4 — Direction, revisited: the include form *(options)*

**Hinge:** pass 1 disqualified the include form because making it work at top
level would install `import` as a public instance method on every object. That
premise turned out to be incomplete: a third path exists — when
`Import.included` receives `Object` as the base, extend the *top-level
receiver's singleton*. Probed empirically: `include Constant::Import; import
SomeOrigin` then works at top level, and `Object.new.respond_to?(:import, true)`
is `false`. None of the blast radius that decided pass 1 applies. Also verified
that `self` at the top level of a `require_relative`'d file is the same `main` as
`TOPLEVEL_BINDING.receiver`, so it holds in a `test_init` file.

**Decision:** the include form, reversing pass 1.

## Pass 5 — The test hinges

- **Actuation** (options, revisited twice): a real top-level script in a
  subprocess, over reaching `main` in-process. The in-process route was
  recommended first, on the finding that `self` inside a TestBench context body
  *is* `main` — so the literal idiom could be written verbatim in a test.
  Probing the consequence killed it: two files run in one process showed that a
  single `include` leaks into every later file — bare `import` callable in every
  subsequent context, `Constant::Import` permanently in `Object.ancestors`, and
  the imported constants resolving unqualified suite-wide, including inside
  unrelated classes. Randomizing the inner constant names would have narrowed
  only the collision risk. There is no teardown: a module cannot be un-included
  from `Object`. The subprocess is the only form that leaves the suite unaltered.
- **Assertion** (options): the script references each imported constant bare and
  prints its full name; the test asserts those against the origin's paths. Since
  an imported module keeps the name it was first assigned, this establishes both
  that the constant is reachable unqualified *and* that it is the origin's — over
  asserting the macro's return value, and over asserting only that the script ran
  without failing.
- **Controls** (options, placement folded in): `Controls::Script.top_level_import`
  generates the script source and runs it with `ruby -e`, passing the parent's
  `$LOAD_PATH` through as `-I` options — over a script committed under `test/` or
  under `lib/constant/controls/`. The developer raised the placement question
  directly; that the placement was contested is itself the argument for
  generating the source, since then there is no script file to home, and
  `lib/constant/controls/script.rb` is an ordinary control module beside
  `controls/constant.rb`.
- **Red confirmed contained:** the assembled test aborted on exactly the
  diagnosed failure — `-e:10:in '<main>': undefined method 'import' for main
  (NoMethodError)` — isolated to the new file.

## Pass 6 — Scope, reopened by a second use case *(chat, then options)*

**Hinge:** with the include form settled, the destination question was settled
narrowly — resolve to `::Object` only when the receiver is the top-level object —
on the argument that `self.class` is principled for `main` (Ruby's own rule for
where top-level constants live) but arbitrary for any other object.

**Chat:** the developer asked what happens if someone wants to include the import
module into `Object` to give everything the macro. The premise needed correcting:
`Constant::Import` has no instance methods, so including it into `Object` gives
no object the macro — it only fires the hook. The spelling for "everything gets
the macro" is `include Constant::Import::Macro`, and on the pass-2 code it
already worked: an instance's import lands on its class.

**Decision:** that idiom is supported, so the general `self.class` destination
stays — reversing the narrow decision, and making the top-level object an
ordinary case of one rule rather than a special case. `macro.rb` therefore stands
as pass 2 wrote it, and the whole of the include-form support lives in
`Import.included`. The implementation options that had been put up for the narrow
reading (a main-keyed conditional in `Macro`, versus a `TopLevelMacro` module
specialized for `main`) were both dropped with it.

## Pass 7 — Naming *(options)*

**Hinge:** the outcome's name. Recommended "Imported constants are accessible at
the top level of a script," reasoning that the outcome name is the only slot
carrying the case, since all three files in `macro/` open the same two
folder-mirroring contexts.

**Decision:** "Are the origin's inner constants" — literal about the value
comparison the assertion makes, which the is-prefix rule reserves for exactly
that shape. The recommendation's reasoning was overstated: TestBench prints the
file path before each file in a suite run, so the case was never hidden.

## Pass 8 — Test structure *(dictated)*

**Hinge:** the case name. Pass 7 settled the outcome name on the reasoning that
it was the only slot carrying the case, leaving the file two contexts deep.

**Decision (dictated):** nest three deep — `Import Constant` / `Macro` / `Top
Level` — so the case has its own context, matching the sibling `macro/alias.rb`.
This puts the case in the indented output and makes the pass-7 naming reasoning
moot from the other direction. Note that it also runs against the
test-context-nesting-mirrors-folders rule, which says leaf files within a feature
folder are distinguished by outcome-context titles and not by an extra per-file
context layer — `alias.rb` already diverged from that text, and now `top_level.rb`
does too. The rule's text needs reconciling with the practice.

---

**Outcome:** `Constant::Import.included` (`lib/constant/import.rb`) extends the
top-level receiver's singleton with `Macro` when the base is `Object`, so
`include Constant::Import; import SomeOrigin` works at the top level of a script
and in a `test_init` file. `Constant::Import::Macro#__import_constant`
(`lib/constant/import/macro.rb`) keeps the general `self.class` destination for
any non-module receiver, which covers both the top-level object and an instance
of a class that includes `Macro`. New control:
`lib/constant/controls/script.rb`. New test:
`test/automated/import_constant/macro/top_level.rb`. Verified: 98 tests, 0
failed. Pass-1 and pass-2 commit: `afcbae8`.
