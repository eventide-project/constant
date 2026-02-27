# Constant

Utilities for working with constants.

Avoid the unintended effects of including constants by aliasing their inner constants instead of accessing them via Ruby mixin.

## Constant::Import

Ruby's `include` statement is often used as an `import` statement common to other languages. An `import` is used to provide a shortcut for access constants without having to fully qualify the namespace.

However, `include` not only provides the shortcut access to inner constants, it also modifies the ancestry of the root `Object` class, and causes included constants to be accessible from namespaces other than the one that the module is included into.

See the [proof](https://github.com/eventide-project/constant/blob/master/proof.rb) in this project for a demonstration.

The `Constant::Import` utility effects the exact outcome sought by using `include` as an import: it allows inner constants to be accessible without having to fully-qualify the inner constant names, and it does not cause `Object`'s ancestry to be inadvertently modified.

### Example

```ruby
module SomeModule
  module SomeInnerModule
  end
end

module SomeReceiver
  include Constant::Import

  import_constant SomeModule
  import_constant SomeModule::SomeInnerModule, as: :Something
end

SomeReceiver.const_defined?(SomeModule)
# => true

SomeReceiver.const_defined?(Something)
# => true

SomeReceiver.const_defined?(SomeInnerModule)
# => false
```

Because classes are also constants, the `import_constant` macro can be used with a class, as well, which will also the class to be accessed without fully-qualifying its namespace, or by giving it an aliased name using the `as` argument.

```ruby
module SomeModule
  class SomeInnerClass
  end
end

module SomeReceiver
  include Constant::Import

  import_constant SomeModule::SomeInnerClass, as: :SomeClass
end

SomeReceiver.const_defined?(SomeClass)
# => true

SomeReceiver::SomeClass.new
# => #<SomeReceiver::SomeClass:0x...>
```

### Importing a Constant

...

#### Macro

...

#### API

...

## Log Tags

The following tags are applied to log messages recorded by the `Constant` operations:

| Tag | Description |
| --- | --- |
| constant | Applied to all log messages written by this library |

## License

The `Constant` library is released under the [MIT License](https://github.com/eventide-project/env_var/blob/master/MIT-License.txt).
