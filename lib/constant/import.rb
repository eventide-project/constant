module Constant
  module Import
    Error = Class.new(RuntimeError)

    def self.included(base)
      base.extend(Macro)
    end

    def self.call(origin_constant, destination_constant, **kwargs)
      alias_name = kwargs[:alias]

      if alias_name.nil? && destination_constant.ancestors.include?(origin_constant)
        raise Error, "#{destination_constant} already includes #{origin_constant}"
      end

      target = destination_constant

      if not alias_name.nil?
        target = Define.(alias_name, destination_constant)
      end

      inherit = false

      import_constant_names = origin_constant.constants(inherit)

      imported_constants = import_constant_names.map do |import_constant_name|
        import_constant = origin_constant.const_get(import_constant_name, inherit)
        target.const_set(import_constant_name, import_constant)
        import_constant
      end

      imported_constants
    end
  end
end
