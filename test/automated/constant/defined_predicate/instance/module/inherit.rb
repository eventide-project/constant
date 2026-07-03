require_relative "../../../../automated_init"

context "Constant" do
  context "Defined Predicate" do
    context "Instance" do
      context "Module" do
        control_inherited_name = "SomeInheritedConstant"
        control_subject = Controls::Constant.example(
          ancestor: { "SomeAncestor" => [control_inherited_name] })

        control_inherited_module = control_subject.const_get(control_inherited_name, true)

        constant = Constant::Module.new(control_subject)

        comment "Control Inherited Module: #{control_inherited_module.inspect}"

        context "When inherit is true" do
          defined = constant.defined?(control_inherited_module, inherit: true)

          comment "Defined: #{defined.inspect}"

          test do
            assert(defined)
          end
        end

        context "When inherit is false" do
          defined = constant.defined?(control_inherited_module, inherit: false)

          comment "Defined: #{defined.inspect}"

          test do
            refute(defined)
          end
        end
      end
    end
  end
end
