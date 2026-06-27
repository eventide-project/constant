require_relative "../../automated_init"

context "Constant" do
  context "Equality" do
    control_value = Controls::Constant.example

    constant = Constant.new(control_value)

    other = control_value

    equal = constant == other

    comment "Control Constant: #{control_value.inspect}"
    comment "Other (not a Constant): #{other.inspect}"

    context "Unequal when the other is not a Constant" do
      test do
        refute(equal)
      end
    end
  end
end
