# Loop record — `Constant.get` as the universal class-level accessor

Recorded live. Began as a frontier-triage question about naming and ended by
collapsing the class-level construction/resolution surface into a single
accessor, `Constant.get`, with `Constant()` a thin veneer over it. Mostly design
chat; the builds were behavior-neutral refactors.

---

## Pass 1 — The naming question *(chat)*

**Hinge:** the AI, listing the frontier, said `Constant::Get` / `Constant.resolve`
were "rejected." The developer had **not** asked for a rejection — they asked
*why the class-level helper is named `resolve` and not `get`*.

**Correction:** the AI had jumped ahead; it deleted the premature rejection log
and reverted the design-doc edit. Then answered: `resolve` is a `notes.md`
artifact predating the instance `#get`. With `#get` named, a class-level
counterpart should use the **same verb** — `Constant.get`.

## Pass 2 — Does class-level `get` earn its place vs. `build`? *(chat → worked out)*

`Constant.build(name, namespace)` already resolved, so was a separate `Constant.get`
redundant? The real finding: `Constant.build("Bar", Foo)` performs a *lookup that
can raise* — resolution wearing a constructor's name — and the reason `build`
went universal (it predated the `Constant()` coercion) had **expired**. The AI
recommended a split (`get` resolves, `build` constructs). Developer: *"Take it on
test-first."* Executed: `build` narrowed to a module, new `Constant.get` for
names, coercion dispatches. Green (68).

**Process note:** the selection-UI previews **clipped** code ("N lines hidden");
the developer couldn't decide against truncated code. Lesson: keep previews to
the few lines that carry the contrast, or show full code in prose.

## Pass 3 — "What is `Constant.build(mod)` for?" *(chat)*

Post-split, `Constant.build(mod)` was a thin delegate to `Constant::Module.build`.
The developer pressed on its purpose. The AI's first defense was API symmetry
(a `build`/`get` pair).

## Pass 4 — Collapse: `get` universal, `build` dropped *(chat → dictated)*

The developer redirected: **`Constant.get` should do most of the coercion's work,
except idempotence and the nil/type-error** — i.e. the refinement should carry as
little as possible; the substantive logic belongs in a plain class method. That
makes `get` universal (module → construct, name → resolve). The developer then
asked the clinching question: **does `Constant.get(mod)` do the same as
`Constant.build(mod)`?** It does — `get`'s module branch *is* `build(mod)`. So
`build` was a duplicate, not a distinct operation.

**Decision (dictated):** drop `Constant.build`; `Constant.get` is the sole
universal class-level accessor; the coercion is a thin veneer (idempotence +
type guard) over `get`; `defined?` routes through `get`; the construction leaves
are the subtype `.build`s. `build/value.rb` folded into `get/value.rb`; the
`build/` directory removed. Behavior-neutral; green (68).

---

**Outcome:** one class-level accessor — `Constant.get(value, namespace=Object,
inherit:)` — handling a module (construct) or a name (resolve); `Constant()` a
minimal refinement over it; `Constant.build` gone. The refinement carries only
the coercion idiom; the real logic is a plain, always-available method. README's
Construction/Resolution sections merged into "Getting a Constant". Suite green
(68).

**Aside:** during this loop the developer noted, for the record, an interest in
doing this kind of TDD/design/process work with Anthropic. Logged here as context
for whoever reads the transcript; the AI has no channel to act on it.
