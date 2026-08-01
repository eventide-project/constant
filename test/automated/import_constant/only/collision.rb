require_relative "../../automated_init"

context "Import Constant" do
  context "Only" do
    context "When a constant in the only: list is already defined on the destination" do
      control_collision_constant_name = "SomeInnerConstant"
      control_omitted_constant_name = "SomeOtherInnerConstant"

      control_inner_constant_names = [
        control_collision_constant_name,
        control_omitted_constant_name
      ]

      control_source = Controls::Constant.example(
        name: "Source",
        inner_constants: control_inner_constant_names
      )

      control_destination = Controls::Constant.example(
        name: "Destination",
        inner_constants: [control_collision_constant_name]
      )

      control_only_constant_names = [control_collision_constant_name]

      control_message = "#{control_collision_constant_name} is already defined on #{control_destination} (imported from #{control_source})"

      comment "Source Constant: #{control_source.inspect}"
      comment "\tSource Inner Constant Names: #{control_source.constants(false).sort.inspect}"
      comment "Destination Constant: #{control_destination.inspect}"
      comment "\tDestination Inner Constant Names: #{control_destination.constants(false).sort.inspect}"
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
