require_relative "../../automated_init"

context "Import Constant" do
  context "Already Included" do
    origin_constant = Controls::Constant.example(
      name: "Origin",
      inner_constants: %w(SomeInnerConstant)
    )

    destination_constant = Controls::Constant.example(name: "Destination")

    destination_constant.include(origin_constant)

    comment "Origin Constant: #{origin_constant.inspect}"
    comment "Destination Constant: #{destination_constant.inspect}"
    comment "Destination Ancestors: #{destination_constant.ancestors.inspect}"
    comment "Destination Constants: #{destination_constant.constants(false).inspect}"

    test "Is an error" do
      assert_raises(Constant::Import::Error) do
        Constant::Import.(origin_constant, destination_constant)
      end
    end
  end
end
