# Notes

- [x] Document the API
- [x] Document the macro syntax

- [x] Make Ruby 4 the minimum

- Set a new constant
- Always use an alias. Coerce the new constant name to the alias. Use "constant_name" in the implementation, but "alias" in the parameters list
- Default the receiver to "Object"
- Macro always works with self

- source_constant, receiver_constant

## Work

- => Constant::Import
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

- For an alias constant, a new constant (module) will be defined, and the source constant's inner constants will be added to it
- Use Constant::Define to turn a constant name into a constant within a specified receiver constant

- Macro (do this after the API)

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


---
