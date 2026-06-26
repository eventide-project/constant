require_relative "../../automated_init"

context "Constant" do
  context "Name" do
    control_inner_constant_name = :SomeConstant
    control_module = Controls::Constant.example(inner_constants: [control_inner_constant_name])
    control_value = control_module.const_get(control_inner_constant_name)

    constant = Constant.new(control_value)

    name = constant.name

    comment "Raw Constant: #{control_value.inspect}"
    comment "Name: #{name.inspect}"

    context "Is the final segment of the qualified name as a String" do
      test do
        assert(name == control_inner_constant_name.to_s)
      end
    end
  end
end
