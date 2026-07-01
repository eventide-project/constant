require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Equality" do
      control_module = Controls::Constant.example
      control_other_module = Controls::Constant.example

      constant = Constant::Module.new(control_module)
      control_other_module_constant = Constant::Module.new(control_other_module)

      equal = constant == control_other_module_constant

      comment "Control Module: #{control_module.inspect}"
      comment "Control Other Module: #{control_other_module.inspect}"

      test "Unequal when mediating different modules" do
        refute(equal)
      end
    end
  end
end
