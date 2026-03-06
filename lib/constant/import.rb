module Constant
  module Import
    def self.call(source_constant, receiver_constant)
      inherit = false

      import_constant_names = source_constant.constants(inherit)

      import_constant_names.each do |import_constant_name|
        import_constant = source_constant.const_get(import_constant_name, inherit)
        receiver_constant.const_set(import_constant_name, import_constant)
      end
    end
  end
end
