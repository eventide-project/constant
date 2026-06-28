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

---

## Task 5: Build from a module

- [x] Given a module, `build` returns the `Constant` that mediates it.

---

## Task 6: Build from a name

- [x] Given a name and a namespace, `build` resolves the name to its module and returns the `Constant` that mediates it. The namespace defaults to the top level. An option directs whether resolution follows the ancestor chain. When the name is not bound in the namespace, or is bound to a value that is not a module, `build` raises an error.

Driven outcomes (red→green): name resolved within a namespace; `Constant::Error` on an undefined name; `Constant::Error` on a name that resolves to a non-module value. The **default-namespace** and **`inherit`** outcomes were *dropped as green-on-arrival* — both behaviors were already present (the `namespace = Object` default and `const_get`'s threaded `inherit`), so their tests would have driven no design (see the no-green-on-arrival-tests rule). Also added (after the core outcomes): `build`'s namespace parameter accepts a name as well as a module, resolved by recursing through `build`.

---

## Task 7: Definition predicate

- [ ] A class-level predicate reports whether a name is bound within a namespace, defaulting to the top level. It tests existence only — the bound value's type does not matter — and never raises.

---

## Task 8: Instance definition predicate

- [ ] An instance predicate reports whether the constant's name is bound within a supplied namespace. The namespace is supplied through an `in:` keyword. It delegates to the class-level predicate.

---

## Task 9: Controls — non-module inner constants

- [ ] Extend `Controls::Constant` so it can seed inner constants whose values are not modules, alongside its existing seeding of module-valued inner constants.

This supports the next two tasks, which must distinguish inner constants that are themselves modules from inner constants bound to other kinds of values. This task ships the controls change only; the tests that exercise it ship with Tasks 10 and 11.

---

## Task 10: Inner constant names

- [ ] A `Constant` reports the names of its own inner constants that are themselves modules, as Strings. Inner constants bound to other kinds of values are excluded, and inherited names are excluded by default. (Ruby's `Module#constants` returns Symbols; normalize to Strings on the way out, per the String-outputs convention.)

---

## Task 11: Inner constants

- [ ] A `Constant` reports its own inner constants that are themselves modules, each mediated by a `Constant`. The selection matches the names query; the difference is that the mediating `Constant`s are returned rather than name Strings.

---

## Task 12: Documentation

- [ ] Document the `Constant` class in the `README`.
