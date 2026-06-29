require_relative "../../../../automated_init"

context "Constant" do
  context "Defined Predicate" do
    context "Instance" do
      context "Name" do
        control_constant_name = "SomeConstant"
        control_module = Controls::Constant.example

        constant = Constant::Module.new(control_module)

        defined = constant.defined?(control_constant_name)

        comment "Control Constant Name: #{control_constant_name.inspect}"
        comment "Defined: #{defined.inspect}"

        context "Refutes a constant not defined in the mediated module by name" do
          test do
            refute(defined)
          end
        end
      end
    end
  end
end
