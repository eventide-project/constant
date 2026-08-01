require_relative "../automated_init"

context "Define Constant" do
  context "When the name is a symbol" do
    control_destination = Controls::Constant.example

    constant_name = :SomeConstant

    defined_constant = Constant::Define.(constant_name, control_destination)

    comment "Constant Name: #{constant_name.inspect}"
    comment "Defined Constant: #{defined_constant.inspect}"

    context "Defined" do
      defined = control_destination.const_defined?(constant_name)

      detail defined.inspect

      test do
        assert(defined)
      end
    end

    context "The defined constant is returned" do
      bound_constant = control_destination.const_get(constant_name)

      test do
        assert(defined_constant == bound_constant)
      end
    end
  end
end
