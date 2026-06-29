require_relative "../../../../automated_init"

context "Constant" do
  context "Defined Predicate" do
    context "Instance" do
      context "Module" do
        control_constant_name = "SomeConstant"
        control_module = Controls::Constant.example(inner_constants: [control_constant_name])
        control_inner_module = control_module.const_get(control_constant_name)

        constant = Constant.new(control_module)

        defined = constant.defined?(control_inner_module)

        comment "Control Constant Name: #{control_constant_name.inspect}"
        comment "Control Inner Module: #{control_inner_module.inspect}"
        comment "Defined: #{defined.inspect}"

        context "Affirms a module nested in the mediated module" do
          test do
            assert(defined)
          end
        end
      end
    end
  end
end
