require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Equality" do
      control_module = Controls::Constant.example

      constant = Constant::Module.new(control_module)
      control_module_constant = Constant::Module.new(control_module)

      eql = constant.eql?(control_module_constant)

      comment "Control Module: #{control_module.inspect}"

      test "Eql? when mediating the same module" do
        assert(eql)
      end
    end
  end
end
