# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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
Uses [TestBench](https://github.com/test-bench/test-bench). Tests live in `test/automated/`. Test controls (factories for building example constants) are in `lib/constant/controls/`. The test entry point `test/automated.rb` excludes `_init`, `*sketch*`, and `*_tests` files from auto-discovery.

## Code Style

- Do not use the safe navigation operator (`&.`).
- `Constant::Import::Error` and similar applicative errors extend directly from `RuntimeError`.
