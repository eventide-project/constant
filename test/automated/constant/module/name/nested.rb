require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Name" do
      control_module_name = "SomeConstant"
      control_namespace = Controls::Constant.example(inner_constants: [control_module_name])
      control_module = control_namespace.const_get(control_module_name)

      constant = Constant::Module.new(control_module)

      name = constant.name

      comment "Control Module: #{control_module.inspect}"
      comment "Name: #{name.inspect}"

      test "Is the final segment of the qualified name as a String" do
        assert(name == control_module_name)
      end
    end
  end
end
