require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Name" do
      control_module = Module.new

      constant = Constant::Module.new(control_module)

      name = constant.name

      comment "Control Module: #{control_module.inspect}"
      comment "Name: #{name.inspect}"

      test "Has no name when anonymous" do
        assert(name.nil?)
      end
    end
  end
end
