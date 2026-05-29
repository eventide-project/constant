# Constant Class Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a stateful `Constant` class to the `constant` library that wraps a resolved module/class and answers queries about its name, namespace, presence, and inner constants.

**Architecture:** Two phases. Phase 1 (Task 1) is a behavior-neutral rename of the top-level `Constant` from `module` to `class`, including a new `lib/constant/constant.rb` file and a test-harness fix. Phase 2 (Tasks 2–12) adds the new query API one method at a time, TDD per method.

**Tech Stack:** Ruby, TestBench (test framework), bundler standalone.

**Source design:** `agent/design/2026-05-22-constant-class-design.md`

**Commit policy:**
- One commit per task. The commit subject is short, imperative — matching the existing repo style.
- **No `Co-Authored-By: Claude …` trailer in any commit** (per `~/.claude/CLAUDE.md`).
- Each commit also adds a one-line decision-log entry to `agent/log/` only if the task involved a real decision; otherwise skip.

---

## Task 1: Convert Constant from module to class (behavior-neutral)

**Files:**
- Create: `lib/constant/constant.rb`
- Modify: `lib/constant.rb`
- Modify: `lib/constant/define.rb`
- Modify: `lib/constant/import.rb`
- Modify: `lib/constant/import/macro.rb`
- Modify: `lib/constant/log.rb`
- Modify: `lib/constant/controls/constant.rb`
- Modify: `test/test_init.rb`

**Why atomic:** Once any file reopens `Constant` as a `class` while another file still says `module Constant`, the require chain fails with `TypeError: Constant is not a module` (or vice versa). All seven files must change together before the suite can run. No intermediate commit is viable.

- [ ] **Step 1: Create the skeleton file**

Write `lib/constant/constant.rb` with this content:

```ruby
class Constant
end
```

- [ ] **Step 2: Flip `module Constant` to `class Constant` in `lib/constant/define.rb`**

```ruby
class Constant
  module Define
    def self.call(constant_name, receiver_constant)
      constant = Module.new
      receiver_constant.const_set(constant_name, constant)
      constant
    end
  end
end
```

- [ ] **Step 3: Flip in `lib/constant/import.rb`**

Only the opening keyword changes. The full file becomes:

```ruby
class Constant
  module Import
    Error = Class.new(RuntimeError)

    def self.included(base)
      base.extend(Macro)
    end

    def self.call(source_constant, receiver_constant, **kwargs)
      alias_name = kwargs[:alias]

      if alias_name.nil? && receiver_constant.ancestors.include?(source_constant)
        raise Error, "#{receiver_constant} already includes #{source_constant}"
      end

      target = receiver_constant

      if not alias_name.nil?
        target = Define.(alias_name, receiver_constant)
      end

      inherit = false

      import_constant_names = source_constant.constants(inherit)

      imported_constants = import_constant_names.map do |import_constant_name|
        import_constant = source_constant.const_get(import_constant_name, inherit)
        target.const_set(import_constant_name, import_constant)
        import_constant
      end

      imported_constants
    end
  end
end
```

- [ ] **Step 4: Flip in `lib/constant/import/macro.rb`**

```ruby
class Constant
  module Import
    module Macro
      def __import_constant(source_constant, **kwargs)
        Import.(source_constant, self, **kwargs)
      end

      alias import __import_constant
    end
  end
end
```

- [ ] **Step 5: Flip in `lib/constant/log.rb`**

```ruby
class Constant
  class Log < ::Log
    def tag!(tags)
      tags << :constant
    end
  end
end
```

- [ ] **Step 6: Flip in `lib/constant/controls/constant.rb`**

Only the outer keyword changes. The full file becomes:

```ruby
class Constant
  module Controls
    module Constant
      def self.example(name: nil, randomize_name: nil, inner_constants: nil)
        inner_constants ||= []

        mod = Module.new

        name ||= "ExampleModule"

        if [nil, true].include?(randomize_name)
          name = "#{name}_#{SecureRandom.hex(2).upcase}"
        end

        Object.const_set(name, mod)

        if not inner_constants.empty?
          add_inner_constants(mod, inner_constants)
        end

        mod
      end

      def self.add_inner_constants(mod, inner_constants)
        inner_constants.each do |inner_constant_name|
          mod.const_set(inner_constant_name, Module.new)
        end
      end
    end
  end
end
```

