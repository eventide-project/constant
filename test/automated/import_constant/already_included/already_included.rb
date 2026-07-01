require_relative "../../automated_init"

context "Import Constant" do
  context "Already Included" do
    source_constant = Controls::Constant.example(
      name: "Source",
      inner_constants: %w(SomeInnerConstant)
    )

    receiver_constant = Controls::Constant.example(name: "Receiver")

    receiver_constant.include(source_constant)

    comment "Source Constant: #{source_constant.inspect}"
    comment "Receiver Constant: #{receiver_constant.inspect}"
    comment "Receiver Ancestors: #{receiver_constant.ancestors.inspect}"
    comment "Receiver Constants: #{receiver_constant.constants(false).inspect}"

    test "Is an error" do
      assert_raises(Constant::Import::Error) do
        Constant::Import.(source_constant, receiver_constant)
      end
    end
  end
end
