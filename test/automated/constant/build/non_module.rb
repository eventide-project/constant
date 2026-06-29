require_relative "../../automated_init"

context "Constant" do
  context "Build" do
    control_constant_name = "SomeConstant"
    control_value = "some string"
    control_namespace = Controls::Constant.example(inner_constants: { control_constant_name => control_value })

    comment "Name: #{control_constant_name.inspect}"
    comment "Namespace: #{control_namespace.inspect}"
    comment "Value: #{control_value.inspect}"

    context "Raises when the name resolves to a non-module value" do
      test do
        assert_raises(Constant::Error) do
          Constant.build(control_constant_name, control_namespace)
        end
      end
    end
  end
end
