require_relative "../../automated_init"

context "Constant" do
  context "Build" do
    control_value = Controls::Constant.example

    constant = Constant.build(control_value)

    comment "Raw Constant: #{control_value.inspect}"
    comment "Constant: #{constant.inspect}"

    context "Is a Constant for the value" do
      test do
        assert(constant == Constant.new(control_value))
      end
    end
  end
end
