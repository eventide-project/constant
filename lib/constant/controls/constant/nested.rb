module Constant
  module Controls
    module Constant
      module Nested
        def self.example(inner_name:, leaf_name:, leaf_value:)
          namespace = Controls::Constant.example

          inner = ::Module.new
          namespace.const_set(inner_name, inner)
          inner.const_set(leaf_name, leaf_value)

          namespace
        end
      end
    end
  end
end
