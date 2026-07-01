# Normalize README example-output representation to the "following line" style

The README shows example outputs two different ways. The hand-written docs (the
`Constant::Import` section) put the result on the **line after** the expression:

```ruby
SomeReceiver.const_defined?(SomeModule)
# => true
```

Some of the later (AI-written) sections instead use a **trailing same-line**
comment, often with alignment padding — e.g. in Coercion and Queries:

```ruby
Constant(SomeModule)                         # => #<Constant::Module value=SomeModule>
constant.value        # => SomeNamespace          (the mediated Ruby value)
```

**Normalize all of them to the following-line style** (the preferred, hand-written
form): the `# => result` comment on its own line directly beneath the expression,
with no alignment padding.

**How to apply:** scan every ```ruby``` block in `README.md` for trailing `# =>`
(and similar trailing result/annotation) comments; move each result to the line
below its expression, dropping the alignment whitespace. Where a trailing comment
carried an extra parenthetical annotation (e.g. `(the mediated Ruby value)`),
decide whether it becomes part of the following-line comment or is folded into
prose. Keep the examples accurate. Docs only — no code, no test impact. Delete
this file and add an `agent/log/` entry.