(The inner `module Constant` — the test-control namespace — remains a module; only the outermost keyword changes. Task 9 will extend this file further to seed non-module inner constants.)

- [ ] **Step 7: Wire the new file into `lib/constant.rb`**

Add `require "constant/constant"` as the first library require, before `constant/log`. Result:

```ruby
require "log"

require "constant/constant"
require "constant/log"
require "constant/define"
require "constant/import"
require "constant/import/macro"
```

- [ ] **Step 8: Update `test/test_init.rb`**

A class cannot be `include`d, so the test harness must stop including `Constant`. Replace line 14 `include Constant` with `Controls = Constant::Controls`. The unqualified `Controls` is the only symbol any test file used from the include, and it now resolves via the new top-level constant assignment.

After the edit, the file ends:

```ruby
require 'test_bench'; TestBench.activate

Controls = Constant::Controls
```

- [ ] **Step 9: Run the existing suite — must pass unchanged**

Run: `ruby test/automated.rb`
Expected: every existing test in `import_constant/`, `define_constant.rb`, the `macro` group, and `already_included` passes. This is the proof that the module → class conversion is behavior-neutral.

- [ ] **Step 10: Commit**

```bash
git add lib/constant/constant.rb \
        lib/constant.rb \
        lib/constant/define.rb \
        lib/constant/import.rb \
        lib/constant/import/macro.rb \
        lib/constant/log.rb \
        lib/constant/controls/constant.rb \
        test/test_init.rb
git commit -m "Convert Constant from module to class"
```

---

## Task 2: Add `Constant.new` and `#value`

**Files:**
- Modify: `lib/constant/constant.rb`
- Create: `test/automated/constant/value.rb`

- [ ] **Step 1: Write the failing test**

Create `test/automated/constant/value.rb`:

```ruby
require_relative "../automated_init"

context "Constant" do
  context "#value" do
    example_module = Controls::Constant.example()

    constant = Constant.new(example_module)

    comment "Example Module: #{example_module.inspect}"
    comment "Constant Value: #{constant.value.inspect}"

    test "Returns the wrapped module" do
      assert(constant.value.equal?(example_module))
    end
  end
end
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `ruby test/automated/constant/value.rb`
Expected: failure — `NoMethodError: undefined method 'new' for class Constant` (or `undefined method 'value' for #<Constant>` if `new` happens to work).

- [ ] **Step 3: Implement the initializer and reader**

Edit `lib/constant/constant.rb`:

```ruby
class Constant
  def initialize(value)
    @value = value
  end

  attr_reader :value
end
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `ruby test/automated/constant/value.rb`
Expected: PASS.

Run the full suite as a regression check: `ruby test/automated.rb` — all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/constant/constant.rb test/automated/constant/value.rb
git commit -m "Constant.new wraps a value; #value reads it back"
```

---

## Task 3: Add `#name`

**Files:**
- Modify: `lib/constant/constant.rb`
- Create: `test/automated/constant/name.rb`

- [ ] **Step 1: Write the failing test**

Create `test/automated/constant/name.rb`:

```ruby
require_relative "../automated_init"

context "Constant" do
  context "#name" do
    outer_module = Controls::Constant.example(name: "Outer")
    inner_module_name = :Inner
    outer_module.const_set(inner_module_name, Module.new)
    inner_module = outer_module.const_get(inner_module_name)

    constant = Constant.new(inner_module)

    comment "Inner Module Full Name: #{inner_module.name.inspect}"
    comment "Constant Name: #{constant.name.inspect}"

    test "Returns the last `::`-segment of the value's name as a Symbol" do
      assert(constant.name == inner_module_name)
    end
  end
end
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `ruby test/automated/constant/name.rb`
Expected: failure — `NoMethodError: undefined method 'name' for #<Constant>`.

