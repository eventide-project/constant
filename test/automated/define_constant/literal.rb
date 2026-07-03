require_relative "../automated_init"

context "Define Constant" do
  context "Literal" do
    destination_constant = Controls::Constant.example

    constant_name = "SomeConstant"
    constant_value = "some string"

    defined_constant = Constant::Define.(constant_name, destination_constant, constant_value)

    comment "Constant Name: #{constant_name.inspect}"
    comment "Constant Value: #{constant_value.inspect}"
    comment "Defined Constant: #{defined_constant.inspect}"

    context "The defined constant is returned" do
      test do
        assert(defined_constant == constant_value)
      end
    end
  end
end
