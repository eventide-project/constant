require_relative "../../automated_init"

context "Constant" do
  context "Equality" do
    control_module = Controls::Constant.example

    constant = Constant::Module.new(control_module)

    equal = constant == control_module

    comment "Module: #{control_module.inspect}"

    context "Unequal when the other is not a Constant" do
      test do
        refute(equal)
      end
    end
  end
end
