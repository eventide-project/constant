# `Constant::Import` refuses to overwrite an existing constant, and takes `except:` / `only:` to resolve one deliberately

`Constant::Import.()` imports every constant the origin module owns and assigns each one
onto the destination with no check, so a name already defined on the destination is
silently replaced. The change is in two parts: **refuse the collision**, and give the use
site a way to **resolve one deliberately**.

## What it does now

`lib/constant/import.rb`, lines 38–44: the origin's own constant names are read with
`constants(false)`, and each is assigned with `target.const_set(import_constant_name,
import_constant)`. Nothing consults the destination first. The caller names an **origin
module**, not a list of names, so the set of assignments is whatever that module happens
to own — and the caller cannot see a collision coming.

## The defect, as it was found

`env-var` pull request #3 (`eventide-project/env-var`, branch
`constant-top-level-import`) adopts the refinement in its `test/test_init.rb`:

```
require 'constant'
using Constant::Import

import EnvVar
```

`EnvVar` owns three constants — `Log`, `Controls`, `Error` — so the import performs three
assignments on `Object`. Two of the names are free. The third is not: the `evt-log` gem
defines a top-level `Log` class, and `EnvVar::Log` is a subclass of it
(`class Log < ::Log`, which adds the `:env_var` tag). The import replaces the top-level
binding:

```
constant/lib/constant/import.rb:42: warning: already initialized constant Log
evt-log-2.1.1.2/lib/log.rb:10: warning: previous definition of Log was here
```

After `test_init.rb` runs, top-level `Log` is `EnvVar::Log`. On that project's `master`,
which used `include EnvVar` instead, it is `Log`, and the suite emits no warnings at all.
Inclusion assigns nothing — it offers `EnvVar` as a place to look for a name that was not
found — and `Log` was never a name Ruby failed to find, since `Object::Log` is defined
directly on `Object` and is reached before any included module. Import assigns; include
only offers a fallback. That difference is the whole of the defect.

Nothing breaks in that suite: the one place `env-var` reads `Log` is `Log.get(self)`
inside `EnvVar.logger`, which resolves lexically within `module EnvVar` to `EnvVar::Log`
either way, and its 24 tests pass. What it costs is two warning lines on every run, and a
global name in the test process now pointing at a tagged subclass — so plain `Log`
written anywhere in that process yields an `:env_var`-tagged logger, silently. `Error` is
the same hazard unrealized: top-level `Error` is now `EnvVar::Error`, and if any gem in
the process ever defines a top-level `Error`, whichever loads second takes the name.

## The scope this reaches

Twenty-two Eventide libraries define `class Log < ::Log` — `consumer`, `messaging`,
`message-store`, `message-store-postgres`, `entity-store`, `entity-cache`,
`entity-projection`, `transform`, `poll`, `retry`, and the rest. Every one of them hits
this identical collision the moment its test suite adopts `import <Library>` at the top
level. `env-var` is the first to reach it, not a special case.

## The change

**Refuse the collision.** Before each assignment, test whether the destination already
defines that name directly (`const_defined?(name, false)`) and raise `Constant::Error`
naming the constant, the origin, and the destination. There is in-library precedent for
refusing rather than doing something surprising: `Import.included` already refuses
inclusion at the top level and directs the caller to the refinement.

**Take `except:` / `only:`.** With collisions refused, the use site needs a way to resolve
one. `import EnvVar, except: :Log` states this case exactly — import the module, minus the
one name that belongs to something else. `import EnvVar, only: [:Controls, :Error]` is the
more conservative form: the imported surface is declared rather than inferred, so a
constant added to the origin later cannot silently appear at the destination. Both keyword
names are proposals, not settled.

The two parts belong together. Refusal alone leaves `env-var` with no way forward; the
keywords alone leave the silent overwrite in place for everyone who does not yet know to
reach for them.

## What not to do

- **Do not silently skip a colliding name.** That is as surprising as silently
  overwriting it, in the other direction. The point is that the use site decides.
- **Do not treat the existing `alias:` keyword as the answer.** It nests the imported
  constants under a new constant, which is the opposite of what importing to a top-level
  destination is for.
- **Do not permit the overwrite when the incoming constant is a descendant of the one in
  place.** It is tempting — `EnvVar::Log < ::Log` looks like a specialization — and it is
  exactly the case that is wrong here.

## Reconcile against the prior `Define` decision

A prior decision in this project held that **`Define` behaves exactly as Ruby's
`const_set` — overwrite plus warning — so there is no library policy to protect**, and a
redefinition test would test Ruby rather than the library. That reasoning produced the
`do-not-test-the-platform` rule, and it is recorded in the session record
`2026-07-28T06-16-34Z-the-constant-class-becomes-a-type-model.md` (the audit section).

It is about `Define`, not `Import`, and the distinction is what this change rests on: a
`Define` caller **names the one constant** being defined, so the platform's overwrite
semantics are the caller's own choice, made with the name in hand. An `Import` caller
names an **origin module** and receives however many assignments that module happens to
carry — a set they did not enumerate and cannot inspect at the use site. That is where a
library policy is warranted and where `Define`'s is not. Settle this explicitly before
building, because the `Define` reasoning reads as though it already governs `Import`, and
it does not.

Also worth reading first: the experiment
`2026-07-27T22-41-31Z-import-destination-defaults-to-caller.md`, which settled the
refinement form the failing use site now depends on.

## What is waiting on it

`env-var` pull request #3 is open and blocked on the outcome. It merges either after this
change lands and its `test_init.rb` adopts the keyword, or before it with the two warning
lines accepted for the interim. That call is the engineer's, and it has not been made.

**Gated on:** nothing in this project — the change is actionable as soon as a session is
initiated here. It is recorded as a deferred item because it was identified while
reviewing a pull request in `env-var`, and the work belongs in this repository rather than
that one.

**Why:** an import that assigns names the caller never enumerated, onto a destination it
never inspected, can take a name that belongs to something else — and the only thing that
says so is Ruby's own warning, which is easily lost in test output. Twenty-two libraries
in this family are shaped to hit it. Refusing the collision converts a silent replacement
into a failure at the moment of import; the selection keywords are what let a use site
that knows better proceed anyway.

**How to apply:** initiate a feature in this repository, settle the `Define` reconciliation
above before building, then design the refusal and the selection keywords through the
hinges. When it is carried out, delete this file and record an entry in
`waytide/local/log/`. Related: `lib/constant/import.rb`, the session record
`2026-07-28T06-16-34Z-the-constant-class-becomes-a-type-model.md`, the experiment
`2026-07-27T22-41-31Z-import-destination-defaults-to-caller.md`, and `env-var` pull
request #3.

---

Authored by Scott Bellware on Thu Jul 30 2026 at 12:22:38 PM PT
