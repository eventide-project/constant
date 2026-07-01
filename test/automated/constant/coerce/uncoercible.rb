require_relative "../../automated_init"

using Constant::Coerce

context "Constant" do
  context "Coerce" do
    context "When the value is not a module, a name, or a Constant" do
      test "Is an error" do
        assert_raises(TypeError) do
          Constant(nil)
        end
      end
    end
  end
end
