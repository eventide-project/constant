module Constant
  class Module
    include Constant
    include Initializer

    initializer :value

    def name
      Constant.name(value)
    end

    def full_name
      value.name
    end

    def namespace
      Constant.namespace(value)
    end

    def self.build(mod)
      if mod.is_a?(Constant)
        mod
      else
        new(mod)
      end
    end

    def get(name, inherit: nil)
      inherit ||= false

      name = name.to_s
      head, _, rest = name.partition("::")

      if not rest.empty?
        head_constant = get(head, inherit: inherit)
        return head_constant.get(rest, inherit: inherit)
      end

      if not value.const_defined?(name, inherit)
        raise Constant::Error, "#{name} is not defined in #{value}"
      end

      resolved = value.const_get(name, inherit)

      if resolved.is_a?(::Module)
        Constant::Module.build(resolved)
      else
        Constant::Literal.build(name, resolved, self)
      end
    end

    def constants(include_literal_constants: nil, inherit: nil)
      include_literal_constants ||= false
      inherit ||= false

      constant_symbols = value.constants(inherit)

      constant_symbols.filter_map do |constant_name|
        resolved = value.const_get(constant_name, inherit)

        if resolved.is_a?(::Module)
          Constant::Module.build(resolved)
        elsif include_literal_constants
          Constant::Literal.build(constant_name, resolved, self)
        end
      end
    end

    def constant_names(include_literal_constants: nil, inherit: nil)
      include_literal_constants ||= false
      inherit ||= false

      constant_symbols = value.constants(inherit)

      constant_symbols.filter_map do |constant_symbol|
        resolved = value.const_get(constant_symbol, inherit)

        if resolved.is_a?(::Module) || include_literal_constants
          constant_symbol.to_s
        end
      end
    end

    def defined?(name_or_module, inherit: nil)
      if name_or_module.is_a?(::Module)
        inherit ||= false

        value.constants(inherit).any? do |constant_name|
          resolved = value.const_get(constant_name, inherit)
          resolved.equal?(name_or_module)
        end
      else
        Constant.defined?(name_or_module, value, inherit: inherit)
      end
    end

    def identity
      value
    end
  end
end
