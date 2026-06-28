require_relative "../../automated_init"

context "Constant" do
  context "Build" do
    control_name = "SomeConstant"
    control_value = "a string"
    control_namespace = Controls::Constant.example(inner_constants: { control_name => control_value })

    comment "Name: #{control_name.inspect}"
    comment "Namespace: #{control_namespace.inspect}"
    comment "Value: #{control_value.inspect}"

    test do
      assert_raises(Constant::Error) do
        Constant.build(control_name, control_namespace)
      end
    end
  end
end
