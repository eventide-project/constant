module Constant
  module Controls
    module Name
      module Random
        def self.call
          "Constant_#{SecureRandom.hex.upcase}"
        end
      end
    end
  end
end
