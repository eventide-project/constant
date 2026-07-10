# Constant

Utilities for importing constants and inspecting constants.

Avoid the unintended effects of including constants by aliasing their inner constants instead of accessing them via Ruby mixin.

## Constant::Import

Ruby's `include` statement is often used as an `import` statement common to other languages. An `import` is used to provide a shortcut for accessing constants without having to fully qualify the namespace.

`Constant::Import` does what you reach for `include` to do as an import: it makes inner constants accessible without having to fully-qualify their names with the outer constant names.

### Example

```ruby
module SomeOrigin
  module SomeInnerModule
    class SomeNestedClass
    end
  end
end

module SomeDestination
  include Constant::Import

  import SomeOrigin
  import SomeOrigin::SomeInnerModule, alias: :Something
end

SomeDestination.const_defined?(SomeOrigin)
# => true

SomeDestination.const_defined?(Something)
# => true

SomeDestination::Something
# => SomeOrigin::SomeInnerModule

SomeDestination::Something::SomeNestedClass
# => SomeOrigin::SomeInnerModule::SomeNestedClass

SomeDestination.const_defined?(SomeInnerModule)
# => false
```

Because classes are also constants, the `import` macro can be used with a class as well, letting the class be accessed without fully-qualifying its namespace, or under an aliased name using the `alias` argument.

```ruby
module SomeOrigin
  class SomeInnerClass
  end
end

module SomeDestination
  include Constant::Import

  import SomeOrigin::SomeInnerClass, alias: :SomeClass
end

SomeDestination.const_defined?(SomeClass)
# => true

SomeDestination::SomeClass.new
# => #<SomeDestination::SomeClass:0x...>
```

### Importing a Constant

#### Macro

```ruby
self.import(origin_constant, alias: nil)
```

```ruby
include Constant::Import

import SomeOrigin::SomeInnerClass
```

The `import` macro is activated by including the `Constant::Import` module.

The nested constants in the origin constant will be accessible to the destination constant without the destination constant having to use the origin constant's namespace.

If an optional alias is used, the imported constants will be accessed via the alias constant name. The alias name replaces the origin constant name.

```ruby
import SomeOrigin::SomeInnerClass, alias: :SomeClass
```

**Returns**

The list of constants nested in the origin constant that have been made available to the destination constant's namespace.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| origin_constant | The constant whose inner constants will be made accessible without having to specify the origin constant's name | Module or Class |
| alias | Optional constant name to use in the destination constant's namespace to access the origin constant's inner constants | Symbol |

##### Method Alias

The `import` macro is a convenience alias for `__import_constant`. The `__import_constant` method is the concrete implementation. This mechanism helps protect against a naming conflict with another library that implements a method name as common as "import".

#### API

```ruby
self.call(origin_constant, destination_constant, alias: nil)
```

```ruby
Constant::Import.(SomeOrigin::SomeInnerClass, self)
```

The nested constants in the origin constant will be accessible to the destination constant without the destination constant having to use the origin constant's namespace.

If an optional alias is used, the imported constants will be accessed via the alias constant name. The alias name replaces the origin constant name.

```ruby
Constant::Import.(SomeOrigin::SomeInnerClass, self, alias: :SomeClass)
```

**Returns**

The list of constants nested in the origin constant that have been made available to the destination constant's namespace.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| origin_constant | The constant whose inner constants will be made accessible without having to specify the origin constant's name | Module or Class |
| destination_constant | The constant whose namespace will be able to access the imported origin constant's namespace without fully qualifying it | Module or Class |
| alias | Optional constant name to use in the destination constant's namespace to access the origin constant's inner constants | Symbol |

## The Constant Class

A `Constant` mediates a resolved Ruby constant and answers questions about it — its name, its namespace, its value, whether a name is defined within it, and what inner constants it contains — so that callers work through it rather than reaching into Ruby's low-level constant methods (`const_get`, `const_set`, `const_defined?`, `constants`).

`Constant` is a mixin module included by two subtypes:

- **`Constant::Module`** mediates a module or class.
- **`Constant::Literal`** mediates a constant bound to a non-module ("literal") value.

Both answer the same interface; a `Constant::Literal` has no inner constants, so the container-style queries come back empty.

```ruby
module SomeNamespace
  module SomeModule
    SomeInnerModule = Module.new
    SomeInnerLiteral = "some value"
  end
end
```

### Getting a Constant

`Constant.get` is the class-level accessor. Hand it a module (or class) and it returns the `Constant::Module` that mediates it; hand it a name and a namespace and it resolves the name, returning whichever subtype the resolved value calls for:

```ruby
Constant.get(:SomeInnerModule, SomeNamespace::SomeModule)
# => #<Constant::Module value=SomeNamespace::SomeModule::SomeInnerModule>

Constant.get(:SomeInnerLiteral, SomeNamespace::SomeModule)
# => #<Constant::Literal SomeNamespace::SomeModule::SomeInnerLiteral = "some value">

Constant.get("SomeNamespace::SomeModule")
# => #<Constant::Module value=SomeNamespace::SomeModule>
```