- [ ] **Step 3: Implement `#name`**

Add to the `Constant` class body in `lib/constant/constant.rb`:

```ruby
def name
  value.name.split("::").last.to_sym
end
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `ruby test/automated/constant/name.rb`
Expected: PASS.

Regression: `ruby test/automated.rb` — all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/constant/constant.rb test/automated/constant/name.rb
git commit -m "#name returns the unqualified value name as a Symbol"
```

---

## Task 4: Add `#namespace`

**Files:**
- Modify: `lib/constant/constant.rb`
- Create: `test/automated/constant/namespace.rb`

- [ ] **Step 1: Write the failing test**

Create `test/automated/constant/namespace.rb`:

```ruby
require_relative "../automated_init"

context "Constant" do
  context "#namespace" do
    context "Nested constant" do
      outer_module = Controls::Constant.example(name: "Outer")
      outer_module.const_set(:Inner, Module.new)
      inner_module = outer_module.const_get(:Inner)

      constant = Constant.new(inner_module)

      comment "Inner Module Full Name: #{inner_module.name.inspect}"
      comment "Constant Namespace: #{constant.namespace.inspect}"

      test "Returns the containing module" do
        assert(constant.namespace.equal?(outer_module))
      end
    end

    context "Top-level constant" do
      top_level_module = Controls::Constant.example()

      constant = Constant.new(top_level_module)

      comment "Top-Level Module Full Name: #{top_level_module.name.inspect}"
      comment "Constant Namespace: #{constant.namespace.inspect}"

      test "Returns Object" do
        assert(constant.namespace.equal?(Object))
      end
    end
  end
end
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `ruby test/automated/constant/namespace.rb`
Expected: failure — `NoMethodError: undefined method 'namespace' for #<Constant>`.

- [ ] **Step 3: Implement `#namespace`**

Add to the `Constant` class body in `lib/constant/constant.rb`:

```ruby
def namespace
  segments = value.name.split("::")
  return Object if segments.size == 1

  outer_path = segments[0..-2].join("::")
  Object.const_get(outer_path)
end
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `ruby test/automated/constant/namespace.rb`
Expected: PASS — both contexts (nested and top-level) pass.

Regression: `ruby test/automated.rb` — all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/constant/constant.rb test/automated/constant/namespace.rb
git commit -m "#namespace returns the containing module, or Object for top-level"
```

---

## Task 5: Add `Constant.build` — module/class form

**Files:**
- Modify: `lib/constant/constant.rb`
- Create: `test/automated/constant/build.rb`

- [ ] **Step 1: Write the failing test**

Create `test/automated/constant/build.rb`:

```ruby
require_relative "../automated_init"

context "Constant" do
  context ".build" do
    context "Module or Class given" do
      example_module = Controls::Constant.example()

      constant = Constant.build(example_module)

      comment "Example Module: #{example_module.inspect}"
      comment "Constant Value: #{constant.value.inspect}"

      test "Wraps the given module" do
        assert(constant.value.equal?(example_module))
      end
    end
  end
end
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `ruby test/automated/constant/build.rb`
Expected: failure — `NoMethodError: undefined method 'build' for class Constant`.

- [ ] **Step 3: Implement the module/class branch of `Constant.build`**

Add to `lib/constant/constant.rb`:

```ruby
def self.build(name_or_value, namespace = Object, inherit: false)
  if name_or_value.is_a?(Module)
    return new(name_or_value)
  end
end
```

The name-form branch is intentionally absent; Task 6 adds it.

- [ ] **Step 4: Run the test to verify it passes**

Run: `ruby test/automated/constant/build.rb`
Expected: PASS.

Regression: `ruby test/automated.rb` — all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/constant/constant.rb test/automated/constant/build.rb
git commit -m "Constant.build wraps a given module or class"
```

---

## Task 6: Add `Constant.build` — name form, defaults, inherit, `Constant::Error`

**Files:**
- Modify: `lib/constant/constant.rb`
- Modify: `test/automated/constant/build.rb`

