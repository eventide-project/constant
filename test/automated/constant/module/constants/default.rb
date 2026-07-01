require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Constants" do
      control_module_inner_name = "SomeModuleConstant"
      control_literal_inner_name = "SomeLiteralConstant"
      control_module_inner = Controls::Constant.example
      control_literal_value = "some string"

      control_namespace = Controls::Constant.example(inner_constants: {
        control_module_inner_name => control_module_inner,
        control_literal_inner_name => control_literal_value
      })

      constant = Constant::Module.new(control_namespace)

      constants = constant.constants

      control_module_constant = Constant::Module.new(control_module_inner)

      comment "Constants: #{constants.inspect}"

      test "Is the module inner constants" do
        assert(constants == [control_module_constant])
      end
    end
  end
end
