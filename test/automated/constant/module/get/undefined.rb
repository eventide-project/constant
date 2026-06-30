require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Get" do
      control_inner_name = "SomeConstant"
      control_namespace = Controls::Constant.example

      constant = Constant::Module.new(control_namespace)

      comment "Control Inner Name: #{control_inner_name.inspect}"
      comment "Namespace: #{control_namespace.inspect}"

      context "When the name is not defined" do
        test "Is an error" do
          assert_raises(Constant::Error) do
            constant.get(control_inner_name)
          end
        end
      end
    end
  end
end
