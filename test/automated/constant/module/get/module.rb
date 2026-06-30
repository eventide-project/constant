require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Get" do
      control_inner_name = "SomeConstant"
      control_namespace = Controls::Constant.example(inner_constants: [control_inner_name])
      control_inner_module = control_namespace.const_get(control_inner_name)

      constant = Constant::Module.new(control_namespace)

      inner = constant.get(control_inner_name)

      control_inner = Constant::Module.new(control_inner_module)

      comment "Inner: #{inner.inspect}"

      test "Is a Constant mediating the resolved inner module" do
        assert(inner == control_inner)
      end
    end
  end
end