- [ ] **Step 1: Extend the failing test**

Append new contexts to `test/automated/constant/build.rb`, inside the existing `context ".build"` block (after the `context "Module or Class given"` block):

```ruby
    context "Name given" do
      context "Resolves to a module" do
        outer_module = Controls::Constant.example(name: "Outer")
        outer_module.const_set(:Inner, Module.new)
        inner_module = outer_module.const_get(:Inner)

        constant = Constant.build(:Inner, outer_module)

        test "Wraps the resolved module" do
          assert(constant.value.equal?(inner_module))
        end
      end

      context "Default namespace is Object" do
        top_level_module = Controls::Constant.example()
        top_level_name = top_level_module.name.to_sym

        constant = Constant.build(top_level_name)

        test "Resolves the name in Object" do
          assert(constant.value.equal?(top_level_module))
        end
      end

      context "Inherit follows the ancestor chain" do
        parent_module = Module.new
        parent_module.const_set(:Inherited, Module.new)
        inherited_value = parent_module.const_get(:Inherited)

        child_module = Controls::Constant.example()
        child_module.include(parent_module)

        constant = Constant.build(:Inherited, child_module, inherit: true)

        test "Resolves via the ancestor chain" do
          assert(constant.value.equal?(inherited_value))
        end
      end

      context "Name is not defined" do
        empty_module = Controls::Constant.example()

        test "Raises Constant::Error" do
          assert_raises(Constant::Error) do
            Constant.build(:Nonexistent, empty_module)
          end
        end
      end

      context "Name resolves to a non-module value" do
        host_module = Controls::Constant.example()
        host_module.const_set(:NotAModule, 42)

        test "Raises Constant::Error" do
          assert_raises(Constant::Error) do
            Constant.build(:NotAModule, host_module)
          end
        end
      end
    end
```

- [ ] **Step 2: Run the test to verify the new contexts fail**

Run: `ruby test/automated/constant/build.rb`
Expected: the "Module or Class given" context still passes; every new context fails. Concretely the "Resolves to a module" test fails with `NoMethodError: undefined method 'value' for nil` (because the current `build` falls through and returns `nil` for non-Module input). The Error contexts fail because `Constant::Error` isn't defined yet.

- [ ] **Step 3: Define `Constant::Error` and the name-form branch**

Update `lib/constant/constant.rb`. The full file should now be:

```ruby
class Constant
  Error = Class.new(RuntimeError)

  def self.build(name_or_value, namespace = Object, inherit: false)
    if name_or_value.is_a?(Module)
      return new(name_or_value)
    end

    name = name_or_value.to_sym

    unless namespace.const_defined?(name, inherit)
      raise Error, "#{name} is not defined in #{namespace}"
    end

    value = namespace.const_get(name, inherit)

    unless value.is_a?(Module)
      raise Error, "#{name} is not defined in #{namespace}"
    end

    new(value)
  end

  def initialize(value)
    @value = value
  end

  attr_reader :value

  def name
    value.name.split("::").last.to_sym
  end

  def namespace
    segments = value.name.split("::")
    return Object if segments.size == 1

    outer_path = segments[0..-2].join("::")
    Object.const_get(outer_path)
  end
end
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `ruby test/automated/constant/build.rb`
Expected: PASS — all contexts including the Error cases.

Regression: `ruby test/automated.rb` — all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/constant/constant.rb test/automated/constant/build.rb
git commit -m "Constant.build resolves a name within a namespace; raises Constant::Error on miss"
```

---

## Task 7: Add class-level `Constant.defined?`

**Files:**
- Modify: `lib/constant/constant.rb`
- Create: `test/automated/constant/defined.rb`

- [ ] **Step 1: Write the failing test**

Create `test/automated/constant/defined.rb`:

