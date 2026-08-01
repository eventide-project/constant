# `Constant::Import` copies literal constants, and no test exercises it

`Constant::Import` assigns every constant the source module owns onto the destination,
reading them with `constants(false)` and `const_get`. Neither is restricted to modules, so a
**literal constant** — a constant bound to a non-module value, per the
literal-constants-terminology rule — is copied like any other. Verified 2026-07-30: a source
owning `SomeLiteral = "some value"` has that string assigned onto the destination.

**No test exercises it.** Every `import_constant` test builds its source with
`Controls::Constant.example(inner_constants: [names])`, which binds a fresh `Module` to each
name. The control supports literal values through its Hash form —
`inner_constants: { SomeLiteral: "some value" }` — and no import test uses it.

## What is undecided

Whether copying literals is **intended behavior** or merely what falls out of `const_get`
and `const_set` being indifferent to what they carry. Nothing states either. That question
is settled first, because it decides what the test would establish:

- **Intended** — a test protects it, and the behavior is part of what `Import` promises.
- **Incidental** — then the question becomes whether `Import` should restrict itself to
  module constants, which is a change rather than a test.

The `alias:` path is worth checking under whichever answer: an aliased import assigns into a
fresh module built by `Define`, and `Define` was made **type-agnostic** on 2026-07-03, so it
holds a literal as readily as a module. Nothing there is expected to object, but nothing
confirms it either.

## Where it came from

Found on 2026-07-30 while surveying the tests for the `Import` naming conformance, and noted
inside two deferred items in passing — first the test-controls item, then the sequencing item
— without ever being registered as work of its own. Both of those items have since been
carried out and deleted, which would have taken the note with them. This is that note, made
into an item.

**Gated on:** nothing.

**Why:** the library copies a kind of constant that no test mentions, and no record says
whether that is a decision or an accident. Either answer is fine; not knowing which is the
defect, and the knowledge was twice recorded only as an aside in an item destined for
deletion.

**How to apply:** settle whether copying literal constants is intended. If it is, cover it —
a source built with the control's Hash form, a literal asserted onto the destination, and the
`alias:` path checked. If it is not, the change is to restrict `Import`, which is designed
through the hinges rather than covered. Either way, delete this file and record an entry in
`waytide/local/log/`. Related: `lib/constant/import.rb`, the literal-constants-terminology
rule, `Controls::Constant.example`'s Hash form, and the log entry
`2026-07-03T17-30-00Z-define-made-type-agnostic.md`.

---

Authored by Scott Bellware on Fri Jul 31 2026 at 11:12:11 PM PT
