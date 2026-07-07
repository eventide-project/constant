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

puts "Via Include"
puts "> SomeModule include Extension"
puts "SomeModule Ancestors: #{SomeModule.ancestors}"
puts "SomeModule Inner Constants: #{SomeModule.constants}"
puts "SomeModule some_method Defined: #{SomeModule.method_defined?(:some_method)}"


# Macro
module SomeOtherModule
  include Constant::Import

  import Extension
end

puts
puts "Via import Macro"
puts "> SomeOtherModule import Extension"
puts "SomeOtherModule Ancestors: #{SomeOtherModule.ancestors}"
puts "SomeOtherModule Inner Constants: #{SomeOtherModule.constants}"
puts "SomeOtherModule some_method Defined: #{SomeOtherModule.method_defined?(:some_method)}"


# API
module YetAnotherModule
  Constant::Import.(Extension, self)
end

puts
puts "Via Constant::Import API"
puts "> YetAnotherModule Constant::Import.(Extension, self)"
puts "YetAnotherModule Ancestors: #{YetAnotherModule.ancestors}"
puts "YetAnotherModule Inner Constants: #{YetAnotherModule.constants}"
puts "YetAnotherModule some_method Defined: #{YetAnotherModule.method_defined?(:some_method)}"
