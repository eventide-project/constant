# AGENTS.md

This file provides guidance to coding agents when working with code in this repository.

## Commands

**Install gems (standalone bundle, no system gems required):**
```sh
./install-gems.sh
```

**Run all tests:**
```sh
ruby test/automated.rb
```

**Run a single test file:**
```sh
ruby test/automated/import_constant/import_constant.rb
```

**Enable verbose test output:**
```sh
D=on ruby test/automated.rb
```

## Architecture

This is a Ruby library in the [Eventide Project](https://github.com/eventide-project) ecosystem. It provides two utilities under the `Constant` namespace:

### `Constant::Import`
Copies inner constants from a source module into a receiver module without using Ruby's `include`, thereby avoiding unintended modification of `Object`'s ancestry chain. Supports optional aliasing: if `alias:` is given, a new module with that name is created in the receiver (via `Constant::Define`) and the inner constants are nested inside it. Raises `Constant::Import::Error` (a `RuntimeError` subclass) if the receiver already includes the source constant (unless an alias is used).

### `Constant::Define`
Creates a new anonymous `Module`, assigns it as a named constant inside a receiver module via `const_set`, and returns it. Used internally by `Import` to create alias target modules.

### Load path / standalone bundler
Gems are installed locally into `./gems` using `bundle --standalone`. The `load_path.rb` file bootstraps this standalone setup and optionally prepends a `LIBRARIES_HOME` env var path (used in Eventide monorepo development to point at sibling library source directories).

### Testing
Uses [TestBench](https://github.com/test-bench/test-bench). Tests live in `test/automated/`. Controls — the TestBench helpers that build example constants for tests — are in `lib/constant/controls/`. The test entry point `test/automated.rb` excludes `_init`, `*sketch*`, and `*_tests` files from auto-discovery.

## Code Style

- Do not use the safe navigation operator (`&.`).
- `Constant::Import::Error` and similar applicative errors extend directly from `RuntimeError`.

## Waytide

This project's Waytide framework and working conventions live under `waytide/`,
committed alongside the code and read at the start of each session.

**At the start of a session, read every rule file under `waytide/framework/` and
`waytide/rules/`, and follow them.**

`waytide/framework/` holds the installed framework packages —
`waytide/framework/foundation/`, `waytide/framework/language/`, and so on, including
each package's `vocabulary.md` glossary (its terms are binding and can't be applied
unread). `waytide/rules/` holds this project's own local rules.
Read `waytide/framework/foundation/` first; it defines the framework. The rules
override default behavior where they conflict; explicit user instructions still win.

**The load notice is printed by the harness, not by you — do not print one.** A
`SessionStart` hook in `.claude/settings.json` runs
`waytide/framework/foundation/session-start.sh`, which reads the package directories
actually present and emits the one-line `Waytide loaded from … — N packages: …`
notice; a status line carries the same count for the rest of the session. A developer
silences both by setting the `WAYTIDE_QUIET` environment variable to any non-empty
value in their own environment.

The other directories under `waytide/` hold the project's working state, kept
separate from the rules — `log/`, `deferred/`, `observations/`, `design/`,
`plans/`, `sessions/`, `loops/`, `experiments/` — and are worked with as their
conventions describe, not read as binding rules at session start.
