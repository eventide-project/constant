class Constant
  include Initializer

  initializer :raw_constant

  def name
    raw_constant.name.rpartition("::").last
  end
end
