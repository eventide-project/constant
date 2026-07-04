require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Full Name" do
      control_module = Module.new

      constant = Constant::Module.new(control_module)

      full_name = constant.full_name

      comment "Control Module: #{control_module.inspect}"
      comment "Full Name: #{full_name.inspect}"

      test "Has no name when anonymous" do
        assert(full_name.nil?)
      end
    end
  end
end
