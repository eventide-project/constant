require_relative "../../automated_init"

context "Constant" do
  context "Equality" do
    control_value = Controls::Constant.example

    constant = Constant.new(control_value)
    other_constant = Constant.new(control_value)

    equal = constant == other_constant

    comment "Control Constant: #{control_value.inspect}"

    context "Equal when mediating for the same constant" do
      test do
        assert(equal)
      end
    end
  end
end
