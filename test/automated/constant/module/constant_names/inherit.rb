require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Constant Names" do
      control_inherited_name = "SomeInheritedConstant"

      control_subject = Controls::Constant.example(
        ancestor: { "SomeAncestor" => [control_inherited_name] })

      constant = Constant::Module.new(control_subject)

      comment "Control Inherited Name: #{control_inherited_name.inspect}"

      context "When inherit is true" do
        constant_names = constant.constant_names(inherit: true)

        comment "Constant Names: #{constant_names.inspect}"

        test do
          assert(constant_names == [control_inherited_name])
        end
      end

      context "When inherit is false" do
        constant_names = constant.constant_names(inherit: false)

        comment "Constant Names: #{constant_names.inspect}"

        test do
          assert(constant_names == [])
        end
      end
    end
  end
end
