require_relative "../../../../automated_init"

context "Constant" do
  context "Defined Predicate" do
    context "Instance" do
      context "Module" do
        control_constant_name = "SomeConstant"
        control_module = Controls::Constant.example(inner_constants: [control_constant_name])
        control_other_module = Controls::Constant.example(inner_constants: [control_constant_name])
        control_impostor = control_other_module.const_get(control_constant_name)

        constant = Constant::Module.new(control_module)

        defined = constant.defined?(control_impostor)

        comment "Control Constant Name: #{control_constant_name.inspect}"
        comment "Control Impostor: #{control_impostor.inspect}"
        comment "Defined: #{defined.inspect}"

        context "Refutes a module not defined in the mediated module" do
          test do
            refute(defined)
          end
        end
      end
    end
  end
end
