# Loop record — nested-path string resolution (`"Foo::Bar::Baz"`)

Recorded live. A design-heavy loop: the location of the `::`-split flipped twice
as the developer worked out the layering, settling on the instance primitive
recursing on itself. The build was then a straight hinge-cycle.

---

## Pass 1 — Where does the split live? *(chat → reversed → reversed)*

**Probe first:** the AI found that a module-valued path (`Constant.get("Foo::Bar")`)
already worked (a module self-describes, so `Constant::Module.build(resolved)` is
correct regardless of path), but a **literal-valued path was silently malformed** —
native `const_get("Inner::LEAF")` builds a `Constant::Literal` with a compound
`name` (`"Inner::LEAF"`) and a shallow `namespace` (`NS` instead of `NS::Inner`),
its `full_name` only *coincidentally* correct by string cancellation.

- The AI recommended putting the split in the instance `#get` (one seam).
- The developer **reversed** it: nesting is a convenience; convenience lives in
  higher-order interfaces, so keep the split in `Constant.get` and the instance
  strictly single-segment.
- The AI explained "malformed literal" concretely when asked, and the developer
  drew out the crux: `Constant::Module#name` is `value.name.split("::").last`, so a
  module is **self-describing** — immune to the path-name problem — while a literal
  isn't, so its identity must come from the resolution context.
- The developer then **reversed again**: "consider the possibility of
  `constant.get("a::b")` ending up with a constant for `b` with the namespace `a`
  amended onto the existing namespace." That's exactly what **recursion** yields —
  and it revealed the malformation was never about the instance handling nesting,
  only about native `const_get`. Decision: **the instance recurses.**

## Pass 2 — Build (hinge cycle)

- **Actuation** (options): cradle the **instance** `constant.get`, where the
  recursion lives (over the class entry, which inherits).
- **Assertion** (options → "should it do both?"): the malformed literal's
  `full_name` coincides, so equality can't drive the fix — assert the **components**.
  Both `name` and `namespace` are wrong, so the cradle carries **two** outcomes
  (single-assertion-per-test): "Is the final segment" and "Is the enclosing
  namespace."
- **Controls** (options → dictated namespacing): a new
  `Controls::Constant::Nested.example` builds a genuinely-nested `NS::Inner::leaf`
  (inner first-bound inside its parent for the correct nested name). The leaf value
  is type-agnostic (module or literal). Developer deferred a decision on the
  `leaf_value` naming.
- **Implementation** (options): guard-clause + early return —
  `head, _, rest = name.partition("::"); return get(head).get(rest) unless rest.empty?` —
  leaving the single-segment logic below unchanged.
- **Outcome set** (multi-select): nested module, undefined leaf, mid-path literal —
  built one at a time.
- **Naming** (options): "Is the final segment" / "Is the enclosing namespace" /
  "Is the Constant the path resolves to"; error conditions "When the final segment
  is not defined" and "When a mid-path segment is a literal constant" (each with
  "Is an error").

**Deferred mid-loop:** a `Constant.get`-level demonstration test (the entry point
the feature was requested against) — queued, since the behavior is witnessed at the
instance where it lives.

---

**Outcome:** `Constant::Module#get` resolves `::`-paths by recursing on itself;
`Constant.get` and the coercion inherit it. A terminal literal is now built from a
genuine final segment with its true enclosing namespace. Suite green (73).
