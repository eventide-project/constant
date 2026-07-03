module Constant
  module Define
    def self.call(constant_name, destination_constant, constant_value=nil)
      constant_value = ::Module.new if constant_value.nil?
      destination_constant.const_set(constant_name, constant_value)
      constant_value
    end
  end
end
