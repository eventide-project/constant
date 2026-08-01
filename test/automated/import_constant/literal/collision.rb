require_relative "../../automated_init"

context "Import Constant" do
  context "Literal" do
    context "When the destination already defines the literal constant" do
      control_literal_inner_name = "SomeLiteralConstant"

      control_literal = "some string"
      control_destination_literal = "some other string"

      control_source = Controls::Constant.example(
        name: "Source",
        inner_constants: { control_literal_inner_name => control_literal }
      )

      control_destination = Controls::Constant.example(
        name: "Destination",
        inner_constants: { control_literal_inner_name => control_destination_literal }
      )

      control_message = "#{control_literal_inner_name} is already defined on #{control_destination} (imported from #{control_source})"

      comment "Source Constant: #{control_source.inspect}"
      comment "Destination Constant: #{control_destination.inspect}"
      comment "Literal Inner Constant Name: #{control_literal_inner_name.inspect}"
      comment "Literal: #{control_literal.inspect}"
      comment "Destination Literal: #{control_destination_literal.inspect}"
      comment "Control Message: #{control_message.inspect}"

      test "Fails" do
        assert_raises(Constant::Error, control_message) do
          Constant::Import.(control_source, control_destination)
        end
      end
    end
  end
end
