# Loop record — Error tests named Fails

Every `assert_raises` test in the suite was named `"Is an error"`, while two binding rules
call for `"Fails"`. This records the passes that conformed them. The feature's lifecycle is
`waytide/local/features/2026-07-31T01-36-48Z-error-tests-named-fails.md`.

Written live.

## Pass 1 — the seven

**Hinge** — none. The error-test rule fixes the name as `"Fails"`, and each of the seven
already sat in a `When …` context, so there was no condition to place and no alternative
to weigh.

**Options** — none — not gated. A rename with no decision in it.

**Decision / chat** — renamed. The suite held at 114 tests, confirming the change was
name-only.

## Pass 2 — `already_included.rb`

**Hinge** — where the condition sits. The test sat directly in `context "Already Included"`
with no condition context, so `"Fails"` alone would have left the condition unstated.

**Options** — a `When the destination already includes the origin` context, matching what
`collision.rb` had been given during the previous feature; or letting `Already Included`
carry the condition, since the folder name states it.

**Decision / chat** — **the `When …` context.** The two refusals in `Import.call` now read
alike.

## Pass 3 — `alias.rb`

**Hinge** — this one was not a rename. Its `assert_raises(NameError)` sat inside a dynamic
per-constant context, under `context "Imported constants are not defined in the
destination's root namespace"` — a context stating an **outcome**, not a condition, so
there was no `When …` to promote and `"Fails"` beneath it would have read as a second
outcome.

**Options** — keep `assert_raises` and rename, treating the lookup's failure as the
protected behavior; or read the absence directly with `const_defined?` and `refute`, as
`except.rb` and `only.rb` do.

**Decision / chat** — the developer first asked whether the test's purpose was **to ensure
the error is raised**, which would have made the raise the behavior rather than a probe.
That reading was put fairly: the two cannot diverge, since `const_defined?(name, false)` is
false exactly when `const_get(name, false)` raises, so the choice was about which fact the
test states. The developer then **corrected themselves** — the `NameError` is Ruby's,
raised incidentally by a lookup of a constant that is not there, not an error the library
raises. **Read the absence with `const_defined?`.**

That also dropped a `NameError` message assertion. Only one `const_get` can raise in that
block, so the class and condition already pin it and
`assert-error-message-only-as-sole-discriminator` says not to assert the message — true
whichever purpose the test had.

## Pass 4 — an unmet commitment in the feature record

**Hinge** — the feature record carried a line, copied from the deferred item, saying that
whether this pass and the test-controls conformance pass were combined or sequenced would
be decided **before either started**, so `already_included.rb` and `alias.rb` would not be
edited twice. No decision was made, and this pass edited both.

**Options** — record that it was not honored; decide it after the fact and say the passes
are sequenced; or remove the line.

**Decision / chat** — **removed.** It was a note about coordinating two passes, and the
coordination did not happen. The practical consequence is small — the other pass edits
those two files a second time, which is ordinary — and the line's only remaining effect
would have been to claim a decision that was never made.

## Outcome

Nine tests renamed to `"Fails"`; `"Is an error"` no longer appears in the suite, which now
holds thirteen `"Fails"` tests. `already_included.rb` gained a condition context; `alias.rb`
exchanged an `assert_raises(NameError)` probe for a direct `const_defined?` reading. The
suite is unchanged at **114 tests**, all passing, the change being name-only except in
`alias.rb`.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 7:10:48 PM PT
