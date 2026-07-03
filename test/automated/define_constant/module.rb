require_relative "../automated_init"

context "Define Constant" do
  context "Module" do
    destination_constant = Controls::Constant.example

    constant_name = "SomeConstant"

    defined_constant = Constant::Define.(constant_name, destination_constant)

    comment "Constant Name: #{constant_name.inspect}"
    comment "Defined Constant: #{defined_constant.inspect}"

    context "Defined" do
      defined = destination_constant.const_defined?(constant_name)

      detail defined.inspect

      test do
        assert(defined)
      end
    end

    context "The defined constant is returned" do
      bound_constant = destination_constant.const_get(constant_name)

      test do
        assert(defined_constant == bound_constant)
      end
    end

    context "The defined constant is a module" do
      test do
        assert(defined_constant.instance_of?(::Module))
      end
    end
  end
end
