require_relative "../../automated_init"

using Constant::Coerce

context "Constant" do
  context "Coerce" do
    control_constant_name = "SomeConstant"
    control_namespace = Controls::Constant.example(inner_constants: [control_constant_name])
    control_value = control_namespace.const_get(control_constant_name)

    constant = Constant(control_constant_name, control_namespace)
    control_constant = Constant::Module.new(control_value)

    comment "Control Name: #{control_constant_name.inspect}"
    comment "Control Namespace: #{control_namespace.inspect}"
    comment "Constant: #{constant.inspect}"

    test "Is the Constant the name resolves to in the namespace" do
      assert(constant == control_constant)
    end
  end
end
