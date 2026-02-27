# Constant

Utilities for working with constants.

Avoid the unintended effects of including constants by aliasing their inner constants instead of accessing them via Ruby mixin.

## Constant::Import

Ruby's `include` statement is often used as an `import` statement common to other languages. An `import` is used to provide a shortcut for accessing constants without having to fully qualify the namespace.

However, `include` not only provides the shortcut access to inner constants, it also modifies the ancestry of the root `Object` class, and causes included constants to be accessible from namespaces other than the one that the module is included into.

See the proof for a demonstration: [https://github.com/eventide-project/constant/blob/master/proof.rb](https://github.com/eventide-project/constant/blob/master/proof.rb).

The `Constant::Import` utility effects the exact outcome sought by using `include` as an import: it allows inner constants to be accessible without having to fully-qualify the constant names with the outer constant names, and it does not cause `Object`'s ancestry to be inadvertently modified.

### Example

```ruby
module SomeModule
  module SomeInnerModule
    class SomeNestedClass
    end
  end
end

module SomeReceiver
  include Constant::Import

  import SomeModule
  import SomeModule::SomeInnerModule, alias: :Something
end

SomeReceiver.const_defined?(SomeModule)
# => true

SomeReceiver.const_defined?(Something)
# => true

SomeReceiver::Something
# => SomeModule::SomeInnerModule

SomeReceiver::Something::SomeNestedClass
# => SomeModule::SomeInnerModule::SomeNestedClass

SomeReceiver.const_defined?(SomeInnerModule)
# => false
```

Because classes are also constants, the `import` macro can be used with a class, as well, which will also the class to be accessed without fully-qualifying its namespace, or by giving it an aliased name using the `as` argument.

```ruby
module SomeModule
  class SomeInnerClass
  end
end

module SomeReceiver
  include Constant::Import

  import SomeModule::SomeInnerClass, alias: :SomeClass
end

SomeReceiver.const_defined?(SomeClass)
# => true

SomeReceiver::SomeClass.new
# => #<SomeReceiver::SomeClass:0x...>
```

### Importing a Constant

```
self.call(source_constant, receiver_constant, alias: nil)
```

```
Constant::Import.(SomeModule::SomeInnerClass, self)

# With aliasing
Constant::Import.(SomeModule::SomeInnerClass, self, alias: :SomeClass)
```

The nested constants in the source constant will be accessible to the receiver constant without the receiver constant having to use the source constant's namespace.

If an optional alias is used, the imported constants will be accessed via the alias constant name. The alias name effectively acts to replace the source constant name with another constant name.

**Returns**

The list of constants nested in the source constant that have been made available to the receiver constant's namespace.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| source_constant | The constant whose inner constants will be made accessible without having to specify the source constant's name | Module or Class |
| receiver_constant | The constant whose namespace will be able to access the imported source constant's namespace without fully qualifying it | Module or Class |
| alias | Optional constant name to use in the receiver constant's namespace to access the source constant's inner constants | Symbol |

#### Macro

...

#### Aliases

The `import` macro is a convenience alias for `__import`. The `__import` method is the concrete implementation. This mechanism helps protect against a naming conflict with another library that implements a method name as common as "import".

#### API

...

## Log Tags

The following tags are applied to log messages recorded by the `Constant` operations:

| Tag | Description |
| --- | --- |
| constant | Applied to all log messages written by this library |

## License

The `Constant` library is released under the [MIT License](https://github.com/eventide-project/env_var/blob/master/MIT-License.txt).
