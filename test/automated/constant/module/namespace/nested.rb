require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Namespace" do
      control_constant_name = "SomeConstant"
      control_namespace = Controls::Constant.example(inner_constants: [control_constant_name])
      control_value = control_namespace.const_get(control_constant_name)

      constant = Constant::Module.new(control_value)

      namespace = constant.namespace
      control_namespace_constant = Constant::Module.new(control_namespace)

      comment "Control Raw Constant: #{control_value.inspect}"
      comment "Namespace: #{namespace.inspect}"

      test "Is the constant that contains the value" do
        assert(namespace == control_namespace_constant)
      end
    end
  end
end
