require_relative "../automated_init"

context "Import Constant" do
  context "Instance" do
    control_inner_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    origin_constant = Controls::Constant.example(
      name: "Origin",
      inner_constants: control_inner_constant_names
    )

    control_destination_class = ::Class.new
    control_destination_object = control_destination_class.new

    returned_constants = Constant::Import.(origin_constant, control_destination_object)

    comment "Origin Constant: #{origin_constant.inspect}"
    comment "Destination Class: #{control_destination_class.inspect}"
    comment "Returned Constants: #{returned_constants.inspect}"

    control_inner_constant_names.each do |inner_constant_name|
      context inner_constant_name.inspect do
        imported_constant = Constant.get(inner_constant_name, control_destination_class)
        origin_inner_constant = Constant.get(inner_constant_name, origin_constant)

        comment "Imported Constant: #{imported_constant.inspect}"
        comment "Origin Inner Constant: #{origin_inner_constant.inspect}"

        test "Are the origin's inner constants" do
          assert(imported_constant == origin_inner_constant)
        end
      end
    end
  end
end
