# Constant Class Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Each task is tracked with a single checkbox (`- [ ]`).

**Goal:** Add a stateful `Constant` class to the `constant` library that mediates a resolved module and answers queries about its name, namespace, presence, and inner constants.

**Architecture:** Two phases. Phase 1 (Task 1) converts the top-level `Constant` from a module to a class — a behavior-neutral structural change. Phase 2 (Tasks 2–12) builds the query API incrementally, one capability per task, test-first.

**Tech Stack:** Ruby, TestBench (test framework), bundler standalone.

**Source design:** `agent/design/2026-05-22-constant-class-design.md`

**Process notes:**
- Code is not specified in this plan. Each task states the intended behavior; the code is generated interactively, on command, in the increments chosen at the time.
- Each task is driven test-first.
- Tests build their example constants through `Controls::Constant` rather than assembling modules by hand.

**Commit policy:**
- One commit per task. The commit subject is short, imperative — matching the existing repo style.
- **No `Co-Authored-By: Claude …` trailer in any commit** (per `~/.claude/CLAUDE.md`).
- Each commit also adds a one-line decision-log entry to `agent/log/` only if the task involved a real decision; otherwise skip.

---

## Task 1: Class conversion

- [x] Convert the top-level `Constant` from a module to a class. Every file that reopens `Constant` adopts the class form together, a dedicated file holds the class, and the test harness — which can no longer include a class — references the controls namespace directly instead.

The change is atomic: the moment one file reopens `Constant` as a class while another still declares it a module, loading fails with a type error. All the reopening files change together; there is no viable intermediate commit. The existing suite passes unchanged, which proves the conversion changes no behavior.

---

## Task 2: Initialization

- [x] A `Constant` is initialized with a module. The module is exposed on the instance via an attribute reader.

---

## Task 3: Name

- [x] A `Constant` reports its own name — the unqualified, final segment of the module's qualified name — as a String.

---

## Task 4: Namespace

- [x] A `Constant` reports its namespace: the module that contains the module it mediates. A `Constant` for a top-level module has no containing module; its namespace is the top-level namespace.

Built and reworked: `#namespace` returns a `Constant` for the containing module (not the bare module, and not the namespace name as a String — both forms were tried and dropped). A top-level module's namespace is `Constant.new(Object)` — a method that must return a `Constant` can't return `nil`, so `Object` is the top-level fixpoint.

---

## Added features (built test-first, outside the original task sequence)

- [x] **Full name** — A `Constant` reports its full, `::`-qualified name as a String (`mod.name` in full), where `#name` (Task 3) returns only the final segment.
- [x] **Value equality** — `Constant#==`, `#eql?`, and `#hash` compare by the mediated `mod`: equal `Constant`s compare equal, dedupe in a `Set`, and interchange as `Hash` keys. A non-`Constant` operand compares `false` without raising.
- [x] **Raw alias** — `Constant#raw` aliases `#mod` (a shorter, adjectival reader for the same raw module). A mechanical alias via the `alias` keyword — no test, consistent with the untested `#mod` initializer reader.

---

## Task 5: Build from a module

- [x] Given a module, `build` returns the `Constant` that mediates it.

---

## Task 6: Build from a name

- [x] Given a name and a namespace, `build` resolves the name to its module and returns the `Constant` that mediates it. The namespace defaults to the top level. An option directs whether resolution follows the ancestor chain. When the name is not bound in the namespace, or is bound to a value that is not a module, `build` raises an error.

Driven outcomes (red→green): name resolved within a namespace; `Constant::Error` on an undefined name; `Constant::Error` on a name that resolves to a non-module value. The **default-namespace** and **`inherit`** outcomes were *dropped as green-on-arrival* — both behaviors were already present (the `namespace=Object` default and `const_get`'s threaded `inherit`), so their tests would have driven no design (see the no-green-on-arrival-tests rule). Also added (after the core outcomes): `build`'s namespace parameter accepts a name as well as a module, resolved by recursing through `build`.

---

## Task 7: Definition predicate

- [x] A class-level predicate reports whether a name is bound within a namespace, defaulting to the top level. It tests existence only — the bound value's type does not matter — and never raises.

One driven outcome (red→green): a constant name defined in the namespace → `true` (`Affirms the constant name is defined in the namespace`). `Constant.defined?` reflects `build`'s signature — positional `name`, positional namespace (a name or a module), trailing `inherit:` — and reuses `build` to resolve the namespace, then checks existence via `const_defined?`. The other facets — undefined name → `false` (never raises), value-type-agnostic existence, the default top-level namespace, and `inherit` — were all **green-on-arrival** (`const_defined?` returns `false` for an undefined name and ignores value type; the `namespace ||= Object` default and threaded `inherit` are already present), so dropped per the no-green-on-arrival rule.

---

## Task 8: Instance definition predicate

- [x] An instance predicate, `Constant#defined?`, receives a name or a Ruby module as a positional argument and reports whether it is defined **within the module the instance mediates** — the instance is the namespace being searched. For a name: whether that name is bound. For a module: whether that exact module is nested within (identity/containment, not name-existence). Supports an `inherit` keyword (default `false`). Two scenarios → outcomes: `name` (defined by name), `module` (nested module affirmed, same-named non-nested module refuted), each its own test file. The refuting module outcome is the discriminator that witnesses identity over name-existence. `inherit` is threaded but not separately driven (green-on-arrival).

  Reworked from the design doc's `#defined?(in: namespace)` collision-check framing (instance as the thing looked for) — dictated across the actuation hinges; see `agent/log/2026-06-29T15-44-03Z-…`, `…T15-59-32Z-defined-module-arg-identity`, `…-inherit`. Test layout is nested-by-receiver: `constant/defined_predicate/class.rb` (Task 7) plus `constant/defined_predicate/instance/{name,module}.rb`.

---

## Task 9: Controls — non-module inner constants

- [x] Extend `Controls::Constant` so it can seed inner constants whose values are not modules, alongside its existing seeding of module-valued inner constants.

This supports the next two tasks, which must distinguish inner constants that are themselves modules from inner constants bound to other kinds of values. This task ships the controls change only; the tests that exercise it ship with Tasks 10 and 11.

**Done — green-on-arrival; no new code.** The capability already exists in `Controls::Constant.add_inner_constants`: the Hash form (`inner_constants: { name => value }`) seeds arbitrary, including non-module, values via `const_set`, coexisting with the Array form's module-valued seeding. It's exercised today by `build/non_module.rb` and the `defined?` name tests. A mixed module (module-valued + non-module inners) — what Tasks 10–11 need — is expressible by passing a Hash with explicit `Module.new`/`Controls::Constant.example` values alongside literals. The only thing *not* present is an ergonomic auto-generated-module-in-a-mix helper; deferred to if/when Tasks 10–11 actually want it. See `agent/log/2026-06-29T18-51-27Z-task-9-green-on-arrival.md`.

---

## Task 10: Inner constants

- [ ] A `Constant` reports its own inner constants that are themselves modules, each mediated by a `Constant`. Inner constants bound to other kinds of values are excluded, and inherited names are excluded by default.

---

## Task 11: Inner constant names

- [ ] A `Constant` reports the names of its own inner constants that are themselves modules, as Strings. The selection matches the inner-constants query; the difference is that name Strings are returned rather than the mediating `Constant`s. (Ruby's `Module#constants` returns Symbols; normalize to Strings on the way out, per the String-outputs convention.)

---

## Task 12: Documentation

- [ ] Document the `Constant` class in the `README`.
