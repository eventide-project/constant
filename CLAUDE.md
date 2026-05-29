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

## Agent artifacts

All Claude/agent artifacts for this project live under a single top-level `agent/` folder so they can be committed to git alongside the code.

- `agent/memory/` — auto-memory files (`MEMORY.md` index plus per-memory `.md` files). **Do not** write memory to `~/.claude/projects/.../memory/`.
- `agent/design/` — design specs (Superpowers `brainstorming` skill output). Overrides the Superpowers default of `docs/superpowers/specs/`. Filename convention stays `YYYY-MM-DD-<topic>-design.md`.

If other Superpowers skills (e.g. `writing-plans`) would normally write under `docs/superpowers/<kind>/`, write to `agent/<kind>/` instead (e.g. `agent/plans/`), keeping the per-skill filename conventions.

When working with Superpowers `brainstorming` artifacts, use the word **design** rather than **spec** in commit messages, PR descriptions, and prose addressed to the user. The skill's own internal language ("spec self-review", "spec reviewer subagent") may stay as-is — the rule applies to anything you author. The artifact filenames already end in `-design.md`, so the user-facing vocabulary is consistent: the file is a *design*, the folder is `agent/design/`, and commits say "design."

### Decision log — `agent/log/`

Record decisions made during sessions as one file per decision in `agent/log/`.

- **Trigger:** detect — write an entry whenever a real decision is made (the user picks among alternatives, accepts/rejects an approach, or sets a rule that will guide future work). Don't wait to be asked. When in doubt, log it; over-logging is cheaper than under-logging here.
- **Filename:** `YYYY-MM-DDTHH-MM-SSZ-<kebab-slug>.md`, where the timestamp is **UTC** (compute with `date -u +%Y-%m-%dT%H-%M-%SZ`). ISO 8601 with colons replaced by hyphens for cross-platform filename safety. Contributors are globally distributed, so UTC is mandatory — never use local time.
- **Content:** one line — `# <title>`. The title states the decision. No body, no template. Keep titles informative enough to skim.
- **Commit:** include log entries in the same commit as the change they describe, or commit them separately with a `Log:` prefix. Don't sit on them.
