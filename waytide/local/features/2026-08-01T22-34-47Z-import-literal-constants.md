# Feature — Import literal constants

## Intent

`Constant::Import` copies a **literal constant** — a constant bound to a non-module value,
per the literal-constants-terminology rule — as readily as a module constant. No test
exercises it. This adds a shallow test proving both kinds are imported.

**Copying literals is intended, not incidental** — settled 2026-08-01, which resolves the
first question the originating deferred item raised.

The feature originates in the deferred item
`2026-08-01T06-12-11Z-import-copies-literal-constants-untested.md`, which is deleted and
logged when this feature concludes.

## Setup

- **State:** Completed
- **Upstream branch:** `master`
- **Feature branch:** `feature/import-literal-constants`
- **Base:** `5c6d8fc3b43142c594e4e4a07fc1efd51a7b9ef2` on `master`
- **Working location:** Branch only — this working tree switched to the feature branch,
  and switches back to `master` at the conclusion.

## What the test protects, and what it deliberately does not

The first framing of this work was rejected, and the rejection is the reason the test is
worth writing at all.

**What it does not test.** The imported value appears exactly three times in
`Constant::Import.call` — read with `const_get`, written with `const_set`, returned. Nothing
branches on what it is; the only `is_a?(::Module)` in the file tests the *destination*. So a
literal traverses byte-identical code, and a test asserting "a literal survives `const_set`"
would assert that Ruby's constant methods are indifferent to what they carry. That is the
platform, and `do-not-test-the-platform` forbids it — the same shape as the `Define`
redefinition question that produced that rule.

**What it does test.** `Import`'s **scope**: that it takes every constant the source owns,
whatever kind. `origin_constant.constants(inherit)` is a selection the library makes and
could have narrowed to modules. That it does not is a policy, and it is currently implicit
and unprotected. A `select { … .is_a?(Module) }` added anywhere on that path would pass the
whole suite today.

The distinction is the whole justification: the test states the library's scope, not the
platform's indifference.

## The shape

`test/automated/import_constant/literal.rb`, beside `import_constant.rb`, whose controls are
left as they are. A source owning one of each kind, built through the control's Hash form:

```ruby
Controls::Constant.example(
  name: "Source",
  inner_constants: {
    "SomeModuleConstant"  => ::Module.new,
    "SomeLiteralConstant" => "some value"
  }
)
```

It is **coverage, not design** — the behavior exists, so the test is green on arrival, which
is correct when protecting behavior rather than designing it. The hinges still gate the
test's design, with the implementation hinge degenerate.

## Confirmations

- **Sat Aug 1 2026 at 3:34:47 PM PT** — copying literal constants is intended behavior, so
  it is covered rather than restricted.
- **Sat Aug 1 2026 at 3:34:47 PM PT** — the test is its own file rather than folded into
  `import_constant.rb`.
- **Sat Aug 1 2026 at 3:34:47 PM PT** — working location chosen at initiation: **branch
  only**.
- **Sat Aug 1 2026 at 3:52:18 PM PT** — the feature is widened to cover the refusal side, an
  exceptional-path file colliding a literal against a literal.
- **Sat Aug 1 2026 at 3:52:18 PM PT** — the feature is concluded as **Completed** and
  integrated into `master`.

## Conclusion

**Completed** — integrated into `master` on Sat Aug 1 2026 at 3:52:18 PM PT. The suite moves
from **114 to 117 tests**, all passing. The library is unchanged; this is coverage.

`test/automated/import_constant/literal/literal.rb` establishes that `Import`'s scope takes
both kinds of constant. `test/automated/import_constant/literal/collision.rb` establishes
that a colliding literal is refused — a gap none of the three existing collision tests
reached, all of them building their destination with the control's Array form, which binds a
module to every name.

**The scope was genuinely unprotected.** Adding a `select { … .is_a?(Module) }` to the name
set passed the whole suite before this feature. That was confirmed by adding one, watching
the literal outcome fail while the module outcome passed, and backing it out.

**The originating deferred item is deleted**, its resolution recorded at
`waytide/local/log/2026-08-01T22-52-18Z-import-scope-takes-literal-constants.md`.

**What the feature declined to test.** That a literal survives `const_set` — the platform's
behavior, already covered by `define_constant/literal.rb` and
`constant/module/get/literal.rb`. The distinction between that and `Import`'s scope is what
made the feature worth doing at all, and it came from the developer's challenge to the
premise rather than from the item as written.

## Design record

Recorded in `waytide/local/loops/2026-08-01T22-52-18Z-import-literal-constants.md`, in six
passes, written live.

---

Authored by Scott Bellware on Sat Aug 1 2026 at 3:34:47 PM PT
Changed by Scott Bellware on Sat Aug 1 2026 at 3:52:18 PM PT
