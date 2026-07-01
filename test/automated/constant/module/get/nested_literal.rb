require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Get" do
      control_inner_name = "SomeInnerNamespace"
      control_leaf_name  = "SomeLiteral"
      control_leaf_value = "some string"

      control_namespace = Controls::Constant.example(
        inner_constants: { control_inner_name => { control_leaf_name => control_leaf_value } })

      control_inner_module = control_namespace.const_get(control_inner_name)
      control_path = "#{control_inner_name}::#{control_leaf_name}"

      constant = Constant::Module.new(control_namespace)
      inner = constant.get(control_path)

      control_inner_namespace = Constant::Module.new(control_inner_module)

      comment "Control Path: #{control_path.inspect}"
      comment "Inner: #{inner.inspect}"

      test "Is the final segment" do
        assert(inner.name == control_leaf_name)
      end

      test "Is the enclosing namespace" do
        assert(inner.namespace == control_inner_namespace)
      end
    end
  end
end
