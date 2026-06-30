require_relative "../../automated_init"

context "Constant" do
  context "Build" do
    control_constant_name = "SomeConstant"
    control_value = "some string"
    control_namespace = Controls::Constant.example(inner_constants: { control_constant_name => control_value })

    constant = Constant.build(control_constant_name, control_namespace)

    control_literal_namespace = Constant::Module.new(control_namespace)
    control_literal = Constant::Literal.new(control_constant_name, control_value, control_literal_namespace)

    comment "Control Constant Name: #{control_constant_name.inspect}"
    comment "Control Value: #{control_value.inspect}"
    comment "Constant: #{constant.inspect}"

    test "Is the literal constant the name resolves to" do
      assert(constant == control_literal)
    end

    test "Is the value the name resolves to" do
      assert(constant.value == control_value)
    end
  end
end
