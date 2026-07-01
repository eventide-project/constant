require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Get" do
      control_inner_name    = "SomeInnerNamespace"
      control_missing_name  = "SomeUndefinedConstant"

      control_namespace = Controls::Constant.example(inner_constants: [control_inner_name])
      control_path = "#{control_inner_name}::#{control_missing_name}"

      constant = Constant::Module.new(control_namespace)

      comment "Control Path: #{control_path.inspect}"

      context "When the final segment is not defined" do
        test "Is an error" do
          assert_raises(Constant::Error) do
            constant.get(control_path)
          end
        end
      end
    end
  end
end
