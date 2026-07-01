require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Equality" do
      control_module = Controls::Constant.example

      constant = Constant::Module.new(control_module)

      equal = constant == control_module

      comment "Module: #{control_module.inspect}"

      test "Unequal when the other is not a Constant" do
        refute(equal)
      end
    end
  end
end
