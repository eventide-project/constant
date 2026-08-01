require_relative "../automated_init"

context "Import Constant" do
  context "Instance" do
    control_inner_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    control_source = Controls::Constant.example(
      name: "Source",
      inner_constants: control_inner_constant_names
    )

    control_destination_class = ::Class.new
    control_destination_object = control_destination_class.new

    returned_constants = Constant::Import.(control_source, control_destination_object)

    comment "Source Constant: #{control_source.inspect}"
    comment "Destination Class: #{control_destination_class.inspect}"
    comment "Returned Constants: #{returned_constants.inspect}"

    control_inner_constant_names.each do |inner_constant_name|
      context inner_constant_name.inspect do
        imported_constant = Constant.get(inner_constant_name, control_destination_class)
        control_source_inner_constant = Constant.get(inner_constant_name, control_source)

        comment "Imported Constant: #{imported_constant.inspect}"
        comment "Source Inner Constant: #{control_source_inner_constant.inspect}"

        test "Are the source's inner constants" do
          assert(imported_constant == control_source_inner_constant)
        end
      end
    end
  end
end
