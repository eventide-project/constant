require_relative "init"

puts "Via Include"
puts "- - -"
puts

code = <<~CODE
  module Extension
    def some_method
    end

    module InnerModule
    end
  end

  module SomeModule
    include Extension
  end
CODE

eval code

puts code
puts

puts "SomeModule Ancestors: #{SomeModule.ancestors}"
puts "SomeModule Inner Constants: #{SomeModule.constants}"
puts "SomeModule some_method Defined: #{SomeModule.method_defined?(:some_method)}"

puts
puts "Via Macro"
puts "- - -"
puts

code = <<~CODE
  module SomeOtherModule
    include Constant::Import

    import Extension
  end
CODE

eval code

puts code
puts

puts "SomeOtherModule Ancestors: #{SomeOtherModule.ancestors}"
puts "SomeOtherModule Inner Constants: #{SomeOtherModule.constants}"
puts "SomeOtherModule some_method Defined: #{SomeOtherModule.method_defined?(:some_method)}"

puts
puts "Via API"
puts "- - -"
puts

code = <<~CODE
  module YetAnotherModule
    Constant::Import.(Extension, self)
  end
CODE

eval code

puts code
puts

puts "YetAnotherModule Ancestors: #{YetAnotherModule.ancestors}"
puts "YetAnotherModule Inner Constants: #{YetAnotherModule.constants}"
puts "YetAnotherModule some_method Defined: #{YetAnotherModule.method_defined?(:some_method)}"
