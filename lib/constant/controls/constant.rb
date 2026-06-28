class Constant
  module Controls
    module Constant
      def self.example(name: nil, randomize_name: nil, inner_constants: nil)
        inner_constants ||= []

        mod = Module.new

        name ||= "ExampleModule"

        if [nil, true].include?(randomize_name)
          name = "#{name}_#{SecureRandom.hex(2).upcase}"
        end

        Object.const_set(name, mod)

        if not inner_constants.empty?
          add_inner_constants(mod, inner_constants)
        end

        mod
      end

      def self.add_inner_constants(mod, inner_constants)
        if inner_constants.is_a?(Hash)
          inner_constants.each do |inner_constant_name, inner_constant_value|
            mod.const_set(inner_constant_name, inner_constant_value)
          end
        else
          inner_constants.each do |inner_constant_name|
            inner_constant_value = Module.new
            mod.const_set(inner_constant_name, inner_constant_value)
          end
        end
      end
    end
  end
end
