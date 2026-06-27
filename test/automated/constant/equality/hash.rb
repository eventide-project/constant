require_relative "../../automated_init"

context "Constant" do
  context "Equality" do
    control_value = Controls::Constant.example

    constant = Constant.new(control_value)
    other_constant = Constant.new(control_value)

    equal_hashes = constant.hash == other_constant.hash

    comment "Control Constant: #{control_value.inspect}"

    context "Equal hash when mediating for the same constant" do
      test do
        assert(equal_hashes)
      end
    end
  end
end
