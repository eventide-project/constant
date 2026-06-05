require_relative "../automated_init"

context "Constant" do
  context "Initialization" do
    control_value = Controls::Constant.example()

    constant = Constant.new(control_value)

    comment "Control Value: #{control_value.inspect}"
    comment "Constant Value: #{constant.value.inspect}"

    test "Value is the constant object sent to the initializer" do
      assert(constant.value.equal?(control_value))
    end
  end
end
