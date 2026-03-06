module Constant
  module Define
    def self.call(constant_name, receiver_constant, constant=nil)
      constant ||= Module.new

      receiver_constant.const_set(constant_name, constant)
    end
  end
end
