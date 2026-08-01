require_relative "../../automated_init"

context "Import Constant" do
  context "Refinement" do
    context "Instance" do
      control_inner_constant_name = "SomeInnerConstant"

      control_source = Controls::Constant.example(
        name: "Source",
        inner_constants: [control_inner_constant_name]
      )

      control_destination_class = ::Class.new

      control_destination_object = control_destination_class.new

      using Constant::Import

      control_destination_object.import(control_source)

      imported_constant = Constant.get(control_inner_constant_name, control_destination_class)
      control_source_inner_constant = Constant.get(control_inner_constant_name, control_source)

      comment "Source Constant: #{control_source.inspect}"
      comment "Destination Class: #{control_destination_class.inspect}"
      comment "Imported Constant: #{imported_constant.inspect}"
      comment "Source Inner Constant: #{control_source_inner_constant.inspect}"

      test "Is the source's inner constant" do
        assert(imported_constant == control_source_inner_constant)
      end
    end
  end
end
