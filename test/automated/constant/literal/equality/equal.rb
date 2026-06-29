require_relative "../../../automated_init"

context "Constant" do
  context "Literal" do
    context "Equality" do
      control_namespace_module = Controls::Constant.example
      control_namespace = Constant::Module.new(control_namespace_module)
      control_name = "SomeConstant"
      control_value = "some string"
      control_other_value = 42

      literal = Constant::Literal.new(control_name, control_value, control_namespace)
      other_literal = Constant::Literal.new(control_name, control_other_value, control_namespace)

      equal = literal == other_literal

      comment "Literal: #{literal.inspect}"
      comment "Other Literal: #{other_literal.inspect}"

      context "Equal when the namespace and name match, regardless of value" do
        test do
          assert(equal)
        end
      end
    end
  end
end
