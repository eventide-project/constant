require_relative "../../../automated_init"

context "Constant" do
  context "Literal" do
    context "Equality" do
      control_namespace_module = Controls::Constant.example
      control_namespace = Constant::Module.new(control_namespace_module)
      control_name = "SomeConstant"
      control_value = "some string"

      literal = Constant::Literal.new(control_name, control_value, control_namespace)

      equal = literal == control_value

      comment "Literal: #{literal.inspect}"

      test "Unequal when the other is not a Constant" do
        refute(equal)
      end
    end
  end
end
