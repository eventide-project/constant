require_relative "../../automated_init"

context "Constant" do
  context "Get" do
    control_constant_name = "SomeConstant"
    control_namespace = Controls::Constant.example(inner_constants: [control_constant_name])
    control_namespace_name = control_namespace.name

    constant = Constant.get(control_constant_name, control_namespace_name)
    namespace = constant.namespace
    control_namespace_constant = Constant::Module.new(control_namespace)

    comment "Control Constant Name: #{control_constant_name.inspect}"
    comment "Control Namespace Name: #{control_namespace_name.inspect}"
    comment "Namespace: #{namespace.inspect}"

    test "Resolves the namespace given as a name" do
      assert(namespace == control_namespace_constant)
    end
  end
end
