module Constant
  module Controls
    module Constant
      def self.example(&block)
        mod = Module.new

        owner = eval('Module.nesting.first || Object', block.send(:binding))

        prior_constant_names = owner.constants(false)

        if not block.nil?
          block.call
        end

        current_constant_names = owner.constants(false)
        new_constant_names = current_constant_names - prior_constant_names

        new_constant_names.each do |new_constant_name|
          new_constant = owner.const_get(new_constant_name, false)
          owner.send(:remove_const, new_constant_name)
          mod.const_set(new_constant_name, new_constant)
        end

        mod
      end
    end
  end
end
