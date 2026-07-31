require_relative "../automated_init"

context "Import Constant" do
  context "Only And Except Conflict" do
    context "When a constant is named in both the only: list and the except: list" do
      control_constant_name = "SomeInnerConstant"

      origin_constant = Controls::Constant.example(
        name: "Origin",
        inner_constants: [control_constant_name]
      )

      destination_constant = Controls::Constant.example(name: "Destination")

      control_only_constant_names = [control_constant_name]
      control_except_constant_names = [control_constant_name]

      control_message = "#{control_constant_name} is named in both only: and except:"

      comment "Origin Constant: #{origin_constant.inspect}"
      comment "\tOrigin Inner Constant Names: #{origin_constant.constants(false).sort.inspect}"
      comment "Destination Constant: #{destination_constant.inspect}"
      comment "Only Constant Names: #{control_only_constant_names.inspect}"
      comment "Except Constant Names: #{control_except_constant_names.inspect}"
      comment "Control Message: #{control_message.inspect}"

      test "Fails" do
        assert_raises(Constant::Error, control_message) do
          Constant::Import.(origin_constant, destination_constant, only: control_only_constant_names, except: control_except_constant_names)
        end
      end
    end
  end
end
