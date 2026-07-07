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

# Including a module also causes the module to be accessible
# via Object's constant lookup path, even though the constant
# was not explicitly included into Object
assert Object.const_defined?(:SomeModule, inherit=false)
assert Object.const_defined?(:SomeModule, inherit=true)
refute Object.const_defined?(:SomeInnerModule, inherit=false)
refute Object.const_defined?(:SomeInnerModule, inherit=true)
refute Object.const_defined?(:YetAnotherInnerModule, inherit=false)
refute Object.const_defined?(:YetAnotherInnerModule, inherit=true)

# Including a module also causes the module to be accessible
# via the ancestry constant lookup path of everything that
# descends from Object, which is everything
assert String.const_defined?(:SomeModule, inherit=true)
assert Hash.const_defined?(:SomeModule, inherit=true)
assert Pathname.const_defined?(:SomeModule, inherit=true)
# etc
