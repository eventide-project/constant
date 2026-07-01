require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Get" do
      control_literal_name  = "SomeLiteral"
      control_literal_value = "some string"
      control_beyond_name   = "SomeInnerConstant"

      control_namespace = Controls::Constant.example(
        inner_constants: { control_literal_name => control_literal_value })
      control_path = "#{control_literal_name}::#{control_beyond_name}"

      constant = Constant::Module.new(control_namespace)

      comment "Control Path: #{control_path.inspect}"

      context "When a mid-path segment is a literal constant" do
        test "Is an error" do
          assert_raises(Constant::Error) do
            constant.get(control_path)
          end
        end
      end
    end
  end
end
