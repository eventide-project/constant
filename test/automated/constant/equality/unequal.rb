require_relative "../../automated_init"

context "Constant" do
  context "Equality" do
    control_value = Controls::Constant.example
    other_value = Controls::Constant.example

    constant = Constant.new(control_value)
    other_constant = Constant.new(other_value)

    equal = constant == other_constant

    comment "Control Constant: #{control_value.inspect}"
    comment "Other Constant: #{other_value.inspect}"

    context "Unequal when mediating for different constants" do
      test do
        refute(equal)
      end
    end
  end
end
