# Importing Constants Without Their Name Prefix — Aspiration

- **State:** Active
- **Tags:** [aspiration]

## Summary

A module whose inner constants carry a common **name prefix** — `Evt_Schema`, `Evt_Store` —
can be imported with that prefix **removed**, so the destination holds `Schema` and `Store`.
The prefix is named by a **prefix pattern**, `"Evt_*"`, which both selects the constants
carrying it and says what comes off.

A **variant substitutes** another prefix for the matched one — `Evt_Schema` arriving as
`Eventide_Schema` — rather than removing it. It is recorded here because it was stated, and
**its value is speculative**: nothing yet establishes that a use for it exists.

## Background & Motivation

Ruby has no namespace below the constant, so a library that must keep its constants distinct
at the top level carries the distinction **inside the name** — `Evt_Schema` rather than
`Evt::Schema`. The prefix is there for the origin's sake: it answers a collision the origin
would otherwise cause. It answers nothing at the use site, where the surrounding code has
already said which library is meant, and where it is read on every reference.

`Constant::Import` already moves constants from an origin to a destination and already
**selects** among them, through `only:` and `except:`. What it cannot do is change a name on
the way across. A name prefix is exactly the case that wants it: a name that is correct where
it comes from and wrong where it lands.

## Vocabulary

- **name prefix** — a leading segment of a constant's name, shared by several constants of one
  origin, carried to keep them distinct rather than to say anything about the constant. `Evt_`
  in `Evt_Schema`.
- **prefix pattern** — the form that names a prefix and stands for the constants carrying it:
  `"Evt_*"`.
- **prefix removal** — the import stripping the matched prefix, so `Evt_Schema` arrives as
  `Schema`. The substance of this aspiration.
- **prefix substitution** — the variant replacing the matched prefix with another, so
  `Evt_Schema` arrives as `Eventide_Schema`.

## A prefix pattern both selects and renames

`only:` and `except:` name constants **exactly**, and neither changes a name. A prefix pattern
does two things at once: it names the constants by their **shape** — those whose names begin
with `Evt_` — and it says which part of each name is not to travel.

That second job is new to `Import`. Every constant it moves today arrives under the name it
left with.

## The prefix comes off; it is not made optional

`Evt_Schema` arrives as `Schema`, and the destination holds that name alone. The import does
not define both the stripped name and the original, and does not leave the original reachable
alongside it.

## Prefix substitution, whose value is speculative

The variant stated is `import "Evt_*", alias: "Eventide_"` — the matched `Evt_` replaced by
`Eventide_` across every constant the pattern selects.

**It is recorded as speculative and it is not a constraint on the removal.** No use for it has
been named, and a use that has not been named cannot say what shape the feature should take. It
is written down so it is not lost, not so it is built.

**Substitution generalizes removal**, which is the one structural fact worth carrying: removal
is substitution with an empty replacement. Whether the interface expresses it that way — one
mechanism with a replacement that may be empty, or two — is not settled here, and settling it
before the substitution's value is established would be deciding the general case from the
speculative half of it.

## `alias:` already carries a different meaning

`Constant::Import` reserves `alias:` today for the **destination namespace**: given
`alias: "SomeAliasConstant"`, it defines that constant on the destination and imports the
origin's constants into it, so they land at `Destination::SomeAliasConstant::SomeInnerConstant`
rather than at `Destination::SomeInnerConstant`.

Prefix substitution stated as `alias:` would give the keyword a second meaning, selected by
whether a pattern was also given. Which keyword carries the substitution is unsettled.

## Where the pattern sits in the actuation is unsettled

`Import`'s first positional argument is the **origin constant** — a module. `import "Evt_*"`
puts a string there, which is not what that position holds. Two readings are consistent with
what was stated, and nothing yet chooses between them:

1. The pattern stands **in place of the origin**, and the origin is resolved from it.
2. The pattern is a **selector beside `only:` and `except:`**, and the origin is still the
   first argument.

## Settled

- **2026-08-08** — A module's inner constants carrying a common name prefix can be imported
  with that prefix removed: `Evt_Schema` imported as `Schema`.
- **2026-08-08** — The prefix is named by a **prefix pattern**, `"Evt_*"`, which both selects
  the constants carrying it and states what is removed.
- **2026-08-08** — The imported constant arrives under the **stripped name alone**. The
  original name is not also defined on the destination.
- **2026-08-08** — A **prefix substitution** variant replaces the matched prefix with another,
  and **its value is speculative** — it is recorded rather than adopted, and it does not
  constrain the removal.

## Out of Scope / Deferred

- **Where the prefix pattern sits in the actuation** — in place of the origin constant, or as a
  keyword beside `only:` and `except:`.
- **Which keyword carries prefix substitution**, `alias:` being taken by the destination
  namespace.
- **Whether the pattern form is prefixes only** — `"Evt_*"` with the wildcard fixed at the end
  — or general name matching, of which a prefix is one case.
- **What happens when a stripped name collides.** `Import` raises today on a constant already
  defined on the destination or inherited by it. Whether two origin constants stripping to one
  name is that same failure, and whether the message names the original or the stripped form,
  is unaddressed.
- **Whether removal and substitution are one mechanism** — substitution with an empty
  replacement — or two.
- **Whether the pattern composes with `only:` and `except:`**, and what a name given exactly in
  `only:` means when a pattern has also selected it.
- **Whether the macro form and the refinement form carry it**, or only `Constant::Import.call`.
- **Whether prefix substitution is built at all.**

---

Authored by Scott Bellware on Sat Aug 8 2026 at 7:55:01 PM PT
Changed by Scott Bellware on Mon Aug 17 2026 at 11:52:07 PM PT
