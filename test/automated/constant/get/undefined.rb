require_relative "../../automated_init"

context "Constant" do
  context "Get" do
    control_namespace = Controls::Constant.example
    control_constant_name = "SomeConstant"

    comment "Control Name: #{control_constant_name.inspect}"
    comment "Control Namespace: #{control_namespace.inspect}"

    context "When the name is not defined in the namespace" do
      test "Is an error" do
        assert_raises(Constant::Error) do
          Constant.get(control_constant_name, control_namespace)
        end
      end
    end
  end
end
