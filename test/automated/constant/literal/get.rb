require_relative "../../automated_init"

context "Constant" do
  context "Literal" do
    context "Get" do
      control_name = "SomeConstant"
      control_value = "some string"
      control_namespace = Constant::Module.new(Controls::Constant.example)

      constant = Constant::Literal.new("OtherConstant", control_value, control_namespace)

      comment "Constant: #{constant.inspect}"
      comment "Control Name: #{control_name.inspect}"

      context "When the name is not defined" do
        test "Is an error" do
          assert_raises(Constant::Error) do
            constant.get(control_name)
          end
        end
      end
    end
  end
end
