class Constant
  include Initializer

  initializer :raw_constant

  Error = Class.new(RuntimeError)

  class << self
    alias_method :__name, :name
  end

  def self.name(raw_constant)
    raw_constant.name.rpartition("::").last
  end

  def self.namespace(raw_constant)
    namespace_name = raw_constant.name.rpartition("::").first

    if namespace_name.empty?
      new(Object)
    else
      namespace_constant = Object.const_get(namespace_name)
      new(namespace_constant)
    end
  end

  def self.build(name_or_raw_constant, namespace_name_or_raw_constant=nil, inherit: nil)
    namespace_name_or_raw_constant ||= Object
    inherit ||= false

    if name_or_raw_constant.is_a?(Module)
      new(name_or_raw_constant)
    else
      namespace = build(namespace_name_or_raw_constant).raw_constant

      if not namespace.const_defined?(name_or_raw_constant, inherit)
        raise Error, "#{name_or_raw_constant} is not defined in #{namespace}"
      end

      raw_constant = namespace.const_get(name_or_raw_constant, inherit)

      if not raw_constant.is_a?(Module)
        raise Error, "#{name_or_raw_constant} in #{namespace} is not a module or class"
      end

      new(raw_constant)
    end
  end

  def name
    self.class.name(raw_constant)
  end

  def full_name
    raw_constant.name
  end

  def namespace
    self.class.namespace(raw_constant)
  end

  def ==(other)
    other.is_a?(Constant) && raw_constant == other.raw_constant
  end

  def eql?(other)
    self == other
  end

  def hash
    raw_constant.hash
  end
end
