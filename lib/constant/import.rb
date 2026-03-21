module Constant
  module Import
    def self.call(source_constant, receiver_constant, **kwargs)
      alias_name = kwargs[:alias]

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
