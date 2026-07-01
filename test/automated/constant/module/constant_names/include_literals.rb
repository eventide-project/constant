require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Constant Names" do
      control_module_inner_name = "SomeModuleConstant"
      control_literal_inner_name = "SomeLiteralConstant"
      control_module_inner = Controls::Constant.example
      control_literal_value = "some string"

      control_namespace = Controls::Constant.example(inner_constants: {
        control_module_inner_name => control_module_inner,
        control_literal_inner_name => control_literal_value
      })

      constant = Constant::Module.new(control_namespace)

      constant_names = constant.constant_names(include_literal_constants: true)

      comment "Constant Names: #{constant_names.inspect}"

      test "Is the names of the module and literal inner constants" do
        assert(constant_names == [control_module_inner_name, control_literal_inner_name])
      end
    end
  end
end
