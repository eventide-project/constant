# Constant::Import Macro Design

## Goal

Add a macro interface to `Constant::Import` so that a module or class can use `include Constant::Import` to gain the `import` and `__import_constant` class-level macros, matching the API documented in the README.

## Design

### Macro vs API

The existing `Constant::Import.call` is the concrete API. The macro is a convenience layer on top of it that always operates on `self` (the receiver constant at class definition time).

`__import_constant` is the concrete macro method. `import` is an optional convenience alias for it. This allows a host library to remove the `import` alias if it conflicts with another method of the same name, while retaining full functionality via `__import_constant`.

### Mechanism

`Constant::Import` gains a `self.included(base)` hook. When a module or class includes `Constant::Import`, the hook calls `base.extend(Constant::Import::Macro)`, which adds `__import_constant` and `import` as class-level methods on the receiver.

```ruby
module Constant
  module Import
    def self.included(base)
      base.extend(Macro)
    end

    module Macro
      def __import_constant(source_constant, **kwargs)
        Import.(source_constant, self, **kwargs)
      end

      alias import __import_constant
    end
  end
end
```

### Usage

```ruby
module SomeReceiver
  include Constant::Import

  import SomeModule
  import SomeModule::SomeInnerModule, alias: :Something
end
```

Or using the safe name directly:

```ruby
module SomeReceiver
  include Constant::Import

  __import_constant SomeModule
end
```

### What does not change

- `Constant::Import.call` is unchanged.
- `Constant::Define` is unchanged.
- Error behaviour (`Import::Error`) is unchanged — it is raised by `.call` and surfaces through the macro naturally.

## Files Affected

- Modify: `lib/constant/import.rb` — add `self.included` hook and `Macro` nested module
- Create: `test/automated/import_constant/macro/macro.rb` — macro smoke test
- Create: `test/automated/import_constant/macro/alias.rb` — macro with alias
