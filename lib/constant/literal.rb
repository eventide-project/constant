module Constant
  class Literal
    include Constant
    include Initializer

    initializer :name, :value, :namespace

    def self.build(name, value, namespace)
      new(name.to_s, value, Constant::Module.build(namespace))
    end

    def full_name
      if namespace.value.equal?(Object)
        name
      else
        "#{namespace.full_name}::#{name}"
      end
    end

    def identity
      full_name
    end

    def constants(inherit: false)
      []
    end

    def get(name, inherit: false)
      raise Constant::Error, "Literal constants are primitive values. They don't support inner constants. #{name} is not defined in #{full_name}."
    end

    def defined?(name_or_module, inherit: false)
      false
    end
  end
end