```ruby
require_relative "../automated_init"

context "Constant" do
  context ".defined?" do
    host_module = Controls::Constant.example()
    host_module.const_set(:Present, Module.new)
    host_module.const_set(:NotAModule, 42)

    comment "Host Module: #{host_module.inspect}"

    context "Name is bound to a module" do
      test "Returns true" do
        assert(Constant.defined?(:Present, host_module))
      end
    end

    context "Name is bound to a non-module value" do
      test "Returns true (existence check ignores value type)" do
        assert(Constant.defined?(:NotAModule, host_module))
      end
    end

    context "Name is not bound" do
      test "Returns false" do
        refute(Constant.defined?(:Absent, host_module))
      end
    end

    context "Default namespace is Object" do
      top_level_module = Controls::Constant.example()
      top_level_name = top_level_module.name.to_sym

      test "Resolves the name in Object" do
        assert(Constant.defined?(top_level_name))
      end
    end
  end
end
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `ruby test/automated/constant/defined.rb`
Expected: failure — `NoMethodError: undefined method 'defined?' for class Constant`.

- [ ] **Step 3: Implement class-level `defined?`**

Add to the `Constant` class body in `lib/constant/constant.rb`:

```ruby
def self.defined?(name, namespace = Object, inherit: false)
  namespace.const_defined?(name.to_sym, inherit)
end
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `ruby test/automated/constant/defined.rb`
Expected: PASS.

Regression: `ruby test/automated.rb` — all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/constant/constant.rb test/automated/constant/defined.rb
git commit -m "Class-level Constant.defined? reports name-binding without raising"
```

---

## Task 8: Add instance `#defined?`

**Files:**
- Modify: `lib/constant/constant.rb`
- Modify: `test/automated/constant/defined.rb`

- [ ] **Step 1: Extend the failing test**

Append a new top-level context to `test/automated/constant/defined.rb` (after the closing `end` of `context ".defined?"`):

```ruby
context "Constant" do
  context "#defined?" do
    host_module = Controls::Constant.example()
    host_module.const_set(:Inner, Module.new)
    inner_value = host_module.const_get(:Inner)

    different_namespace = Controls::Constant.example()

    inner_constant = Constant.new(inner_value)

    comment "Host Module: #{host_module.inspect}"
    comment "Different Namespace: #{different_namespace.inspect}"
    comment "Inner Constant Name: #{inner_constant.name.inspect}"

    context "Name is bound in the supplied namespace" do
      test "Returns true" do
        assert(inner_constant.defined?(in: host_module))
      end
    end

    context "Name is not bound in the supplied namespace" do
      test "Returns false" do
        refute(inner_constant.defined?(in: different_namespace))
      end
    end

    context "Missing in: keyword" do
      test "Raises ArgumentError" do
        assert_raises(ArgumentError) do
          inner_constant.defined?
        end
      end
    end
  end
end
```

- [ ] **Step 2: Run the test to verify the new contexts fail**

Run: `ruby test/automated/constant/defined.rb`
Expected: the class-level `.defined?` contexts still pass; the new instance `#defined?` contexts fail with `NoMethodError: undefined method 'defined?' for #<Constant>`.

- [ ] **Step 3: Implement instance `#defined?`**

Add to the `Constant` class body in `lib/constant/constant.rb`:

```ruby
def defined?(inherit: false, **kwargs)
  unless kwargs.key?(:in)
    raise ArgumentError, "missing keyword: :in"
  end

  namespace = kwargs[:in]
  self.class.defined?(name, namespace, inherit: inherit)
end
```

`in` is a Ruby reserved word, so the namespace argument is read out of `**kwargs` — the same technique `Constant::Import` already uses for the reserved `alias:` keyword.

- [ ] **Step 4: Run the test to verify it passes**

Run: `ruby test/automated/constant/defined.rb`
Expected: PASS — all contexts.

Regression: `ruby test/automated.rb` — all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/constant/constant.rb test/automated/constant/defined.rb
git commit -m "Instance #defined? delegates to the class-level predicate via in: keyword"
```

---

## Task 9: Extend `Controls::Constant` to seed non-module inner constants

**Files:**
- Modify: `lib/constant/controls/constant.rb`

**Rationale:** Tasks 10 and 11 need to verify that `#constant_names` and `#constants` exclude inner constants whose values are not modules/classes. The control currently seeds every inner constant with `Module.new`. Add a separate `inner_values:` keyword for arbitrary-value bindings, leaving the existing `inner_constants:` keyword (Symbol list → Modules) untouched so all existing tests keep working.

