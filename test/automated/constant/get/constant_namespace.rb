require_relative "../../automated_init"

context "Constant" do
  context "Get" do
    control_constant_name = "SomeConstant"
    control_namespace_module = Controls::Constant.example(inner_constants: [control_constant_name])
    control_value = control_namespace_module.const_get(control_constant_name)

    control_constant = Constant::Module.new(control_value)

    context "When the namespace is a Constant" do
      control_namespace = Constant::Module.new(control_namespace_module)

      constant = Constant.get(control_constant_name, control_namespace)

      comment "Control Namespace: #{control_namespace.inspect}"
      comment "Constant: #{constant.inspect}"

      test "Is the Constant the name resolves to in the namespace" do
        assert(constant == control_constant)
      end
    end
  end
end
