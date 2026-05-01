require_relative "init"

module Extension
  def some_method
  end

  module InnerModule
  end
end

module SomeModule
  include Extension
end

pp "SomeModule Includes Extension"
pp "Ancestors: #{SomeModule.ancestors}"
pp "Inner Constants: #{SomeModule.constants}"
pp "some_method Defined: #{SomeModule.method_defined?(:some_method)}"


# Macro
module SomeOtherModule
  include Constant::Import

  import Extension
end

pp "SomeOtherModule Imports Extension"
pp "Ancestors: #{SomeOtherModule.ancestors}"
pp "Inner Constants: #{SomeOtherModule.constants}"
pp "some_method Defined: #{SomeOtherModule.method_defined?(:some_method)}"


# API
module YetAnotherModule
  Constant::Import.(Extension, self)
end

pp "YetAnotherModule Imports Extension"
pp "Ancestors: #{YetAnotherModule.ancestors}"
pp "Inner Constants: #{YetAnotherModule.constants}"
pp "some_method Defined: #{YetAnotherModule.method_defined?(:some_method)}"
