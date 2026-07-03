require_relative "../../automated_init"

context "Constant" do
  context "Defined Predicate" do
    control_inherited_name = "SomeInheritedConstant"
    control_subject = Controls::Constant.example(
      ancestor: { "SomeAncestor" => [control_inherited_name] })

    comment "Control Inherited Name: #{control_inherited_name.inspect}"

    context "When inherit is true" do
      defined = Constant.defined?(control_inherited_name, control_subject, inherit: true)

      comment "Defined: #{defined.inspect}"

      test do
        assert(defined)
      end
    end

    context "When inherit is false" do
      defined = Constant.defined?(control_inherited_name, control_subject, inherit: false)

      comment "Defined: #{defined.inspect}"

      test do
        refute(defined)
      end
    end
  end
end
