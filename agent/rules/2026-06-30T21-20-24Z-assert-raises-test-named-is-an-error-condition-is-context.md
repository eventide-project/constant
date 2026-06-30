# An `assert_raises` test is named "Is an error"; its condition is promoted to a context

When a test's assertion is an `assert_raises`, the `test` block's name is always
exactly **"Is an error"** — nothing more. The **condition** under which the error
is raised (the "when …" clause) is **not** part of the test name; it is promoted
to a **`context`** that wraps the test block and names that condition.

**The tell:** if a `test` name wants the word **"when"**, that "when" clause is a
*condition* — lift it into a `context`, and name the `test` "Is an error".

```ruby
# Not this:
test "Raises when the name is not defined" do
  assert_raises(Constant::Error) { constant.get(name) }
end

# This — condition is a context, the test states the bare fact:
context "When the name is not defined" do
  test "Is an error" do
    assert_raises(Constant::Error) { constant.get(name) }
  end
end
```

**Why:** an error outcome establishes "*under condition X*, the actuation **is an
error**." Those are two different things — the **scenario** (a context) and the
**single fact asserted** (the test). Keeping the test name uniformly "Is an
error" and putting the condition where conditions belong (a context) mirrors how
non-error outcomes are named for what they establish, and lets several error
conditions over the same actuation sit as sibling contexts, each with its own
"Is an error".

**Relation to the context rule:** the context-only-for-local-instrumentation rule
says don't wrap a single-assertion test in a context that holds nothing. An
error test is the deliberate exception: the wrapping context isn't empty — it
carries the **condition**, which is real information (and is the only place the
condition can live, since the test name is fixed as "Is an error").

**How to apply:** any `assert_raises` test → name it "Is an error", inside a
`context` named for the condition (the "when …"). This **amends the
test-name-is-prefix rule's** error example ("Raises when the name is
undefined"). Existing error tests named "Raises when …" (e.g.
`build/undefined.rb`, `build/literal.rb`'s predecessor, the `import_constant`
error tests) conform in a deferred pass. Related: the test-name-is-prefix rule,
the context-only-for-local-instrumentation rule, and the test-block-is-assertion-only rule.
