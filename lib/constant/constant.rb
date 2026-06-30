module Constant
  Error = Class.new(RuntimeError)

  class << self
    alias __name name
  end

  def self.build(name_or_module, namespace_name_or_module=nil, inherit: nil)
    namespace_name_or_module ||= Object
    inherit ||= false

    if name_or_module.is_a?(::Module)
      Constant::Module.new(name_or_module)
    else
      namespace_constant = build(namespace_name_or_module)
      namespace = namespace_constant.value

      if not namespace.const_defined?(name_or_module, inherit)
        raise Error, "#{name_or_module} is not defined in #{namespace}"
      end

      value = namespace.const_get(name_or_module, inherit)

      if value.is_a?(::Module)
        Constant::Module.new(value)
      else
        Constant::Literal.new(name_or_module, value, namespace_constant)
      end
    end
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

  def self.defined?(name, namespace_name_or_module=nil, inherit: nil)
    namespace_name_or_module ||= Object
    inherit ||= false

    namespace = build(namespace_name_or_module).value
    namespace.const_defined?(name, inherit)
  end

  def ==(other)
    other.is_a?(Constant) && identity == other.identity
  end

  def eql?(other)
    self == other
  end

  def hash
    identity.hash
  end
end
