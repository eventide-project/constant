require_relative "../../automated_init"

context "Constant" do
  context "Literal" do
    context "Constants" do
      control_namespace_module = Controls::Constant.example
      control_namespace = Constant::Module.new(control_namespace_module)
      control_name = "SomeConstant"
      control_value = "some string"

      literal = Constant::Literal.new(control_name, control_value, control_namespace)

      constants = literal.constants

      comment "Literal: #{literal.inspect}"
      comment "Constants: #{constants.inspect}"

      context "Has no inner constants" do
        test do
          assert(constants == [])
        end
      end
    end
  end
end
