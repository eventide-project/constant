require_relative "automated_init"

context "Define Constant" do
  receiver_constant = Controls::Constant::Random.()

  new_constant_name = :SomeConstant

  new_constant = Constant::Define.(new_constant_name, receiver_constant)

  defined = receiver_constant.const_defined?(new_constant_name)

  test "Defined" do
    assert(defined)
  end
end
