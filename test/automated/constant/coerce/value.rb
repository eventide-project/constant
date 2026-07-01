require_relative "../../automated_init"

using Constant::Coerce

context "Constant" do
  context "Coerce" do
    control_value = Controls::Constant.example

    constant = Constant(control_value)
    control_constant = Constant::Module.new(control_value)

    comment "Control Raw Constant: #{control_value.inspect}"
    comment "Constant: #{constant.inspect}"

    test "Is a Constant mediating the value" do
      assert(constant == control_constant)
    end
  end
end
