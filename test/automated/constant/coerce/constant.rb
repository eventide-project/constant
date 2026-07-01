require_relative "../../automated_init"

using Constant::Coerce

context "Constant" do
  context "Coerce" do
    control_value = Controls::Constant.example
    control_constant = Constant::Module.new(control_value)

    constant = Constant(control_constant)

    comment "Control Constant: #{control_constant.inspect}"
    comment "Constant: #{constant.inspect}"

    test "Is the given Constant" do
      assert(constant.equal?(control_constant))
    end
  end
end
