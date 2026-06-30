require_relative "../../../automated_init"

context "Constant" do
  context "Literal" do
    context "Build" do
      control_name = "SomeConstant"
      control_value = "some string"
      control_namespace_module = Controls::Constant.example

      constant = Constant::Literal.build(control_name, control_value, control_namespace_module)

      control_namespace = Constant::Module.new(control_namespace_module)

      comment "Control Namespace Module: #{control_namespace_module.inspect}"
      comment "Constant: #{constant.inspect}"

      test "Is the namespace module as a Constant::Module" do
        assert(constant.namespace == control_namespace)
      end
    end
  end
end
