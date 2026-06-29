require_relative "../../automated_init"

context "Constant" do
  context "Literal" do
    context "Defined Predicate" do
      control_namespace_module = Controls::Constant.example
      control_namespace = Constant::Module.new(control_namespace_module)
      control_name = "SomeConstant"
      control_value = "a string"
      control_queried_name = "SomeQueriedConstant"

      literal = Constant::Literal.new(control_value, control_name, control_namespace)

      defined = literal.defined?(control_queried_name)

      comment "Literal: #{literal.inspect}"
      comment "Queried Name: #{control_queried_name.inspect}"
      comment "Defined: #{defined.inspect}"

      context "Refutes that any constant is defined within it" do
        test do
          refute(defined)
        end
      end
    end
  end
end
