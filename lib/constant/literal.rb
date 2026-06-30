module Constant
  class Literal
    include Constant
    include Initializer

    initializer :name, :value, :namespace

    def self.build(name, value, namespace)
      name = name.to_s
      namespace = Constant::Module.build(namespace)
      new(name, value, namespace)
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
