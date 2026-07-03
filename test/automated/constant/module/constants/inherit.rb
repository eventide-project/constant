require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Constants" do
      control_inherited_name = "SomeInheritedConstant"

      control_subject = Controls::Constant.example(
        ancestor: { "SomeAncestor" => [control_inherited_name] })

      control_inherited_module = control_subject.const_get(control_inherited_name, true)
      control_inherited_constant = Constant::Module.new(control_inherited_module)

      constant = Constant::Module.new(control_subject)

      comment "Control Inherited Name: #{control_inherited_name.inspect}"

      context "When inherit is true" do
        constants = constant.constants(inherit: true)

        comment "Constants: #{constants.inspect}"

        test do
          assert(constants == [control_inherited_constant])
        end
      end

      context "When inherit is false" do
        constants = constant.constants(inherit: false)

        comment "Constants: #{constants.inspect}"

        test do
          assert(constants == [])
        end
      end
    end
  end
end
