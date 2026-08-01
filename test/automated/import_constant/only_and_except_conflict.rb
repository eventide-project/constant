require_relative "../automated_init"

context "Import Constant" do
  context "Only And Except Conflict" do
    context "When a constant is named in both the only: list and the except: list" do
      control_constant_name = "SomeInnerConstant"

      control_source = Controls::Constant.example(
        name: "Source",
        inner_constants: [control_constant_name]
      )

      control_destination = Controls::Constant.example(name: "Destination")

      control_only_constant_names = [control_constant_name]
      control_except_constant_names = [control_constant_name]

      control_message = "#{control_constant_name} is named in both only: and except:"

      comment "Source Constant: #{control_source.inspect}"
      comment "\tSource Inner Constant Names: #{control_source.constants(false).sort.inspect}"
      comment "Destination Constant: #{control_destination.inspect}"
      comment "Only Constant Names: #{control_only_constant_names.inspect}"
      comment "Except Constant Names: #{control_except_constant_names.inspect}"
      comment "Control Message: #{control_message.inspect}"

      test "Fails" do
        assert_raises(Constant::Error, control_message) do
          Constant::Import.(control_source, control_destination, only: control_only_constant_names, except: control_except_constant_names)
        end
      end
    end
  end
end
