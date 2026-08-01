require_relative "../../automated_init"

context "Import Constant" do
  context "Only" do
    context "When a named constant is not defined on the source" do
      control_source = Controls::Constant.example(
        name: "Source",
        inner_constants: %w(SomeInnerConstant)
      )

      control_destination = Controls::Constant.example(name: "Destination")

      control_only_constant_names = %w(SomeUndefinedConstant)

      control_message = "SomeUndefinedConstant is not defined on #{control_source}"

      comment "Source Constant: #{control_source.inspect}"
      comment "\tSource Inner Constant Names: #{control_source.constants(false).sort.inspect}"
      comment "Destination Constant: #{control_destination.inspect}"
      comment "Only Constant Names: #{control_only_constant_names.inspect}"
      comment "Control Message: #{control_message.inspect}"

      test "Fails" do
        assert_raises(Constant::Error, control_message) do
          Constant::Import.(control_source, control_destination, only: control_only_constant_names)
        end
      end
    end
  end
end
