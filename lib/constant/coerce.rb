module Constant
  module Coerce
    refine Kernel do
      def Constant(value, namespace=nil, inherit: nil)
        if value.is_a?(Constant)
          value
        elsif value.is_a?(::Module) || value.is_a?(::String)
          Constant.get(value, namespace, inherit: inherit)
        else
          type_name = value.nil? ? "nil" : value.class
          raise TypeError, "can't convert #{type_name} into Constant"
        end
      end
    end
  end
end
