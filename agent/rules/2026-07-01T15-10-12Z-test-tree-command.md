# "test tree" command: run the suite and print a normalized, de-duped context tree

When the human gives the command **"test tree"**, run the automated suite
(`ruby test/automated.rb`) and print its structure as a **single normalized
tree** — the whole suite's `context`/`test` hierarchy with the **duplicate outer
context headings removed** (merged), so each context path appears **once**.

The problem it solves: each test file re-declares the same outer contexts
(`context "Constant" do / context "Module" do / …`), so the raw run output
repeats those headings per file. The normalized tree merges them: `Constant`
appears once, `Module` once beneath it, then each sub-feature once, with the
individual tests as leaves.

**How to produce it:** run the durable script —

```
ruby test/automated/tree.rb
```

`test/automated/tree.rb` **runs** the suite (with `comment`/`detail` output
suppressed), captures the run's output, and parses **that output** — not the
source code — merging every file's `context`/`test` hierarchy into one tree keyed
by name so identical paths de-duplicate. Tests are the leaves (a `•` prefix); it
prints the pass/fail summary line at the end. The script is excluded from the
default suite run via the exclude pattern in `test/automated.rb` (`…,tree}.rb`).

**Parse the output, not the source.** Because the tree comes from the *run*, a
dynamic `context <expr> do` (e.g. a loop variable) shows its **expanded real
value** (e.g. `"SomeInnerConstant"`), not the placeholder `<expr>` the source
would give. A bare unnamed `test do` produces no output line, so its enclosing
context becomes the leaf and is shown by that context's name.

**Why:** the de-duped tree is the readable, whole-suite view — it shows the
feature/outcome structure at a glance without the per-file repetition, and (via
the expanded dynamic names) surfaces the legacy `Import`/`Define` tests. A durable
script makes the command reproducible across sessions rather than a rebuilt
throwaway.

**How to apply:** on a "test tree" request, run `ruby test/automated/tree.rb` and
present its output. Related: the status-report and test-report commands (which
include a shallower two-level context tree).
