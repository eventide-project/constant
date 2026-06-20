# TDD, first turn: start a feature with a test file — one nested test block asserting an explaining variable

Start a feature by writing a test file, not implementation. The first turn produces that file and nothing more.

The file is nested properly: an outer `context` naming the feature/concern, and an inner `context` naming the specific thing being established. Inside the inner context goes a single `test` block with a single assertion.

The assertion is made against an **explaining variable** — a named local whose name states what is being asserted — not against an inline expression. That explaining variable holds the result of **actuating the test's concern**: the call to the unit under test. Actuate first, bind the result to the explaining variable, then assert the variable.

```ruby
context "<Feature>" do
  # actuation of the concern — the call to the unit under test
  result = SomeUnit.(...)

  context "<What this establishes>" do
    some_explaining_variable = # derived from result

    test do
      assert(some_explaining_variable)
    end
  end
end
```

This is turn one of the TDD process: get the efferent actuation and its single asserted outcome down. Subsequent turns build from here.

**Why:** The first turn is where the unit is designed from the efferent side — the actuation is the first efferent reference, and writing it before any implementation forces the interface outside-in (see the TDD-as-design-tool rule). Asserting against an explaining variable keeps the test reading as a statement of the concern rather than a mechanical check; binding it to the actuation result keeps the efferent view in the frame.

**How to apply:** When beginning a feature, write only the test file this turn. Nest an outer `context` for the feature and an inner `context` for the established outcome. Actuate the unit under test, bind the result to an explaining variable, and write one `test` block asserting that variable. Do not write the implementation yet, and do not pause to run the inevitably-failing test. Related: the TDD-as-design-tool rule and the `control_` test-variable prefix rule.
