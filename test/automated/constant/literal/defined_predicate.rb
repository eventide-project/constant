require_relative "../../automated_init"

context "Constant" do
  context "Literal" do
    context "Defined Predicate" do
      control_namespace_module = Controls::Constant.example
      control_namespace = Constant::Module.new(control_namespace_module)
      control_name = "SomeConstant"
      control_value = "some string"
      control_queried_name = "SomeQueriedConstant"

      literal = Constant::Literal.new(control_name, control_value, control_namespace)

      defined = literal.defined?(control_queried_name)

      comment "Literal: #{literal.inspect}"
      comment "Queried Name: #{control_queried_name.inspect}"
      comment "Defined: #{defined.inspect}"

      test "Refutes that any constant is defined within it" do
        refute(defined)
      end
    end
  end
end