This task ships the tool change only; the tests that exercise it ship in Tasks 10 and 11.

- [ ] **Step 1: Extend the example helper**

Replace the body of `lib/constant/controls/constant.rb` with:

```ruby
class Constant
  module Controls
    module Constant
      def self.example(name: nil, randomize_name: nil, inner_constants: nil, inner_values: nil)
        inner_constants ||= []
        inner_values ||= {}

        mod = Module.new

        name ||= "ExampleModule"

        if [nil, true].include?(randomize_name)
          name = "#{name}_#{SecureRandom.hex(2).upcase}"
        end

        Object.const_set(name, mod)

        if not inner_constants.empty?
          add_inner_constants(mod, inner_constants)
        end

        if not inner_values.empty?
          add_inner_values(mod, inner_values)
        end

        mod
      end

      def self.add_inner_constants(mod, inner_constants)
        inner_constants.each do |inner_constant_name|
          mod.const_set(inner_constant_name, Module.new)
        end
      end

      def self.add_inner_values(mod, inner_values)
        inner_values.each do |inner_value_name, inner_value|
          mod.const_set(inner_value_name, inner_value)
        end
      end
    end
  end
end
```

- [ ] **Step 2: Run the full suite as a regression check**

Run: `ruby test/automated.rb`
Expected: every existing test still passes — the new `inner_values:` keyword defaults to an empty Hash, so all current call sites are unaffected.

- [ ] **Step 3: Commit**

```bash
git add lib/constant/controls/constant.rb
git commit -m "Controls::Constant.example seeds non-module inner constants via inner_values"
```

---

## Task 10: Add `#constant_names`

**Files:**
- Modify: `lib/constant/constant.rb`
- Create: `test/automated/constant/constants.rb`

- [ ] **Step 1: Write the failing test**

Create `test/automated/constant/constants.rb`:

```ruby
require_relative "../automated_init"

context "Constant" do
  context "#constant_names" do
    host_module = Controls::Constant.example(
      inner_constants: %i(SomeModule SomeOtherModule),
      inner_values: { NotAModule: 42 }
    )

    constant = Constant.new(host_module)

    names = constant.constant_names

    comment "Host Module: #{host_module.inspect}"
    comment "Constant Names: #{names.inspect}"

    context "Includes inner constants that are modules" do
      test "SomeModule" do
        assert(names.include?(:SomeModule))
      end

      test "SomeOtherModule" do
        assert(names.include?(:SomeOtherModule))
      end
    end

    context "Excludes inner constants that are not modules" do
      test "NotAModule is excluded" do
        refute(names.include?(:NotAModule))
      end
    end
  end
end
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `ruby test/automated/constant/constants.rb`
Expected: failure — `NoMethodError: undefined method 'constant_names' for #<Constant>`.

- [ ] **Step 3: Implement `#constant_names`**

Add to the `Constant` class body in `lib/constant/constant.rb`:

```ruby
def constant_names(inherit: false)
  value.constants(inherit).select do |inner_name|
    value.const_get(inner_name, inherit).is_a?(Module)
  end
end
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `ruby test/automated/constant/constants.rb`
Expected: PASS — both inclusion and exclusion contexts.

Regression: `ruby test/automated.rb` — all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/constant/constant.rb test/automated/constant/constants.rb
git commit -m "#constant_names returns inner module names, excluding non-module bindings"
```

---

## Task 11: Add `#constants`

**Files:**
- Modify: `lib/constant/constant.rb`
- Modify: `test/automated/constant/constants.rb`

- [ ] **Step 1: Extend the failing test**

Append a new top-level context to `test/automated/constant/constants.rb`:

