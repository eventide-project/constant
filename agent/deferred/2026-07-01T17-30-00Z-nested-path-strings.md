# Support nested-path strings (`"Foo::Bar::Baz"`) as a name argument

Every name argument today is a **single segment** — `build`, `#get`, the
`Constant()` coercion, and `defined?` each take one name and resolve it one level
deep. Support a `::`-qualified **path string** so a whole path resolves in one
call:

```ruby
Constant("Foo::Bar::Baz")            # coercion resolves the full path
Constant.build("Bar::Baz", Foo)      # path relative to a namespace
constant.get("Bar::Baz")             # multi-segment inner resolution
```

**Open questions to settle if taken up:**
- **Where the split lives.** Most likely in `#get` (the resolution primitive):
  split on `::` and resolve segment by segment, so `build` and the coercion
  inherit path support for free (they already delegate to `#get`). Confirm this
  is the single seam rather than splitting in each entry point.
- **`inherit:`** — does it apply at every segment or only the first hop?
- **Leading `::`** (`"::Foo::Bar"`) — absolute-from-`Object`, or unsupported?
- **`defined?`** — does the name predicate accept a path too, and stay
  never-raising across a partially-undefined path?
- **Error message** — which segment is named when resolution fails mid-path.

**Gated on:** nothing — buildable now. Composes directly with the `Constant()`
coercion just shipped.

**Why:** the most natural next capability on the construction surface; a
`::`-qualified string is how Ruby programmers already spell a nested reference.

**How to apply:** build test-first; drive the split through `#get` so every entry
point (`build`, coercion, `defined?`) gains it at one seam. Delete this file and
add an `agent/log/` entry.
