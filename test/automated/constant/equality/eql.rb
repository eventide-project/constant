require_relative "../../automated_init"

context "Constant" do
  context "Equality" do
    control_value = Controls::Constant.example

    constant = Constant.new(control_value)
    other_constant = Constant.new(control_value)

    eql = constant.eql?(other_constant)

    comment "Control Constant: #{control_value.inspect}"

    context "Eql? when mediating for the same constant" do
      test do
        assert(eql)
      end
    end
  end
end
