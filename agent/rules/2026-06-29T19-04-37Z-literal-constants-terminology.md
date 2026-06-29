# Terminology: a constant bound to a non-module value is a "literal constant"

A constant whose value is **not** a module or class is a **literal constant**. Use "literal constant" (and "literal" / "literal-valued") in names, prose, comments, tests, commits, designs, and conversation — not "non-module constant" / "non-module value" / "non-module-valued".

| Instead of | Say |
|---|---|
| non-module constant | literal constant |
| non-module value | literal value (or just "a literal") |
| non-module-valued inner constant | literal inner constant |

The complement stays as it is: a constant whose value is a module or class is a **module constant** (or "module-valued"). So `#constants` reports the module constants; `include_literal_constants: true` also includes the literal constants.

**Why:** "Non-module" names the category by what it is *not* — negative and imprecise. "Literal constant" names it positively and literally: a constant bound to a literal value. Consistent with the name-literally-not-by-analogy rule and the no-slang terminology rule (positive, literal nouns over negations and figures).

**How to apply:** Write "literal constant" wherever a non-module-valued constant is meant. Live prose still carrying "non-module" — the design doc, the plan (Tasks 9–11), the `build/non_module.rb` test filename and its "non-module value" context — is conformed in the deferred terminology pass, not rewritten retroactively in historical records. Related: the name-literally-not-by-analogy rule, the no-slang terminology rule, and the namespace-variable-suffix rule.
