require_relative "../automated_init"

context "Import Constant" do
  context "Collision" do
    control_collision_constant_name = "SomeInnerConstant"

    control_inner_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    control_source = Controls::Constant.example(
      name: "Source",
      inner_constants: control_inner_constant_names
    )

    control_destination = Controls::Constant.example(
      name: "Destination",
      inner_constants: [control_collision_constant_name]
    )

    control_message = "#{control_collision_constant_name} is already defined on #{control_destination} (imported from #{control_source})"

    comment "Source Constant: #{control_source.inspect}"
    comment "\tSource Inner Constant Names: #{control_source.constants(false).sort.inspect}"
    comment "Destination Constant: #{control_destination.inspect}"
    comment "\tDestination Inner Constant Names: #{control_destination.constants(false).sort.inspect}"
    comment "Control Message: #{control_message.inspect}"

    context "When the destination already defines the constant" do
      test "Fails" do
        assert_raises(Constant::Error, control_message) do
          Constant::Import.(control_source, control_destination)
        end
      end
    end
  end
end
