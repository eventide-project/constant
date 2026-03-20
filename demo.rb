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

module SomeOtherModule
  Constant::Import.(Extension, self)
end

pp "SomeOtherModule Imports Extension"
pp "Ancestors: #{SomeOtherModule.ancestors}"
pp "Inner Constants: #{SomeOtherModule.constants}"
pp "some_method Defined: #{SomeOtherModule.method_defined?(:some_method)}"
