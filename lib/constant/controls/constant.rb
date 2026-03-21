module Constant
  module Controls
    module Constant
      def self.example(name: nil, randomize_name: nil, &block)
        mod = Module.new

        name ||= "ExampleModule"

        if [nil, true].include?(randomize_name)
          name = "#{name}_#{SecureRandom.hex(2).upcase}"
        end

        Object.const_set(name, mod)

        if block.nil?
          return mod
        end

        dsl = Object.new

        dsl.define_singleton_method(:const) do |name|
          mod.const_set(name.to_s, Module.new)
        end

        dsl.instance_eval(&block)

        mod
      end
    end
  end
end
