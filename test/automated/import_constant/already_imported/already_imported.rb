require_relative "../../automated_init"

context "Import Constant" do
  context "Already Imported" do
    source_constant = Controls::Constant.example(
      name: "Source",
      inner_constants: %i(SomeInnerConstant)
    )

    receiver_constant = Controls::Constant.example(name: "Receiver")
    receiver_constant.include(source_constant)

    comment "Source Constant: #{source_constant.inspect}"
    comment "Receiver Constant: #{receiver_constant.inspect}"
    comment "Receiver Ancestors: #{receiver_constant.ancestors.inspect}"

    test "Raises error" do
      assert_raises(Constant::Import::Error) do
        Constant::Import.(source_constant, receiver_constant)
      end
    end
  end
end
