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

        mod.class_eval(&block) unless block.nil?

        mod
      end
    end
  end
end
