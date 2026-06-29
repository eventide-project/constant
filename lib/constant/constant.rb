class Constant
  include Initializer

  initializer :mod

  Error = Class.new(RuntimeError)

  class << self
    alias_method :__name, :name
  end

  def self.name(mod)
    mod.name.rpartition("::").last
  end

  def self.namespace(mod)
    namespace_name = mod.name.rpartition("::").first

    if namespace_name.empty?
      new(Object)
    else
      namespace_mod = Object.const_get(namespace_name)
      new(namespace_mod)
    end
  end

  def self.build(name_or_module, namespace_name_or_module=nil, inherit: nil)
    namespace_name_or_module ||= Object
    inherit ||= false

    if name_or_module.is_a?(Module)
      new(name_or_module)
    else
      namespace = build(namespace_name_or_module).mod

      if not namespace.const_defined?(name_or_module, inherit)
        raise Error, "#{name_or_module} is not defined in #{namespace}"
      end

      mod = namespace.const_get(name_or_module, inherit)

      if not mod.is_a?(Module)
        raise Error, "#{name_or_module} in #{namespace} is not a module or class"
      end

      new(mod)
    end
  end

  def self.defined?(name, namespace_name_or_module=nil, inherit: nil)
    namespace_name_or_module ||= Object
    inherit ||= false

    namespace = build(namespace_name_or_module).mod
    namespace.const_defined?(name, inherit)
  end

  def name
    self.class.name(mod)
  end

  def full_name
    mod.name
  end

  def namespace
    self.class.namespace(mod)
  end

  def ==(other)
    other.is_a?(Constant) && mod == other.mod
  end

  def eql?(other)
    self == other
  end

  def hash
    mod.hash
  end
end
