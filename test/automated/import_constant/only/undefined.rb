require_relative "../../automated_init"

context "Import Constant" do
  context "Only" do
    context "When a named constant is not defined on the origin" do
      origin_constant = Controls::Constant.example(
        name: "Origin",
        inner_constants: %w(SomeInnerConstant)
      )

      destination_constant = Controls::Constant.example(name: "Destination")

      control_only_constant_names = %w(SomeUndefinedConstant)

      control_message = "SomeUndefinedConstant is not defined on #{origin_constant}"

      comment "Origin Constant: #{origin_constant.inspect}"
      comment "\tOrigin Inner Constant Names: #{origin_constant.constants(false).sort.inspect}"
      comment "Destination Constant: #{destination_constant.inspect}"
      comment "Only Constant Names: #{control_only_constant_names.inspect}"
      comment "Control Message: #{control_message.inspect}"

      test "Fails" do
        assert_raises(Constant::Error, control_message) do
          Constant::Import.(origin_constant, destination_constant, only: control_only_constant_names)
        end
      end
    end
  end
end
