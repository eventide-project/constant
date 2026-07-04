# Optional parameters default to nil in the signature; assign their real defaults in the body

Do not put a default value in the parameter list. Declare each optional parameter with a `nil` default in the signature, and assign its actual default in the method body with `||=`.

```ruby
# No — default in the parameter list
def self.build(name_or_raw_constant, namespace = Object, inherit: false)
  ...
end

# Yes — nil in the signature, real default assigned in the body
def self.build(name_or_raw_constant, namespace=nil, inherit: nil)
  namespace ||= Object
  inherit ||= false
  ...
end
```

**Why:** It is **more robust** — an inline default only applies when the argument is *omitted*, so an explicitly-passed `nil` slips past it (`build(name, nil)` would leave `namespace` as `nil` and then fail). The `||=` form coerces an explicit `nil` to the default too, so the omitted and explicit-`nil` calls behave the same. It also keeps defaulting **uniform and visible in the body** — every default is normalized in one place the reader scans, rather than scattered into the parameter list. This is the convention `Controls::Constant.example` already follows (`name: nil` / `inner_constants: nil`, then `inner_constants ||= []`, `name ||= "ExampleModule"`); the rule makes it explicit and project-wide.

**How to apply:** Give every optional parameter — positional or keyword — a `nil` default in the signature, and assign its real default with `||=` at the top of the body. Note `flag ||= false` for a boolean default normalizes only `nil → false` (a `true` passes through); that is intended and keeps the body's defaulting uniform even when the default is falsy. Keep the assignments free of inlined method calls per the no-inline-method-call-arguments rule (constants and literals as the default are fine). Related: the no-inline-method-call-arguments rule.

## Don't default an argument you only delegate

Coalesce an optional argument only where its value is **actually used**. When the argument is **passed through to another method that is itself responsible for defaulting it**, do **not** coalesce it first — pass it as-is (the `nil`) and let the receiver assign the default.

Coalescing before delegating **double-defaults**: it makes the receiver's own `||=` dead and obscures which method owns the default. A method that merely forwards an argument owns no default for it. So the `||=` is not always "the first lines of the body" — it belongs at the point of use, which may be inside one branch (the other branch delegating raw).

Examples:
- `Constant::Module#defined?` forwards `inherit` to `Constant.defined?` (which defaults it) in its delegating branch — passing `inherit` raw there — but coalesces `inherit ||= false` in the branch that uses it directly with Ruby's `const_get` / `constants`.
- `Constant.get` forwards `inherit` only to the instance `#get` (which defaults it), so it does **not** coalesce `inherit` at all. (It still coalesces `namespace ||= Object`, because that default is `get`'s own.)
