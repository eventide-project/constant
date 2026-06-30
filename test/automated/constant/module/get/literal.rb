require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Get" do
      control_inner_name = "SomeConstant"
      control_value = "some string"
      control_namespace = Controls::Constant.example(inner_constants: { control_inner_name => control_value })

      constant = Constant::Module.new(control_namespace)

      inner = constant.get(control_inner_name)

      control_literal_namespace = Constant::Module.new(control_namespace)
      control_literal = Constant::Literal.new(control_inner_name, control_value, control_literal_namespace)

      comment "Inner: #{inner.inspect}"

      test "Is a Constant mediating the resolved inner literal constant" do
        assert(inner == control_literal)
      end
    end
  end
end
