require_relative "../../../automated_init"

context "Constant" do
  context "Module" do
    context "Equality" do
      control_module = Controls::Constant.example

      constant = Constant::Module.new(control_module)
      control_module_constant = Constant::Module.new(control_module)

      equal_hashes = constant.hash == control_module_constant.hash

      comment "Module: #{control_module.inspect}"

      context "Equal hash when mediating the same module" do
        test do
          assert(equal_hashes)
        end
      end
    end
  end
end
