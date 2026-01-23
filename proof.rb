require_relative "gems/bundler/setup"
require 'test_bench'; TestBench.activate

module SomeModule
  module SomeInnerModule
    module YetAnotherInnerModule
    end
  end
end

module SomeReceiver
  include SomeModule
end

assert SomeReceiver.const_defined?(:SomeModule)
assert SomeReceiver.const_defined?(:SomeInnerModule)
refute SomeReceiver.const_defined?(:YetAnotherInnerModule)

# Including a module also causes the module's to be accessible
# via Object's constant lookup path, even though the constant
# was not explicitly included into Object
assert Object.const_defined?(:SomeModule)
refute Object.const_defined?(:SomeInnerModule)
refute Object.const_defined?(:YetAnotherInnerModule)
