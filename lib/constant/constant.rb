class Constant
  include Initializer

  initializer :raw_constant

  def name
    raw_constant.name.rpartition("::").last
  end

  def namespace
    namespace_name = raw_constant.name.rpartition("::").first

    if namespace_name.empty?
      Constant.new(Object)
    else
      Constant.new(Object.const_get(namespace_name))
    end
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
