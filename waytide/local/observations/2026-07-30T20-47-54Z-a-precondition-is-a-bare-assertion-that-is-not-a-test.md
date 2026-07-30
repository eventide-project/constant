# A precondition is a bare assertion in a context, not a named test

**Status:** A working hypothesis under discovery, recorded as an observation rather than a
rule because it has been applied exactly once — to
`test/automated/import_constant/except/`, where the import proceeds only because `except:`
was given. What would promote it: enough further use to show which conditions are
preconditions and which are outcomes, and whether the form needs any marking of its own
beyond the bare assertion. It is a subject the Waytide testing package has not addressed;
if it holds up here it belongs there rather than in this project's local rules.

A **precondition** is a bare `assert` or `refute` — including the block forms
`assert_raises` and `refute_raises` — written **directly in a `context`**, with **no `test`
block around it**. It states a condition the outcomes below it rest on, expressed so a
reader understands what is being established.

It is distinguished from a test by what it is for, not by what it asserts:

- **A test states an outcome.** It is what the file exists to establish, it carries a name
  describing what it establishes, and it is counted and reported.
- **A precondition states a condition.** It is not the point of the file; it is what has to
  hold before the outcomes below it mean anything. It carries no name, because naming it
  would present it as an outcome.

The worked case: `Constant::Import.()` refuses an import whose origin owns a constant the
destination already defines. Given `except:`, it proceeds. The outcomes of that test are
about what `except:` did to the destination — but every one of them is meaningless if the
import raised. Written as a named test, "the import does not fail" reads as one of the
outcomes, competing with them. Written as a precondition, the actuation is wrapped and the
condition is established before any outcome is read:

```ruby
refute_raises do
  Constant::Import.(origin_constant, destination_constant, except: control_excluded_constant_name)
end

defined_constant = destination_constant.const_get(control_excluded_constant_name, false)

test do
  assert(defined_constant == control_destination_constant)
end
```

**Mechanically**, `refute_raises` returns its own assertion rather than the block's value,
so an actuation whose result an outcome reads must assign to a local declared above the
block.

**TestBench reports it as a condition rather than an outcome, which is what makes the form
work.** A satisfied precondition adds nothing to the test count — the `except` test reports
`1 test` for its one `test` block, with the `refute_raises` above it uncounted. A failed one
reports `no tests, 1 failure` and exits non-zero, and the outcomes below it do not run.
Both halves matter: the count stays the number of outcomes, and a condition that does not
hold still stops the file rather than letting the outcomes report against a state that was
never established.

**Where it sits against the existing conventions.** The testing package's
`test-block-is-assertion-only` rule governs what goes **inside** a `test` block, and
`context-only-for-local-instrumentation` governs when a `context` is warranted. Neither
addresses an assertion with no `test` block at all, which is what this names. The
`single-case-test-named-for-feature` and `test-name-is-prefix` rules assume every assertion
belongs to a named outcome; a precondition is the case they do not cover.

**Why:** a condition and an outcome are different things, and a suite that reports them
identically misdescribes what it establishes. A file's test count should be the number of
outcomes it establishes, not that number plus the conditions that had to hold first. The
alternative — relying on the actuation to error the whole file if it raises — leaves the
condition unstated, so a reader has to work out why the outcomes below can be trusted.

**How to apply:** when a condition must hold before a context's outcomes mean anything,
assert it bare in the context, with no `test` block and no name. Reserve `test` blocks for
the outcomes the file exists to establish. Related: the testing package's
`test-block-is-assertion-only`, `context-only-for-local-instrumentation`, and
`error-test-named-fails-condition-is-context` rules, and the `tdd-test-structure` rule
(which places the actuation at the top of the feature context).

---

Authored by Scott Bellware on Thu Jul 30 2026 at 1:47:54 PM PT
Changed by Scott Bellware on Thu Jul 30 2026 at 2:09:31 PM PT
