require_relative "../../automated_init"

context "Constant" do
  context "Build" do
    control_namespace = Controls::Constant.example
    control_name = "SomeConstant"

    comment "Name: #{control_name.inspect}"
    comment "Namespace: #{control_namespace.inspect}"

    test do
      assert_raises(Constant::Error) do
        Constant.build(control_name, control_namespace)
      end
    end
  end
end
