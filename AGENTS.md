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

## Agent artifacts

All agent artifacts for this project live under a single top-level `agent/` folder so they can be committed to git alongside the code.

- `agent/rules/` — binding project rules/conventions, one per file (see **Rules** below).
- `agent/observations/` — working hypotheses and rule-candidates still under discovery, one per file (see **Observations** below). Not binding.
- `agent/deferred/` — design changes to make once the current task is done, one per file (see **Deferred** below).
- `agent/loops/` — loop records: one file per feature, the narrative of its passes through the loop (see **Loops** below).
- `agent/design/` — design specs (Superpowers `brainstorming` skill output). Overrides the Superpowers default of `docs/superpowers/specs/`. Filename convention stays `YYYY-MM-DD-<topic>-design.md`.

If other Superpowers skills (e.g. `writing-plans`) would normally write under `docs/superpowers/<kind>/`, write to `agent/<kind>/` instead (e.g. `agent/plans/`), keeping the per-skill filename conventions.

When working with Superpowers `brainstorming` artifacts, use the word **design** rather than **spec** in commit messages, PR descriptions, and prose addressed to the user. The skill's own internal language ("spec self-review", "spec reviewer subagent") may stay as-is — the rule applies to anything you author. The artifact filenames already end in `-design.md`, so the user-facing vocabulary is consistent: the file is a *design*, the folder is `agent/design/`, and commits say "design."

### Rules — `agent/rules/`

`agent/rules/` holds the project's binding rules — naming conventions, terminology, plan-writing norms, commit conventions, and the like — one rule per file.

- **Read every file in `agent/rules/` at the start of a session and follow them.** They override default behavior where they conflict (explicit user instructions still win).
- **A rule's purpose may cut across its category.** Folder names (`terminology/`, `methodology/`, `git/`, …) name the *surface* a rule acts on, not the purpose it serves; many rules exist to install a *mental stance*, not to standardize a mechanic. Judge such a rule by the mindset it installs, not by surface conformance, and reconcile seemingly-conflicting rules at the level of purpose rather than surface. See `agent/rules/methodology/2026-07-13T21-22-51Z-rules-install-a-mindset-purpose-over-category.md`.
- **Format:** frontmatter-free markdown — a `# <title>` stating the rule, the rule in prose, then short `**Why:**` and `**How to apply:**` lines. Filename is `YYYY-MM-DDTHH-MM-SSZ-<kebab-slug>.md` — UTC, same as the decision log, with the timestamp synced to the file's creation time.
- **Recording a new rule:** when the user states a rule, or a decision sets a rule for future work, add it here as a new file, and add a matching one-line entry to `agent/log/`.

### Observations — `agent/observations/`

`agent/observations/` holds working hypotheses, definitions, and methods that are **not yet binding** — rule-candidates surfaced during open-ended discovery, before the thinking has stabilized enough to canonize. They are *not* read as binding at session start the way rules are; they record in-progress understanding.

- **When to use:** the material is genuinely useful to keep but still under active discovery, or it is a method/definition the user hasn't ratified as a convention. When in doubt between a rule and an observation, prefer an observation — promoting later is cheap, retracting a premature rule is not.
- **Format:** same frontmatter-free markdown as rules — a `# <title>`, the content in prose. Open with a `**Status:**` line stating that it is a working hypothesis under discovery and what would promote it. Filename is `YYYY-MM-DDTHH-MM-SSZ-<kebab-slug>.md`, UTC, timestamp synced to creation time — same convention as rules and the log.
- **Promotion:** when an observation stabilizes into a binding convention, lift it into `agent/rules/` as a new rule and leave the observation as the discovery record (note the promotion in both). Add a `agent/log/` entry for the promotion.
- **Recording one:** add the file, and add a matching one-line entry to `agent/log/` noting it was recorded as an observation (and why it isn't yet a rule).

### Deferred — `agent/deferred/`

`agent/deferred/` holds design changes that have been identified but intentionally **postponed until the current task is finished** — work that shouldn't interrupt the task in flight but must not be lost.

- **When to use:** a design or convention change surfaces mid-task that is real and worth doing, but acting on it now would derail the current work. Register it here and keep going.
- **Format:** same frontmatter-free markdown as rules and observations — a `# <title>` stating the change, then prose. Include a `**Gated on:**` line naming what must finish before the item is actionable, plus short `**Why:**` and `**How to apply:**` lines. Filename is `YYYY-MM-DDTHH-MM-SSZ-<kebab-slug>.md`, UTC, timestamp synced to creation time — same convention as rules, observations, and the log.
- **Resolution:** when the gating task is done, act on the item, then **delete the file** (the change itself lands in code/rules, and a `agent/log/` entry records that it was carried out). Deferred items are a queue, not a permanent record.
- **Recording one:** add the file; a matching `agent/log/` entry is optional for the deferral itself but required when the item is resolved.

### Loops — `agent/loops/`

`agent/loops/` holds **loop records** — one file per feature documenting the passes through the **loop** (the distributed OODA cycle in the TDD lexicon). Where the decision log records *what* was decided (one line each), a loop record records *how*: per pass, the **hinge** the AI determined, the **options** put to the developer at the gate, and the **decision** the developer made (or the **chat** that replaced the options).

- **Format:** `YYYY-MM-DD-<feature-slug>.md`; a title and summary, then one section per pass (hinge → options → decision/chat), then an outcome line. A hinge handled without a gate is recorded as "none — not gated" (surfacing skipped gates is part of the value). See the loop-records rule in `agent/rules/`.
- **Live vs. backfill:** records written while doing the work are the default; a record reconstructed retroactively from memory is marked at the top as a **Backfill**.
- **Companion, not replacement:** the one-line decision log stays one line per decision; the loop record is the narrative beside it.

### Decision log — `agent/log/`

Record decisions made during sessions as one file per decision in `agent/log/`.

- **Trigger:** detect — write an entry whenever a real decision is made (the user picks among alternatives, accepts/rejects an approach, or sets a rule that will guide future work). Don't wait to be asked. When in doubt, log it; over-logging is cheaper than under-logging here.
- **Filename:** `YYYY-MM-DDTHH-MM-SSZ-<kebab-slug>.md`, where the timestamp is **UTC** (compute with `date -u +%Y-%m-%dT%H-%M-%SZ`). ISO 8601 with colons replaced by hyphens for cross-platform filename safety. Contributors are globally distributed, so UTC is mandatory — never use local time.
- **Content:** one line — `# <title>`. The title states the decision. No body, no template. Keep titles informative enough to skim.
- **Commit:** include log entries in the same commit as the change they describe, or commit them separately with a `Log:` prefix. Don't sit on them.
