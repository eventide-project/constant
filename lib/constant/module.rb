module Constant
  class Module
    include Constant
    include Initializer

    initializer :value

    def self.build(mod)
      if mod.is_a?(Constant)
        mod
      else
        new(mod)
      end
    end

    def name
      Constant.name(value)
    end

    def get(name, inherit: false)
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

    def full_name
      value.name
    end

    def namespace
      Constant.namespace(value)
    end

    def defined?(name_or_module, inherit: false)
      if name_or_module.is_a?(::Module)
        value.constants(inherit).any? do |constant_name|
          value.const_get(constant_name, inherit).equal?(name_or_module)
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
