module Constant
  Error = Class.new(RuntimeError)

  class << self
    alias __name name
  end

  def self.get(value, namespace=nil, inherit: nil)
    namespace ||= Object

    if value.is_a?(::Module)
      Constant::Module.build(value)
    else
      if namespace.is_a?(::Module) || namespace.is_a?(Constant)
        namespace_constant = Constant::Module.build(namespace)
      else
        namespace_constant = get(namespace)
      end

      namespace_constant.get(value, inherit: inherit)
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

    namespace = get(namespace_name_or_module).value
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
