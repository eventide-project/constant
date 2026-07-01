require_relative "../../../../automated_init"

context "Constant" do
  context "Defined Predicate" do
    context "Instance" do
      context "Name" do
        control_constant_name = "SomeConstant"
        control_value = "some string"
        control_module = Controls::Constant.example(inner_constants: { control_constant_name => control_value })

        constant = Constant::Module.new(control_module)

        defined = constant.defined?(control_constant_name)

        comment "Control Constant Name: #{control_constant_name.inspect}"
        comment "Control Value: #{control_value.inspect}"
        comment "Defined: #{defined.inspect}"

        test "Affirms a constant defined in the mediated module by name" do
          assert(defined)
        end
      end
    end
  end
end
