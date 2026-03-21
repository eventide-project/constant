# Notes



## Work

- [x] Make Ruby 4 the minimum

- [x] Document the API
- [x] Document the macro syntax

- [x] Constant::Import
- [x] Constant::Define

- API
- [x] Imported constant's inner constants are accessible by the receiver without using the imported constant's namespace

- [Spec] The receiver constant can't already be extended by the source constant (unless it's an alias)


- => [Test] The alias is an inner constant, and the imported inner constants are nested in the alias constant



module Extension
  module SomeInnerModule
  end
end

module SomeModule
  include Extension

  import Extension # => Error (SomeModule already includes Extension)
  import Extension, as: Something # => Not an error
end


- [x] [Test] Receiver constant's inner constants will include the source constant's inner constants

- [x] [Test] Receiver constant's inner constants will not include the source constant

- [x] For an alias constant, a new constant (module) will be defined, and the source constant's inner constants will be added to it
- [x] Use Constant::Define to turn a constant name into a constant within a specified receiver constant

- Macro (do this after the API)
  - Macro always works with self

- Logging

- Consider adding the notions in demo.rb and proof.rb to the readme. It will make the library's purpose and existence easier to understand by other Ruby devs.

- Consider creating a stateful object for the lifecycle of the queries and commands executed on a constant

  c = Constant.new(...)
  c.defined?
  c.defined?(in: SomeOtherNamespace)

  c = Constant.build(name, outer_constant)
  c.class #=> Constant


- Consider an "Eventide" root namespace
  - Also for EnvVar (and for everything else in the future)

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

- [hypothetical] Constant.resolve(source_constant=nil, *paths)
  - Useful in the Reflect library
  - The paths may have a single nested path, a single path, or a list of both
  - A nested path (eg: "Foo::Bar") would be split, recursed
  - Returns a nil rather than failing when the constant is not resolved


---
