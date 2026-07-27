# An experiment: `Constant::Import.call`'s destination parameter is optional, defaulting to the caller

Explore making the second parameter of `Constant::Import.call` optional, so that
`Constant::Import.(SomeOrigin)` imports into the calling module or class, derived
from the caller's binding and the call stack rather than passed explicitly.

The macro already gets this for free — `Macro#__import_constant` passes `self`,
which is the module body the macro was invoked in. The question is whether the
API can offer the same convenience without the macro, and at what cost in
machinery and clarity.

Run this as an **experiment**, per the precedent of the Name experiment
(`agent/experiments/2026-06-26T21-19-51Z-name-feature-run-1.md`, merged as
`65bdcf6` from `name-experiment-1`): an experiment branch, and a run log in
`agent/experiments/` recording the gates and their outcomes alongside the code.

**Gated on:** the Waytide migration. An experiment produces artifacts under
`agent/experiments/`, and the migration is expected to move or restructure the
`agent/` tree, so running the experiment first would write into a layout that is
about to change.

**Why:** the destination is the one argument the caller almost always knows
implicitly — it is the module the call sits in. Making it explicit is noise at
every use site that isn't aliasing or importing into a third party. The macro
exists partly to hide that noise; if the API can hide it too, the macro's reason
for being narrows to the `import`-as-a-keyword reading.

**How to apply:** the ground already covered — this Ruby is 4.0.1, and a probe of
the available caller-introspection mechanisms found:

- `caller_locations` yields file and line only, not the caller's `self`
- `Binding.of_caller` is not defined
- `RubyVM::DebugInspector` is not defined
- the `binding_of_caller` and `debug_inspector` gems are not installed, and
  adding a runtime dependency for this would be a significant cost against a
  convenience feature
- `TracePoint` is available, and is the remaining pure-Ruby avenue

So the first gate of the experiment is whether a `TracePoint`-based derivation of
the caller's `self` is sound enough to stand behind — and whether the resulting
machinery is worth the argument it removes. A negative result is a legitimate
outcome of the experiment and should be recorded as such.

Note that the destination is now normalized inside `Import.call` (a non-module
destination imports into its class), so a defaulted destination has to fit ahead
of that normalization rather than around it.
