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

      origin_constant = Controls::Constant.example(
        name: "Origin",
        inner_constants: control_inner_constant_names
      )

      destination_constant = Controls::Constant.example(
        name: "Destination",
        inner_constants: [control_collision_constant_name]
      )

      control_message = "#{control_collision_constant_name} is already defined on #{destination_constant} (imported from #{origin_constant})"

      comment "Origin Constant: #{origin_constant.inspect}"
      comment "\tOrigin Inner Constant Names: #{origin_constant.constants(false).sort.inspect}"
      comment "Destination Constant: #{destination_constant.inspect}"
      comment "\tDestination Inner Constant Names: #{destination_constant.constants(false).sort.inspect}"
      comment "Excluded Constant Name: #{control_excluded_constant_name.inspect}"
      comment "Control Message: #{control_message.inspect}"

      test "Fails" do
        assert_raises(Constant::Error, control_message) do
          Constant::Import.(origin_constant, destination_constant, except: control_excluded_constant_name)
        end
      end
    end
  end
end
