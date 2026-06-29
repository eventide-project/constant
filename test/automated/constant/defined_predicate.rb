require_relative "../automated_init"

context "Constant" do
  context "Defined Predicate" do
    control_constant_name = "SomeConstant"
    control_namespace = Controls::Constant.example(inner_constants: [control_constant_name])

    defined = Constant.defined?(control_constant_name, control_namespace)

    comment "Namespace: #{control_namespace.inspect}"
    comment "Defined: #{defined.inspect}"

    context "Affirms the constant name is defined in the namespace" do
      test do
        assert(defined)
      end
    end
  end
end
