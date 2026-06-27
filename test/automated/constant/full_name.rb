require_relative "../automated_init"

context "Constant" do
  context "Full Name" do
    control_inner_constant_name = "SomeConstant"
    control_module = Controls::Constant.example(inner_constants: [control_inner_constant_name])
    control_value = control_module.const_get(control_inner_constant_name)

    constant = Constant.new(control_value)

    full_name = constant.full_name

    comment "Raw Constant: #{control_value.inspect}"
    comment "Full Name: #{full_name.inspect}"

    context "Is the whole qualified name as a String" do
      test do
        assert(full_name == control_value.name)
      end
    end
  end
end
