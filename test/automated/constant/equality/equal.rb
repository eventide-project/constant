require_relative "../../automated_init"

context "Constant" do
  context "Equality" do
    control_module = Controls::Constant.example

    constant = Constant.new(control_module)
    control_module_constant = Constant.new(control_module)

    equal = constant == control_module_constant

    comment "Module: #{control_module.inspect}"

    context "Equal when mediating for the same constant" do
      test do
        assert(equal)
      end
    end
  end
end
