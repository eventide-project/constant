require_relative "../../automated_init"

context "Constant" do
  context "Get" do
    control_inherited_name = "SomeInheritedConstant"

    control_subject = Controls::Constant.example(
      ancestor: { "SomeAncestor" => [control_inherited_name] })

    control_inherited_module = control_subject.const_get(control_inherited_name, true)
    control_inherited_constant = Constant::Module.new(control_inherited_module)

    comment "Control Inherited Name: #{control_inherited_name.inspect}"

    context "When inherit is true" do
      inner = Constant.get(control_inherited_name, control_subject, inherit: true)

      comment "Inner: #{inner.inspect}"

      test do
        assert(inner == control_inherited_constant)
      end
    end

    context "When inherit is false" do
      test "Is an error" do
        assert_raises(Constant::Error) do
          Constant.get(control_inherited_name, control_subject, inherit: false)
        end
      end
    end
  end
end
