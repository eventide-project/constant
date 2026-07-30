require_relative "../automated_init"

context "Import Constant" do
  context "Except" do
    control_excluded_constant_name = "SomeInnerConstant"

    control_inner_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    origin_constant = Controls::Constant.example(
      name: "Origin",
      inner_constants: control_inner_constant_names
    )

    destination_constant = Controls::Constant.example(
      name: "Destination",
      inner_constants: [control_excluded_constant_name]
    )

    control_destination_inner_constant = destination_constant.const_get(control_excluded_constant_name, false)

    comment "Origin Constant: #{origin_constant.inspect}"
    comment "\tOrigin Inner Constant Names: #{origin_constant.constants(false).sort.inspect}"
    comment "Destination Constant: #{destination_constant.inspect}"
    comment "\tDestination Inner Constant: #{control_destination_inner_constant.inspect}"
    comment "Excluded Constant Name: #{control_excluded_constant_name.inspect}"

    refute_raises do
      Constant::Import.(origin_constant, destination_constant, except: control_excluded_constant_name)
    end

    defined_constant = destination_constant.const_get(control_excluded_constant_name, false)

    detail "Defined Constant: #{defined_constant.inspect}"

    test do
      assert(defined_constant == control_destination_inner_constant)
    end
  end
end
