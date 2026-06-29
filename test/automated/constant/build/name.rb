require_relative "../../automated_init"

context "Constant" do
  context "Build" do
    control_constant_name = "SomeConstant"
    control_namespace = Controls::Constant.example(inner_constants: [control_constant_name])
    control_value = control_namespace.const_get(control_constant_name)

    constant = Constant.build(control_constant_name, control_namespace)
    control_constant = Constant::Module.new(control_value)

    comment "Name: #{control_constant_name.inspect}"
    comment "Namespace: #{control_namespace.inspect}"
    comment "Constant: #{constant.inspect}"

    context "Is the Constant the name resolves to" do
      test do
        assert(constant == control_constant)
      end
    end
  end
end
