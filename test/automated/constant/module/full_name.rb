require_relative "../../automated_init"

context "Constant" do
  context "Module" do
    context "Full Name" do
      control_module_name = "SomeConstant"
      control_namespace = Controls::Constant.example(inner_constants: [control_module_name])
      control_module = control_namespace.const_get(control_module_name)

      constant = Constant::Module.new(control_module)

      full_name = constant.full_name

      comment "Module: #{control_module.inspect}"
      comment "Full Name: #{full_name.inspect}"

      context "Is the whole qualified name as a String" do
        test do
          assert(full_name == control_module.name)
        end
      end
    end
  end
end
