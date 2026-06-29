require_relative "../../../automated_init"

context "Constant" do
  context "Literal" do
    context "Full Name" do
      control_namespace_module = Controls::Constant.example
      control_namespace = Constant::Module.new(control_namespace_module)
      control_name = "SomeConstant"
      control_value = "some string"
      control_full_name = "#{control_namespace_module.name}::#{control_name}"

      literal = Constant::Literal.new(control_name, control_value, control_namespace)

      full_name = literal.full_name

      comment "Control Namespace: #{control_namespace.inspect}"
      comment "Control Name: #{control_name.inspect}"
      comment "Control Value: #{control_value.inspect}"
      comment "Full Name: #{full_name.inspect}"

      context "Is the namespace-qualified name as a String" do
        test do
          assert(full_name == control_full_name)
        end
      end
    end
  end
end
