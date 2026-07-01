require_relative "../../automated_init"

context "Constant" do
  context "Get" do
    control_value = Controls::Constant.example

    constant = Constant.get(control_value)
    control_constant = Constant::Module.new(control_value)

    comment "Control Raw Constant: #{control_value.inspect}"
    comment "Constant: #{constant.inspect}"

    test "Is a Constant for the value" do
      assert(constant == control_constant)
    end
  end
end
