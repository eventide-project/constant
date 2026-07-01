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

**How to produce it:**
- Run the suite first and report the pass/fail line.
- Build one merged tree across all `test/automated/**/*.rb` files (excluding
  `*_init` and `automated.rb`): parse each `context "…" do` and `test "…" do`
  (indentation gives depth), and merge into a shared tree keyed by name so
  identical paths de-duplicate. Render each context path once, tests marked as
  leaves (e.g. a `•` prefix).
- Represent what the source can't name literally: a bare `test do` as
  `(unnamed)`, and a dynamic `context <expr> do` (e.g. a loop variable) as
  `<expr>`. These surface the legacy `Import`/`Define` tests that aren't yet
  named — a useful signal, not an error.

**Why:** the de-duped tree is the readable, whole-suite view — it shows the
feature/outcome structure at a glance without the per-file repetition, and it
surfaces unnamed/dynamic legacy tests. Fixing the command's shape makes it a
repeatable request.

**How to apply:** on a "test tree" request, run the suite and render the merged,
de-duplicated `context`/`test` tree as above. Related: the status-report and
test-report commands (which include a shallower two-level context tree).
