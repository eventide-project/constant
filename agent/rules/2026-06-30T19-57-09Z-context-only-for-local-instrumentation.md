# Wrap a test in a context only when the outcome needs local instrumentation; otherwise name the test directly

A `test` block holds **exactly one assertion** and nothing else (per the
test-block-is-assertion-only rule). Naming an outcome does **not** require a
`context` block: TestBench lets a test carry its own name — `test "Outcome name" do … end`.

Use a named **`context`** wrapping a `test` **only when that outcome needs local
instrumentation** — an **explaining variable derived for it**, or a
**`comment`/`detail`** specific to it. The context exists to hold that local
setup alongside the bare test.

When the outcome is a **single assertion over values already in scope** (the
shared arrangement and actuation at the top of the feature context), **name the
`test` directly and use no context** — a context that only wraps a bare test adds
a nesting level that carries no information; the name belongs on the test itself.

```ruby
# No local setup needed → named test, no context
test "Is the Constant::Literal the name resolves to" do
  assert(constant == control_literal)
end

# Local explaining variable / detail needed → context holds it
context "Defined" do
  defined = receiver_constant.const_defined?(new_constant_name)
  detail defined.inspect
  test do
    assert(defined)
  end
end
```

**Why:** a context should *mean something* — "there is local instrumentation
here." A bare `test` inside a `context "name"` whose only content is the
assertion wastes the context: the name could sit on the `test`. Reserving
contexts for outcomes that actually derive a local variable or add local
narration keeps the structure honest and flatter.

**How to apply:** name the `test` directly unless the outcome derives its own
explaining variable or adds an outcome-local `comment`/`detail`; only then wrap
it in a `context`. Existing Constant-class single-assertion tests (`full_name/`,
`name/`, `namespace/`, `equality/`, the `literal/` outcomes, `defined_predicate/`)
that wrap a lone `test` in a `context` while their explaining variable sits at
the top are **over-wrapped** and are to be conformed to named tests in a deferred
pass. Related: the test-block-is-assertion-only rule, the test-structure rule
(the per-outcome context is for outcomes that *derive* locally), and the
test-name-is-prefix rule.
