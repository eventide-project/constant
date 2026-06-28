require_relative "../../automated_init"

context "Constant" do
  context "Build" do
    control_inner_constant_name = "SomeConstant"
    control_namespace = Controls::Constant.example(inner_constants: [control_inner_constant_name])
    control_value = control_namespace.const_get(control_inner_constant_name)

    constant = Constant.build(control_inner_constant_name, control_namespace)

    comment "Name: #{control_inner_constant_name.inspect}"
    comment "Namespace: #{control_namespace.inspect}"
    comment "Constant: #{constant.inspect}"

    test do
      assert(constant == Constant.new(control_value))
    end
  end
end