It is the class-level form of the instance `#get` primitive — the namespace, implicit as `self` on an instance, is passed as an argument. The namespace defaults to the top level and may itself be given as a name; an `inherit:` keyword (default `false`) governs whether resolution follows the ancestor chain. A name that is not defined raises `Constant::Error`.

A name may be a `::`-qualified **path**, resolved segment by segment:

```ruby
Constant.get("SomeModule::SomeInnerModule", SomeNamespace)
# => the Constant for SomeNamespace::SomeModule::SomeInnerModule
```

The instance `#get` does the path resolution by recursing on itself, so each segment resolves against its true parent — a terminal literal is bound with its real enclosing namespace, not the whole path. Traversing *into* a literal (a non-final segment that resolves to a literal) raises `Constant::Error`, since a literal has no inner constants.

**Returns**

The `Constant` that mediates the value — a `Constant::Module` for a module or class, or the subtype the resolved name calls for (`Constant::Module` or `Constant::Literal`). Raises `Constant::Error` when a name is not defined.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| value | A module or class to mediate, or a constant name (optionally a `::`-qualified path) to resolve | Module, Class, String, or Symbol |
| namespace | The namespace a name is resolved in; defaults to the top level (`Object`) | Module, Class, String, Symbol, or Constant |
| inherit | Whether resolution follows the ancestor chain; defaults to `false` | Boolean |

Direct construction from a value you already hold goes to the subtype constructors — `Constant::Module.build` / `Constant::Literal.build` — which normalize their inputs and delegate to `new`, the strict initializer.

### Coercion

`Constant()` is the coercion form — Ruby's `Integer()` / `Array()` idiom — an idempotent front door over `get`. It is a **refinement**, activated per file with `using Constant::Coerce`, so it never touches global scope unless a file opts in:

```ruby
using Constant::Coerce

Constant(SomeNamespace::SomeModule)
# => #<Constant::Module value=SomeNamespace::SomeModule>

Constant("SomeInnerModule", SomeNamespace::SomeModule)
# => resolves the name in the namespace

Constant(nil)
# => TypeError: can't convert nil into Constant
```

It delegates the real work to `Constant.get` (taking the same namespace/`inherit:`) and adds only its own three concerns as a coercion: an already-`Constant` value is returned unchanged — a coercion is idempotent — and a value that is neither a module, a name, nor a `Constant` raises `TypeError`, mirroring `Integer(nil)`. An un-*resolvable* name still raises `Constant::Error`, exactly as `get` does.

**Returns**

The `Constant` for the value — an already-`Constant` value unchanged, otherwise whatever `Constant.get` returns (`Constant::Module` or `Constant::Literal`). Raises `TypeError` for a value that is neither a module, a name, nor a `Constant`; raises `Constant::Error` for an unresolvable name.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| value | A `Constant` (returned unchanged), a module or class, or a constant name to resolve | Constant, Module, Class, String, or Symbol |
| namespace | The namespace a name is resolved in, passed through to `Constant.get`; defaults to the top level (`Object`) | Module, Class, String, Symbol, or Constant |
| inherit | Whether resolution follows the ancestor chain, passed through to `Constant.get`; defaults to `false` | Boolean |

### Queries

The examples below use a `constant` obtained from `Constant.get`:

```ruby
constant = Constant.get(SomeNamespace::SomeModule)
```

#### `#value`

```ruby
constant.value
# => SomeNamespace::SomeModule (the mediated Ruby value)
```

**Returns**

The Ruby value the `Constant` mediates — the module or class for a `Constant::Module`, or the bound value for a `Constant::Literal`.

#### `#name`

```ruby
constant.name
# => "SomeModule" (the final segment, a String)
```

**Returns**

The final segment of the mediated constant's name, as a String; `nil` for an anonymous module.

#### `#full_name`

```ruby
constant.full_name
# => "SomeNamespace::SomeModule" (the ::-qualified name, a String)
```

**Returns**

The full `::`-qualified name of the mediated constant, as a String; `nil` for an anonymous module.

#### `#namespace`

```ruby
constant.namespace
# => the containing Constant (Constant.get(SomeNamespace))
```

**Returns**

The `Constant::Module` mediating the containing namespace — the `Constant::Module` for `Object` when the constant is top-level, and `nil` for an anonymous module.

#### `#get`

`#get` resolves an inner constant to the `Constant` that mediates it:

```ruby
constant.get(:SomeInnerModule)
# => #<Constant::Module value=SomeNamespace::SomeModule::SomeInnerModule>

constant.get(:SomeInnerLiteral)
# => #<Constant::Literal SomeNamespace::SomeModule::SomeInnerLiteral = "some value">
```

