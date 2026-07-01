require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Get" do
      control_inner_name = "SomeInnerNamespace"
      control_deep_name  = "SomeDeepNamespace"
      control_deep_module = ::Module.new

      control_namespace = Controls::Constant.example(
        inner_constants: { control_inner_name => { control_deep_name => control_deep_module } })

      control_path = "#{control_inner_name}::#{control_deep_name}"

      constant = Constant::Module.new(control_namespace)
      inner = constant.get(control_path)

      control_deep_constant = Constant::Module.new(control_deep_module)

      comment "Control Path: #{control_path.inspect}"
      comment "Inner: #{inner.inspect}"

      test "Is the Constant the path resolves to" do
        assert(inner == control_deep_constant)
      end
    end
  end
end
