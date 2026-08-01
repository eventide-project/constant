require_relative "../../automated_init"

context "Import Constant" do
  context "Except" do
    context "When a constant that is not excluded is already defined on the destination" do
      control_excluded_constant_name = "SomeInnerConstant"
      control_collision_constant_name = "SomeOtherInnerConstant"

      control_inner_constant_names = [
        control_excluded_constant_name,
        control_collision_constant_name
      ]

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
      comment "Excluded Constant Name: #{control_excluded_constant_name.inspect}"
      comment "Control Message: #{control_message.inspect}"

      test "Fails" do
        assert_raises(Constant::Error, control_message) do
          Constant::Import.(control_source, control_destination, except: control_excluded_constant_name)
        end
      end
    end
  end
end
