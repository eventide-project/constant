require_relative "../../automated_init"

context "Constant" do
  context "Defined Predicate" do
    control_literal_name  = "SomeLiteral"
    control_literal_value = "some string"
    control_beyond_name   = "SomeInnerConstant"

    control_namespace = Controls::Constant.example(
      inner_constants: { control_literal_name => control_literal_value })
    control_path = "#{control_literal_name}::#{control_beyond_name}"

    defined = Constant.defined?(control_path, control_namespace)

    comment "Control Path: #{control_path.inspect}"
    comment "Defined: #{defined.inspect}"

    test "Refutes a name whose path traverses a literal constant" do
      refute(defined)
    end
  end
end
