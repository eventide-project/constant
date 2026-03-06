module Constant
  module Controls
    module Constant
      module Random
        def self.call()
          constant_name = Name::Random.()

          receiver_constant = self

          mod = Module.new

          receiver_constant.const_set(constant_name, mod)
        end
      end
    end
  end
end
