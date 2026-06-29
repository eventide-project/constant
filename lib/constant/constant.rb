module Constant
  Error = Class.new(RuntimeError)

  class << self
    alias __name name
  end

  def self.name(mod)
    mod.name.rpartition("::").last
  end

  def self.namespace(mod)
    namespace_name = mod.name.rpartition("::").first

    if namespace_name.empty?
      Constant::Module.new(Object)
    else
      namespace_mod = Object.const_get(namespace_name)
      Constant::Module.new(namespace_mod)
    end
  end

  def self.build(name_or_module, namespace_name_or_module=nil, inherit: nil)
    namespace_name_or_module ||= Object
    inherit ||= false

    if name_or_module.is_a?(::Module)
      Constant::Module.new(name_or_module)
    else
      namespace = build(namespace_name_or_module).value

      if not namespace.const_defined?(name_or_module, inherit)
        raise Error, "#{name_or_module} is not defined in #{namespace}"
      end

      mod = namespace.const_get(name_or_module, inherit)

      if not mod.is_a?(::Module)
        raise Error, "#{name_or_module} in #{namespace} is not a module or class"
      end

      Constant::Module.new(mod)
    end
  end

  def self.defined?(name, namespace_name_or_module=nil, inherit: nil)
    namespace_name_or_module ||= Object
    inherit ||= false

    namespace = build(namespace_name_or_module).value
    namespace.const_defined?(name, inherit)
  end
end
