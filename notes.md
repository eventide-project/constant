# Notes

## Claude

- Plan
- Implementation plan
- Superpowers

## Work

- [x] API
  - [x] Imported constant's inner constants are accessible by the receiver without using the imported constant's namespace
  - [x] The receiver constant can't already be extended by the source constant (unless it's an alias)
  - [x] [Test] The alias is an inner constant, and the imported inner constants are nested in the alias constant
  - [x] [Test] Receiver constant's inner constants will include the source constant's inner constants
  - [x] [Test] Receiver constant's inner constants will not include the source constant
  - [x] For an alias constant, a new constant (module) will be defined, and the source constant's inner constants will be added to it
  - [x] Use Constant::Define to turn a constant name into a constant within a specified receiver constant

- [x] Macro (do this after the API)

- [consideration] Constant::Get

- Logging
  - Major entry points into actuator (ie: the "call" method) are logged with "trace", and exits are marked with "debug" (use debug because the constant library is purely mechanical)

- Consider creating a stateful object for the lifecycle of the queries and commands executed on a constant

  c = Constant.new(...)
  c.defined?
  c.defined?(in: SomeOtherNamespace)

  c = Constant.build(name, outer_constant)
  c.class #=> Constant

- Return new constant objects, or get the new constants and return them so that full namespaces are present?

- Constant::Get.() as an alternative to receiver_constant.const_get(alias_constant_name, inherit=false)
  - Make inherit a keyword argument and default to false
  - Allow a string of symbol of nested constants, eg: .("SomeConstant::SomeInnerConstant::SomeDeeperConstant")
  - Consider whether the resolution of the constant starts from the current lexical scope if the string representation of the constant

- Constant.defined?(string) as an alternative
  - Can pass a nested string
  - Default inherit to false

- A Constant object could allow for calling ".constants" to get constant objects for inner constants, or calling ".constant_names" to get list of symbols
  - Defaults to inherit=false

- This library will be useful in creating an implementation of Eventide's Reflect library
  - Protocol discovery can be done by having an expression of the call chain and the constant resolution and method resolution
  - Hypothetically, start with a constant gotten using the Constant::Get

    resolved_protocol = Protocol::Get.(source_constant, &protocol_block) do |protocol|


    resolved_protocol = Protocol::Get.(object_with_substitute_mod) do |protocol|
      protocol.build &.get_specialization
    end
    ## The protocol can be executed at this point. It's ready and bound.
    protocol.(some_arg) # maybe

  - The `protocol` block arg is an invocation recorder: each method called on it returns another invocation recorder, so the block specifies a call chain rather than a dot-separated string of method names. All method calls in the chain are presumed to have no arguments.

  - A `?` suffix on a link in the chain marks the *next* link as conditional on the user's implementation. The `?`-suffixed method is always invoked; the link after it is invoked only if the return value responds to it. Example: `protocol.some_method?.method_that_might_not_be_supported` — `some_method` is always called; if its return value doesn't respond to `method_that_might_not_be_supported`, the protocol result is the return value of `some_method`; otherwise the protocol result is `some_method.method_that_might_not_be_supported`.
    - Use case: a `Substitute` module may produce a basic diagnostic substitute, and optionally a more refined one via a deeper method. The protocol picks up the refinement when present and falls back to the basic substitute when not.
    - Protocols never have predicate methods, so the `?` suffix is unambiguously the conditional-next-link operator.

  - The constant should be retrievable from an object, as well as a module

  - [research] Study the Eventide `dependency` library's implementation, document how it performs protocol discovery today, then attempt to re-express that discovery using the prospective `Protocol::Get` DSL above. Goal: validate the DSL against a real existing protocol-discovery use case before designing further.

    - **Where it lives:** `dependency` is a thin shim over `subst-attr`. The actual discovery is `SubstAttr::Substitute.build` in `subst-attr/lib/subst_attr/substitute.rb:5-28`.
    - **Discovery algorithm:**
      1. No interface → `NullObject.build`.
      2. Look up inner `Substitute` constant on the interface with ancestor inheritance, via `Reflect.(interface, :Substitute, strict: false, ancestors: true)`. Special case: if the lookup resolves back to `SubstAttr::Substitute` itself (because the user `include`d the library), treat as not-found.
      3. No `Substitute` constant → plain mimic of the interface.
      4. `Substitute.respond_to?(:build)` → return `Substitute.build`.
      5. Otherwise → build a mimic and `extend` it with the `Substitute` module.
    - **Design tension surfaced for the DSL:**
      - The first decision point is *constant lookup*, not a method call. The recorder needs a constant-lookup operator (e.g. `protocol::Substitute?`), or this step belongs outside the DSL and only the post-lookup method dispatch is expressed in it.
      - The `?` operator as sketched returns the previous link's value if the next link isn't supported. For branches 4 vs 5, the caller would need to distinguish "got the `build` return value" from "got the `Substitute` module itself" — currently only inferable via `is_a?(Module)`, which is uglier than the existing imperative code.
      - Branch 3 (no `Substitute` at all) returns a value of an entirely different shape (a mimic), so it doesn't sit naturally as a chain result — the caller still has to branch.
    - **Conclusion so far:** the discovery is small (5 branches in ~20 lines) but it exercises three things the DSL doesn't yet handle: constant lookup, distinguishing which chain link produced the result, and a default-construction fallback when discovery yields nothing. Open: either extend the DSL to cover all three, or scope it to the method-dispatch portion only and keep the constant lookup / fallback as caller code.

    - **"Scope the DSL to method dispatch only" — what it means:** the DSL records a method-call chain on an already-resolved object. The caller does the constant lookup separately (using `Constant::Get`), then hands the result to `Protocol::Get`. Instead of one DSL expression covering all of discovery (which would require new operators for constant lookup and absence handling), the caller splits the work:

        ```ruby
        substitute_mod = Constant::Get.(interface, :Substitute, inherit: true)  # nil if absent
        return mimic(interface, record) if substitute_mod.nil?

        result = Protocol::Get.(substitute_mod) do |protocol|
          protocol.build.get_specialization?
        end
        ```

      The DSL now only records `.build?` — pure method dispatch, which is what the recorder was originally framed for. Constant lookup with ancestor inheritance stays in `Constant::Get`. The fallback to `mimic(interface, record)` when the constant is absent stays in caller code. Trade-off: keeps the DSL small and consistent with its current sketch, at the cost of splitting discovery into two phases instead of one expression.


- [hypothetical] Constant.resolve(source_constant=nil, *paths)
  - Useful in the Reflect library
  - The paths may have a single nested path, a single path, or a list of both
  - A nested path (eg: "Foo::Bar") would be split, recursed
  - Returns a nil rather than failing when the constant is not resolved


---
