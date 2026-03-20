require_relative "automated_init"

context "Define Constant" do
  receiver_constant = Controls::Constant.example()

  new_constant_name = :SomeConstant

  new_constant = Constant::Define.(new_constant_name, receiver_constant)

  comment "New Constant Name: #{new_constant_name.inspect}"
  comment "Receiver Constant: #{receiver_constant.inspect}"
  comment "New Constant: #{new_constant.inspect}"

  defined = receiver_constant.const_defined?(new_constant_name)

  context "Defined" do
    detail defined.inspect

    test do
      assert(defined)
    end
  end
end
