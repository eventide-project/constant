class Constant
  include Initializer

  initializer :raw_constant

  def name
    raw_constant.name.rpartition("::").last
  end

  def namespace
    namespace_name = raw_constant.name.rpartition("::").first

    if namespace_name.empty?
      Object
    else
      Object.const_get(namespace_name)
    end
  end
end
