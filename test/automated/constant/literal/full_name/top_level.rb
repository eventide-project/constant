require_relative "../../../automated_init"

context "Constant" do
  context "Literal" do
    context "Full Name" do
      control_namespace = Constant::Module.new(Object)
      control_name = "SomeConstant"
      control_value = "a string"

      literal = Constant::Literal.new(control_value, control_name, control_namespace)

      full_name = literal.full_name

      comment "Control Namespace: #{control_namespace.inspect}"
      comment "Control Name: #{control_name.inspect}"
      comment "Control Value: #{control_value.inspect}"
      comment "Full Name: #{full_name.inspect}"

      context "Is the name alone for a top-level constant" do
        test do
          assert(full_name == control_name)
        end
      end
    end
  end
end
