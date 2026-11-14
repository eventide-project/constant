# Loop record — Import test vocabulary

Two deferred items renamed the same identifiers in the `Import` and `Define` tests — one
the form, one the word — and were carried out as one pass. The feature's lifecycle is
`waytide/local/features/2026-08-01T06-09-15Z-import-test-vocabulary.md`.

Written live.

## Pass 1 — confirming the target vocabulary

**Hinge** — the sequencing item carried a target table and said the `_inner` rows should be
confirmed against the suffix rule before the pass was written, neither renaming item having
spelled them out.

**Options** — none — not gated. A factual check, not a decision.

**Decision / chat** — **the table was wrong.** It mapped `origin_inner_constant` and
`control_origin_inner_constant` to one name. Reading what each is assigned from settled it:
`origin_inner_constant` (`instance.rb:27`, `refinement/instance.rb:22`) comes from
`Constant.get(…)` and holds a **`Constant` instance**, so its `_constant` suffix is correct
— it keeps it and gains the `control_` prefix as an expected operand.
`control_origin_inner_constant` (`except/except.rb:23`) comes from `const_get(…)` and holds
a **raw module**, so its suffix is wrong and it goes bare. Applying the table as written
would have collided two different things into one name and stripped a correct suffix from
two `Constant` instances.

The item was corrected before the branch was cut, so the error never reached the code. It is
recorded because the check the item asked for is the only reason it did not.

## Pass 2 — the controls boundary

**Hinge** — the single `origin_name` in the tests is not a test variable. It is a keyword
argument to a control, and the parameter lives in `lib/constant/controls/script.rb`, which
sits under `lib/`. The source item said `lib/` keeps `origin`.

**Options** — controls are in scope wherever they live, so the keyword becomes
`source_name:`; or the boundary is the directory, so the keyword stays and
`refinement/top_level.rb` passes `control_source_name` to a parameter called `origin_name`.

**Decision / chat** — **controls are in scope wherever they live.** The instruction had
named control names, and a control's own interface is a control name. The source item's
"`lib/` keeps `origin`" is narrowed to the **library proper** — `import.rb` and
`import/macro.rb`, 11 occurrences including `Import.call`'s parameter. All 8 occurrences of
`origin` under `lib/` outside the library proper were in `script.rb`, so the split is clean.

## Pass 3 — the rename

**Hinge** — none. With the vocabulary settled, the substitution is mechanical.

**Options** — none — not gated.

**Decision / chat** — applied, and worth recording for the mechanism rather than the
decision: the first attempt used `sed` with `\b` word boundaries, which **BSD `sed` does not
support**. Every word-boundary substitution silently matched nothing while the plain-text
ones applied, leaving the tree half-renamed — `name: "Source"` and `"SomeSource"` in place
while every identifier still said `origin`. No error was raised; the only signal was reading
the result. Redone with `perl`, which supports `\b` on this platform, and finished.

The lesson is narrow and mechanical: a silent no-op is the failure mode of a
platform-dependent regular expression, so a bulk substitution is verified by re-grepping for
what should no longer be there, not by the command exiting zero.

## Outcome

21 files, **182 insertions against 182 deletions** — line for line, as a behavior-neutral
rename should be. The suite holds at **114 tests**, all passing.

`origin_constant` → `control_source`, `destination_constant` → `control_destination`,
`origin_inner_constant` → `control_source_inner_constant`, `control_origin_inner_constant`
→ `control_source_inner`, `control_origin_name` → `control_source_name`,
`Controls::Script`'s `origin_name:` → `source_name:` with a `"SomeSource"` default,
`name: "Origin"` → `name: "Source"`, and the five `context` and `test` titles saying
*origin* now say *source*. The narration strings — `Source Constant`, `Source Inner
Constant` — follow.

---

Authored by Scott Bellware on Fri Jul 31 2026 at 11:12:11 PM PT
