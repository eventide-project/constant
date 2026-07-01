require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Namespace" do
      control_value = Controls::Constant.example

      constant = Constant::Module.new(control_value)

      namespace = constant.namespace
      control_namespace_constant = Constant::Module.new(Object)

      comment "Control Raw Constant: #{control_value.inspect}"
      comment "Namespace: #{namespace.inspect}"

      test "Is Object for a top-level constant" do
        assert(namespace == control_namespace_constant)
      end
    end
  end
end
