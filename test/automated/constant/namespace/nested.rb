require_relative "../../automated_init"

context "Constant" do
  context "Namespace" do
    control_inner_constant_name = "SomeConstant"
    control_module = Controls::Constant.example(inner_constants: [control_inner_constant_name])
    control_value = control_module.const_get(control_inner_constant_name)

    constant = Constant.new(control_value)

    namespace = constant.namespace

    comment "Raw Constant: #{control_value.inspect}"
    comment "Namespace: #{namespace.inspect}"

    context "Is the name of the containing namespace as a String" do
      test do
        assert(namespace == control_module.name)
      end
    end
  end
end
