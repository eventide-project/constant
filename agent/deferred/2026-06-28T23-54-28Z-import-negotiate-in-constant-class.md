# Open question: should `Import` negotiate in terms of the `Constant` class?

When `Constant::Import` returns a Ruby constant (a module it resolved or imported), should it return a **`Constant`** (the domain object) rather than a raw module? More broadly: should `Import` (and the import macro) take and give `Constant` instances as its currency, so callers work through the domain object instead of raw modules — the same shift the `Constant` class introduced for queries.

**Why it's open:** the `Constant` class now exists as the library's domain object for a resolved module; `Import` predates it and still trades in raw Ruby constants. Making `Constant` the currency of `Import` would unify the library's surface, but it's a public-API change with backward-compatibility weight, and it overlaps the already-noted out-of-scope item "Refactoring `Import` / `Define` to delegate to the `Constant` class" (`agent/design/2026-05-22-constant-class-design.md`, Out of Scope). This note sharpens that into the specific question of the **return type / API negotiation**, not just internal delegation.

**To decide:** whether `Import`'s inputs and/or outputs become `Constant` instances; if so, whether it's opt-in (a new method/arm) or a breaking change to the existing return; and how it interacts with the macro form. No code yet — this is a design question to settle before any work.
