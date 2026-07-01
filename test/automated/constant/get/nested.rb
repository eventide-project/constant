require_relative "../../automated_init"

context "Constant" do
  context "Get" do
    control_inner_name  = "SomeInnerNamespace"
    control_deep_name   = "SomeDeepNamespace"
    control_deep_module = ::Module.new

    control_namespace = Controls::Constant::Nested.example(
      inner_name: control_inner_name,
      leaf_name: control_deep_name,
      leaf_value: control_deep_module)

    control_path = "#{control_inner_name}::#{control_deep_name}"

    constant = Constant.get(control_path, control_namespace)

    control_deep_constant = Constant::Module.new(control_deep_module)

    comment "Control Path: #{control_path.inspect}"
    comment "Constant: #{constant.inspect}"

    test "Is a Constant mediating the nested module" do
      assert(constant == control_deep_constant)
    end
  end
end