```ruby
context "Constant" do
  context "#constants" do
    host_module = Controls::Constant.example(
      inner_constants: %i(SomeModule SomeOtherModule),
      inner_values: { NotAModule: 42 }
    )

    constant = Constant.new(host_module)

    inner_constants = constant.constants

    comment "Host Module: #{host_module.inspect}"
    comment "Inner Constants: #{inner_constants.inspect}"

    context "Returned items are Constant instances" do
      test "All entries are Constant" do
        assert(inner_constants.all? { |c| c.is_a?(Constant) })
      end
    end

    context "1:1 correspondence with #constant_names" do
      inner_names = constant.constant_names

      test "Same names, regardless of order" do
        assert(inner_constants.map(&:name).sort == inner_names.sort)
      end
    end

    context "Excludes non-module inner constants" do
      test "No Constant wraps NotAModule" do
        refute(inner_constants.any? { |c| c.name == :NotAModule })
      end
    end
  end
end
```

- [ ] **Step 2: Run the test to verify the new contexts fail**

Run: `ruby test/automated/constant/constants.rb`
Expected: `#constant_names` contexts still pass; the `#constants` contexts fail with `NoMethodError: undefined method 'constants' for #<Constant>`.

- [ ] **Step 3: Implement `#constants`**

Add to the `Constant` class body in `lib/constant/constant.rb`:

```ruby
def constants(inherit: false)
  constant_names(inherit: inherit).map do |inner_name|
    Constant.new(value.const_get(inner_name, inherit))
  end
end
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `ruby test/automated/constant/constants.rb`
Expected: PASS — all contexts.

Regression: `ruby test/automated.rb` — all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/constant/constant.rb test/automated/constant/constants.rb
git commit -m "#constants returns Constant instances for inner module bindings"
```

---

## Task 12: Document the `Constant` class in `README.md`

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Add a `Constant` class section to the README**

Insert a new top-level section into `README.md`, placed after the existing `## Constant::Import` and `## Defining a Constant` sections and before the `## Log Tags` section. Use the following content:

````markdown
## Constant Class

A `Constant` is a stateful object that wraps a resolved module or class and answers queries about it: its unqualified name, its containing namespace, whether its name is bound in some other namespace, and which of its inner constants are themselves modules or classes.

### Building a Constant

`Constant.build` accepts either a module/class directly or a name to resolve within a namespace.

```ruby
mod = Constant.build(SomeModule)
mod.value  # => SomeModule

mod = Constant.build(:SomeInnerModule, SomeModule)
mod.value  # => SomeModule::SomeInnerModule
```

The `inherit:` keyword (default `false`) governs whether name resolution follows the ancestor chain. If the name is not bound, or if it resolves to a value that is not a module or class, `Constant::Error` is raised.

### Name and Namespace

```ruby
constant = Constant.build(:Baz, Foo::Bar)
constant.name       # => :Baz
constant.namespace  # => Foo::Bar
```

For a top-level constant, `#namespace` returns `Object`.

### Querying Name Bindings

The class-level `Constant.defined?` is a pure name-existence check that never raises:

```ruby
Constant.defined?(:SomeInner, SomeModule)  # => true or false
```

The instance `#defined?` answers whether the wrapped constant's name is bound in *some other* namespace — typically a collision check. The namespace is supplied through the required `in:` keyword (omitting it raises `ArgumentError`):

```ruby
source = Constant.build(SomeModule)
source.defined?(in: receiver_module)  # => true or false
```

Both forms accept an `inherit:` keyword, default `false`.

### Inner Constants

`#constant_names` returns the names of inner constants whose values are themselves modules or classes; inner constants holding non-module values are excluded.

```ruby
mod = Constant.build(SomeModule)
mod.constant_names  # => [:SomeInnerModule, :SomeOtherInnerModule]
```

`#constants` returns the same set as `Constant` instances:

```ruby
mod.constants  # => [#<Constant>, #<Constant>]
```

Both default `inherit` to `false`.
````

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "Document the Constant class in the README"
```

---

## Final verification

After Task 12, run the full suite once more:

```
ruby test/automated.rb
```

Every existing and new test must pass. The `Constant` class is feature-complete per the design.