**Returns**

The `Constant` mediating the resolved inner constant (`Constant::Module` or `Constant::Literal`). Raises `Constant::Error` if the name is not defined, or if a `::`-path runs through a literal.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| name | The inner constant name to resolve, optionally a `::`-qualified path | String or Symbol |
| inherit | Whether resolution follows the ancestor chain; defaults to `false` | Boolean |

#### `#constants` and `#constant_names`

`#constants` and `#constant_names` list a module's inner constants — as `Constant` objects and as name Strings, respectively. By default they include only the module-valued inners; `include_literal_constants: true` also includes the literal-valued ones.

```ruby
constant.constants
# => [#<Constant::Module value=SomeNamespace::SomeModule::SomeInnerModule>]

constant.constant_names
# => ["SomeInnerModule"]

constant.constant_names(include_literal_constants: true)
# => ["SomeInnerModule", "SomeInnerLiteral"]
```

**Returns**

`#constants` — the `Constant` objects mediating the selected inner constants. `#constant_names` — their names, as Strings. The default selection is the module-valued inner constants; literal-valued ones are included when `include_literal_constants` is `true`.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| include_literal_constants | Whether to include inner constants bound to non-module (literal) values; defaults to `false` | Boolean |
| inherit | Whether to include inherited inner constants; defaults to `false` | Boolean |

#### `#defined?`

`#defined?` reports whether a name or module is defined within the mediated module (a `Constant::Literal` always answers `false`). It never raises.

```ruby
constant.defined?(:SomeInnerModule)
# => true
```

**Returns**

`true` if the name or module is defined within the mediated module, otherwise `false`; a `Constant::Literal` always returns `false`. Never raises.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| name_or_module | A constant name to test for definition, or a module to test for containment (by identity) within the mediated module | String, Symbol, or Module |
| inherit | Whether the search follows the ancestor chain; defaults to `false` | Boolean |

#### `Constant.defined?`

The class-level `Constant.defined?` is a name-existence predicate that never raises. The name may be a `::`-path; a path that runs through a literal is simply not defined (`false`), never an error.

```ruby
Constant.defined?("SomeNamespace::SomeModule")
# => true
```

**Returns**

`true` if the name is defined in the namespace, otherwise `false`. A `::`-path that runs through a literal is `false`, not an error. Never raises.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| name | The constant name to test, optionally a `::`-qualified path | String or Symbol |
| namespace | The namespace to test in; defaults to the top level (`Object`) | Module, Class, String, Symbol, or Constant |
| inherit | Whether the search follows the ancestor chain; defaults to `false` | Boolean |

#### Equality

Two `Constant`s are equal when they identify the same constant: a `Constant::Module` by the module it mediates, a `Constant::Literal` by its binding location (namespace and name).

```ruby
Constant.get(SomeNamespace::SomeModule) == Constant.get(SomeNamespace::SomeModule)
# => true
```

**Returns**

`#==` and `#eql?` return `true` when both `Constant`s identify the same constant, otherwise `false`; a non-`Constant` operand compares `false` without raising. `#hash` returns an Integer consistent with equality, so equal `Constant`s dedupe in a `Set` and interchange as `Hash` keys.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| other | The object to compare against | Object |

## Defining a Constant

`Constant::Define` assigns a value to a constant name within a destination constant's namespace, returning the newly-defined constant. Given no value, it creates a new module — a fresh namespace — which is how `Constant::Import` uses it to create an alias target; given a value, it assigns that value (for example, a literal). It can be used directly to define a constant.

### Example

```ruby
module SomeDestination
end

some_constant = Constant::Define.(:SomeConstant, SomeDestination)

SomeDestination.const_defined?(:SomeConstant)
# => true

SomeDestination::SomeConstant.equal?(some_constant)
# => true
```

Giving a value assigns that value rather than creating a module:

```ruby
some_literal = Constant::Define.(:SomeLiteral, SomeDestination, "some value")
# => "some value"

SomeDestination::SomeLiteral
# => "some value"
```

### API

```ruby
self.call(constant_name, destination_constant, constant_value=nil)
```

```ruby
Constant::Define.("SomeConstant", SomeDestination)
Constant::Define.("SomeLiteral", SomeDestination, "some value")
```

`constant_value` is assigned to `constant_name` in the destination constant's namespace. When it is omitted (or `nil`), a new module is created and assigned.

**Returns**

The newly-defined constant — the assigned `constant_value`, or the new module created when no value is given.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| constant_name | The name the new constant is assigned to in the destination constant's namespace | String or Symbol |
| destination_constant | The constant whose namespace the new constant is defined in | Module or Class |
| constant_value | The value assigned to the constant name; when omitted, a new module is created and assigned | Object |

## License

The `Constant` library is released under the [MIT License](https://github.com/eventide-project/constant/blob/master/MIT-License.txt).
