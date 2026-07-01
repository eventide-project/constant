# Constant::Literal Restructure — Implementation Plan

**Goal:** Morph the `Constant` domain object from a single module-mediating class
into a **mixin module** (`Constant`) included by two concrete subtypes —
`Constant::Module` (module constant) and `Constant::Literal` (literal constant) —
and reshape `#constants`/`#constant_names` to optionally include literal
constants. This realizes the direction settled in the design doc.

**Source design:** `agent/design/2026-05-22-constant-class-design.md`, **Section 5
— Intended Direction** (and the settled resolutions therein).

**Supersedes:** the pending Tasks 10–11 of `agent/plans/2026-05-29-constant-class.md`
(both are reshaped here around the new type model). That plan's Task 12 (README)
is folded into Task 8 below. Tasks 1–9 of that plan remain as completed history.

**This is a breaking change** to the published `Constant` surface — `Constant.new`
goes away, `#mod`/`#raw` are replaced by `#value`, and `build` stops raising on a
literal. Acceptable only because the `Constant` class is newly introduced by the
predecessor plan and nothing external depends on it yet.

**Architecture:** Phase A (Task 1) is an atomic, behavior-neutral structural
conversion — the existing suite proves it. Phase B (Tasks 2–5) builds the
`Constant::Literal` type and the universal `build` factory, test-first. Phase C
(Tasks 6–7) reshapes the inner-constant queries. Phase D (Task 8) documents and
conforms.

**Tech Stack:** Ruby, TestBench, bundler standalone.

**Process notes:**
- Code is not specified in this plan. Each task states the intended behavior; the
  code is generated interactively, on command, in the increments chosen at the
  time.
- Each task is driven test-first (the structural Task 1 is validated by the
  existing suite, as the predecessor plan's Task 1 was).
- Tests build their example constants through `Controls::Constant`.
- Ruby's `Module` is referred to as `::Module` wherever it is meant, because the
  new `Constant::Module` shadows it within the namespace.

**Commit policy:**
- One commit per task, short imperative subject matching repo style.
- No `Co-Authored-By: Claude …` trailer.
- A one-line `agent/log/` entry per task that involves a real decision.

---

## Task 1: Morph `Constant` into a mixin module; extract `Constant::Module`; rename the accessor to `#value`

- [x] Convert the top-level `Constant` from a class into a **module** that carries
  the shared behavior, and move the module-constant behavior into a new class
  `Constant::Module` that includes `Constant`. The instance behavior the class
  holds today — the recorded value, `#name`, `#full_name`, `#namespace`, the
  bound-value reader, `#==`/`#eql?`/`#hash`, and the instance `#defined?` — moves
  onto `Constant::Module`. The class-level surface — `build`, the class
  `defined?`, the `name`/`namespace` static helpers, and `Constant::Error` —
  stays on the `Constant` module (as module-functions). The nested `Import`,
  `Define`, `Macro`, `Log`, and `Controls` continue to work unchanged.

  In the same change, **rename the bound-value accessor from `#mod`/`#raw` to
  `#value`** — the sole accessor, returning the recorded value (here always a
  module). `Constant.new` is removed; construction is `Constant::Module.new(value)`
  or `Constant.build`.

  The change is atomic and **behavior-neutral for module constants**: the moment
  `Constant` is a module, `Constant.new` and `#mod`/`#raw` no longer exist, so all
  construction sites and accessor uses — in `lib/` and across the existing
  `constant/` tests — move together. The existing suite passing (after the
  mechanical construction/accessor updates) is the proof that the conversion
  changes no behavior.

---

## Task 2: `Constant::Literal` — construction and binding queries

- [x] Introduce the `Constant::Literal` class, which includes `Constant`. It is
  constructed from a literal value together with its name and its namespace
  (the value cannot supply its own name — the name lives in the binding). It
  reports the bound value through `#value`, and answers the binding queries
  `#name`, `#full_name`, and `#namespace` from the supplied name and namespace.

---

## Task 3: Shared equality protocol; `Constant::Literal` equality by binding location

- [x] Lift `#==`/`#eql?`/`#hash` into the `Constant` mixin, expressed over a
  subtype-provided equality key, so both subtypes share one protocol. The
  `Constant::Module` key is its `#value` (a module's identity already encodes its
  location); the `Constant::Literal` key is its `#full_name`, so two literal
  constants are equal exactly when they share a **binding location** (same
  namespace and name), regardless of the bound value. Operands of different
  subtypes compare unequal, and a non-`Constant` operand compares `false`
  without raising. `Constant::Module` equality stays behaviorally what it is
  today.

---

## Task 4: `Constant::Literal` degenerate container queries

- [x] `Constant::Literal` answers the container view truthfully for something
  that contains nothing: `#constants` returns an empty array, and `#defined?`
  returns `false` for any argument. This keeps a literal usable wherever a
  `Constant` is expected, without it ever claiming to contain inner constants.

---

## Task 5: `Constant.build` becomes the universal factory

- [x] `build` dispatches a resolved value to the right subtype. Given a module it
  returns a `Constant::Module`. Given a name and namespace it resolves the name
  and returns a `Constant::Module` when the value is a module or a
  `Constant::Literal` when the value is a literal — supplying the literal its
  name and namespace. The **`non_module` error is removed**: a name resolving to
  a literal is no longer a `Constant::Error`, it is a valid `Constant::Literal`.
  The undefined-name error remains. The existing `build/non_module.rb` is
  re-scoped from asserting `Constant::Error` to asserting a `Constant::Literal`.

---

## Task 6: `#constants` with `include_literal_constants`

- [x] `Constant::Module#constants` reports its own inner constants as `Constant`
  objects. By default it returns only the module-valued inners, each as a
  `Constant::Module`. With `include_literal_constants: true` it also includes the
  literal-valued inners, each as a `Constant::Literal` carrying its name and this
  module as its namespace. Inherited names are excluded by default (`inherit`
  keyword, default `false`). `include_literal_constants` defaults `false`.

---

## Task 7: `#constant_names` with `include_literal_constants`

- [x] `Constant::Module#constant_names` reports the names, as Strings, of the same
  inner constants `#constants` reports — module-valued by default, plus
  literal-valued when `include_literal_constants: true` — staying 1:1 with
  `#constants`. (Ruby's `Module#constants` returns Symbols; normalize to Strings
  on the way out, per the String-outputs convention.) Both keywords default
  `false`.

---

## Task 8: Documentation and design-doc conformance

- [x] Document the `Constant` mixin and the `Constant::Module` / `Constant::Literal`
  subtypes in the `README`. Conform the design doc's Sections 2–4 and its
  Vocabulary to the settled shape (Section 5), and mark the predecessor plan's
  Tasks 10–11 superseded by this plan.

  Done: the `README` gains a "The Constant Class" section (mixin + subtypes,
  `build`/`new`, queries, `#get`, `#constants`/`#constant_names`, equality). The
  design doc gains a status banner marking it implemented and Sections 2–4
  superseded by Section 5 (kept as the design record, not rewritten), and the
  Vocabulary's `"value"` retirement is corrected (reintroduced as `#value`). The
  predecessor plan's Tasks 10–12 are marked superseded/done.
