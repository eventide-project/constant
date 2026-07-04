require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Namespace" do
      control_value = Module.new

      constant = Constant::Module.new(control_value)

      namespace = constant.namespace

      comment "Control Raw Constant: #{control_value.inspect}"
      comment "Namespace: #{namespace.inspect}"

      test "Has no name when anonymous" do
        assert(namespace.nil?)
      end
    end
  end
end
