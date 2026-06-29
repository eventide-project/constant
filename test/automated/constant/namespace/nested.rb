require_relative "../../automated_init"

context "Constant" do
  context "Namespace" do
    control_constant_name = "SomeConstant"
    control_namespace = Controls::Constant.example(inner_constants: [control_constant_name])
    control_value = control_namespace.const_get(control_constant_name)

    constant = Constant::Module.new(control_value)

    namespace = constant.namespace
    control_namespace_constant = Constant::Module.new(control_namespace)

    comment "Raw Constant: #{control_value.inspect}"
    comment "Namespace: #{namespace.inspect}"

    context "Is the constant that contains the value" do
      test do
        assert(namespace == control_namespace_constant)
      end
    end
  end
end
