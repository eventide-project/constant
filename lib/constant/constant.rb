class Constant
  include Initializer

  initializer :raw_constant

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
      new(Object.const_get(namespace_name))
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
