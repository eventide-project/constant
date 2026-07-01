# Loop record — Constant::Literal equality (restructure Task 3)

The passes through the **loop** (distributed OODA: the AI observes and acts; the
developer orients and decides at the gates) for one feature — lifting
`==`/`eql?`/`#hash` into the `Constant` mixin over a single subtype hook, and
giving `Constant::Literal` equality by binding location.

Each pass records: the **hinge** the AI determined (the subtle, load-bearing
decision), the **options** put to the developer at the gate, and the
**decision** the developer made — or the **chat** that replaced the options when
the right answer wasn't on the AI's list.

---

## Pass 1 — Implementation hinge: the equality-protocol hook

**Hinge (AI-determined):** what single primitive the mixin's `==`/`eql?`/`#hash`
derive from, so the protocol lives in the mixin while each subtype supplies its
own identity. Subtle (the abstraction isn't readable off the code) and
load-bearing (both subtypes' equality *and* `#hash` rest on it).

**Options put to the developer:** the AI proposed a hook named **`equality_key`** —
mixin `== ⇒ equality_key == other.equality_key`, `eql? ⇒ self == other`,
`hash ⇒ equality_key.hash`; `Constant::Module#equality_key` = `#value`,
`Constant::Literal#equality_key` = `#full_name`; public, so a cross-subtype `==`
returns `false` rather than raising.

**Chat (the developer interrogated the proposal rather than picking):**
- *Dev:* "How does `equality_key` differ from `hash`?" → *AI:* `equality_key` is
  the exact identity-defining value, compared directly and definitively (any
  type); `hash` is its lossy integer digest (`equality_key.hash`) for bucketing —
  collisions mean `hash` can't drive `==`. One subtype hook; the mixin derives
  `==`, `eql?`, *and* `hash` from it.
- *Dev:* "Is `equality_key` a conventional name, or invented here?" → *AI:*
  invented — Ruby standardizes the protocol methods (`==`, `eql?`, `hash`,
  `<=>`) but no named hook; `Struct`/`Data` generate them with no exposed hook.
  Options offered: keep a coined hook named literally (`equality_key` /
  `comparison_key` / `identity`); or no shared hook (each subtype defines its own
  `==`/`eql?`/`hash` — conventional, but reopens whether the mixin earns its
  keep); or `Data`/`Struct` (doesn't fit — the subtypes derive their keys
  differently).

**Decision:** the developer dictated the hook name **`identity`** (literal — it
*is* the constant's identity). Implemented: mixin `==` compares `identity`;
`Constant::Module#identity` = `#value` (behavior-neutral — `module/equality/`
stays green); `Constant::Literal#identity` = `#full_name` (equality by binding
location).

## Pass 2 — Controls: the discriminating example *(hinge, but no gate)*

**Hinge (AI-determined):** the affirming `equal` outcome must *discriminate*
by-location from by-value. The AI set the control to **same namespace + name
(same `full_name`), different values → equal** — a by-value implementation would
call them unequal, so this one outcome forces `identity = full_name`.

**Options / decision:** *none — this hinge was not gated.* Controls are hinge 3
in the five-hinge cycle, but here the AI folded the discriminating control into
Pass 1's framing and proceeded without offering options or stopping for
acceptance. Recorded as a pass to surface that a gate that should have run was
skipped (the developer's judgment didn't get to act on the controls).

## Pass 3 — Outcome set

**Hinge (AI-determined):** scope of the literal-equality outcomes — only the
discriminating `equal` drives design; `unequal` / `non_constant` / `eql` / `hash`
fall out of the mixin (green-on-arrival).

**Options put to the developer:** Lean (`equal` only) / Symmetric (add `unequal`
+ `non_constant` for parity with `module/equality/`, as deliberate
green-on-arrival).

**Decision:** **Symmetric** — added `unequal` and `non_constant`.

## Pass 4 — Naming (feature close), one outcome at a time

**`equal.rb`**
- *Options:* "Equal when sharing a binding location" / "Equal regardless of value
  for the same binding" / "Equal when the namespace and name match".
- *Decision (dev note):* **"Equal when the namespace and name match, regardless of
  value"** — combined the location framing with the value-independence
  discriminator.

**`unequal.rb`**
- *Options:* "Unequal when the binding locations differ" / "Unequal when the names
  differ".
- *Chat:* the developer asked for an example of "Unequal when the names differ,"
  then "Does this mean `Foo::Bar` and `Baz::Bar` are equal?" → *AI:* no — same
  final name, different namespaces ⇒ different `full_name`s ⇒ unequal; "names
  differ" names the wrong principle (it implies the name decides, when the whole
  binding location does).
- *Decision:* **"Unequal when the binding locations differ"** — states the rule,
  not the single control the test varied.

**`non_constant.rb`**
- *Decision:* **"Unequal when the other is not a Constant"** — verbatim parallel
  to `Constant::Module`.

---

**Outcome:** `==`/`eql?`/`#hash` in the `Constant` mixin over `#identity`; literal
equality by binding location (`Foo::Bar` ≠ `Baz::Bar`). Suite green (51).
Committed `d6f2656`.
