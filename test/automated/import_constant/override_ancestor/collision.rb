require_relative "../../automated_init"

context "Import Constant" do
  context "Override Ancestor" do
    context "When the destination inherits the constant" do
      control_collision_constant_name = "SomeInnerConstant"
      control_ancestor_name = "Ancestor"

      control_source = Controls::Constant.example(
        name: "Source",
        inner_constants: [control_collision_constant_name]
      )

      control_destination = Controls::Constant.example(
        name: "Destination",
        ancestor: { control_ancestor_name => [control_collision_constant_name] }
      )

      control_ancestor = control_destination.ancestors[1]

      control_message = "#{control_collision_constant_name} is inherited by #{control_destination} from #{control_ancestor} (imported from #{control_source})"

      comment "Source Constant: #{control_source.inspect}"
      comment "Destination Constant: #{control_destination.inspect}"
      comment "\tDestination Ancestors: #{control_destination.ancestors.inspect}"
      comment "\tDestination Inner Constant Names: #{control_destination.constants(false).sort.inspect}"
      comment "Ancestor Constant: #{control_ancestor.inspect}"
      comment "Control Message: #{control_message.inspect}"

      test "Fails" do
        assert_raises(Constant::Error, control_message) do
          Constant::Import.(control_source, control_destination)
        end
      end
    end
  end
end
