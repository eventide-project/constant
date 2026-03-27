module Constant
  module Import
    Error = Class.new(RuntimeError)

    def self.included(base)
      base.extend(Macro)
    end

    module Macro
      def __import_constant(source_constant, **kwargs)
        Import.(source_constant, self, **kwargs)
      end

      alias import __import_constant
    end

    def self.call(source_constant, receiver_constant, **kwargs)
      alias_name = kwargs[:alias]

      if alias_name.nil? && receiver_constant.ancestors.include?(source_constant)
        raise Error, "#{receiver_constant} already includes #{source_constant}"
      end

      target = receiver_constant

      if not alias_name.nil?
        target = Define.(alias_name, receiver_constant)
      end

      inherit = false

      import_constant_names = source_constant.constants(inherit)

      imported_constants = import_constant_names.map do |import_constant_name|
        import_constant = source_constant.const_get(import_constant_name, inherit)
        target.const_set(import_constant_name, import_constant)
        import_constant
      end

      imported_constants
    end
  end
end
