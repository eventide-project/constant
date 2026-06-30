require_relative "../../automated_init"

context "Constant" do
  context "Literal" do
    context "Build" do
      control_name = :SomeConstant
      control_value = "some string"
      control_namespace = Constant::Module.new(Controls::Constant.example)

      constant = Constant::Literal.build(control_name, control_value, control_namespace)

      comment "Control Name: #{control_name.inspect}"
      comment "Constant: #{constant.inspect}"

      test "Is the name symbol as a string" do
        assert(constant.name == "SomeConstant")
      end
    end
  end
end
