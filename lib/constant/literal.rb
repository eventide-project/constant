module Constant
  class Literal
    include Constant
    include Initializer

    initializer :value, :name, :namespace

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
  end
end
