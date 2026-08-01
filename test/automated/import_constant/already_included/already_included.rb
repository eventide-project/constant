require_relative "../../automated_init"

context "Import Constant" do
  context "Already Included" do
    control_source = Controls::Constant.example(
      name: "Source",
      inner_constants: %w(SomeInnerConstant)
    )

    control_destination = Controls::Constant.example(name: "Destination")

    control_destination.include(control_source)

    comment "Source Constant: #{control_source.inspect}"
    comment "Destination Constant: #{control_destination.inspect}"
    comment "Destination Ancestors: #{control_destination.ancestors.inspect}"
    comment "Destination Constants: #{control_destination.constants(false).inspect}"

    context "When the destination already includes the source" do
      test "Fails" do
        assert_raises(Constant::Error, "#{control_destination} already includes #{control_source}") do
          Constant::Import.(control_source, control_destination)
        end
      end
    end
  end
end
