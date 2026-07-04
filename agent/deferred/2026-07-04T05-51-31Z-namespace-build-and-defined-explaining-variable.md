# Two build/new and explaining-variable consistency touch-ups in `lib/constant/constant.rb`

Two pure-consistency cleanups surfaced by the whole-project code review, both behaviorally equivalent to the current code (no test change expected):

- **`Constant.namespace` constructs via `new`, not `build`.** Lines ~32 and ~35 call `Constant::Module.new(Object)` / `Constant::Module.new(namespace_mod)` directly. The build/new-strict rule routes construction through `build` (`new` reserved as the strict internal primitive). Since the input is always a raw module, `Module.build(mod)` is a passthrough to `new` here — so this is purity/consistency, not a behavior fix. Route both through `Constant::Module.build`.
- **`Constant.defined?` chains `get(...).get(...)` without an explaining variable.** Line ~42: `get(namespace_name_or_module).get(name, inherit: inherit)`. The explaining-variable convention (as applied in `#constants`/`#constant_names`, and just applied to `#defined?`) would bind `namespace_constant = get(namespace_name_or_module)` first, then `namespace_constant.get(name, inherit: inherit)`.

**Gated on:** nothing in flight — actionable whenever a cleanup session is spent. Do the two together; they touch the same file.

**Why:** both were declined as low-value in the review's disposition, then the developer chose to queue rather than drop them — so they are real, small, and worth doing when convenient, just not urgent.

**How to apply:** make both edits, run `ruby test/automated.rb` (should stay 92/92 with no changes), commit, and delete this file with an `agent/log/` entry recording the touch-ups. Related: the review log `agent/log/2026-07-04T05-49-40Z-whole-project-code-review.md` (findings #2 and #3) and the build/new-strict rule.
