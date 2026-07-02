module Constant
  module Define
    def self.call(constant_name, destination_constant)
      constant = ::Module.new
      destination_constant.const_set(constant_name, constant)
      constant
    end
  end
end
