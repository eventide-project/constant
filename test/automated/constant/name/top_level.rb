require_relative "../../automated_init"

context "Constant" do
  context "Name" do
    control_module = Controls::Constant.example

    constant = Constant::Module.new(control_module)

    name = constant.name

    comment "Module: #{control_module.inspect}"
    comment "Name: #{name.inspect}"

    context "Is the whole name as a String" do
      test do
        assert(name == control_module.name)
      end
    end
  end
end
