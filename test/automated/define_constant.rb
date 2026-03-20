require_relative "automated_init"

context "Define Constant" do
  receiver_constant = Controls::Constant.example()

  new_constant_name = :SomeConstant

  new_constant = Constant::Define.(new_constant_name, receiver_constant)

  comment "New Constant Name: #{new_constant_name.inspect}"
  comment "Receiver Constant: #{receiver_constant.inspect}"
  comment "New Constant: #{new_constant.inspect}"

  context "Defined" do
    defined = receiver_constant.const_defined?(new_constant_name)

    detail defined.inspect

    test do
      assert(defined)
    end
  end

  context "The defined constant is returned" do
    defined_constant = receiver_constant.const_get(new_constant_name)

    test do
      assert(new_constant == defined_constant)
    end
  end
end
