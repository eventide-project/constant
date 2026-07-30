require_relative "../automated_init"

context "Import Constant" do
  context "Except" do
    control_excluded_constant_name = "SomeInnerConstant"
    control_imported_constant_name = "SomeOtherInnerConstant"

    control_inner_constant_names = [
      control_excluded_constant_name,
      control_imported_constant_name
    ]

    origin_constant = Controls::Constant.example(
      name: "Origin",
      inner_constants: control_inner_constant_names
    )

    destination_constant = Controls::Constant.example(
      name: "Destination",
      inner_constants: [control_excluded_constant_name]
    )

    control_origin_inner_constant = origin_constant.const_get(control_excluded_constant_name, false)

    comment "Origin Constant: #{origin_constant.inspect}"
    comment "\tOrigin Inner Constant Names: #{origin_constant.constants(false).sort.inspect}"
    comment "Destination Constant: #{destination_constant.inspect}"
    comment "\tDestination Inner Constant Names: #{destination_constant.constants(false).sort.inspect}"
    comment "Excluded Constant Name: #{control_excluded_constant_name.inspect}"
    comment "Origin Inner Constant: #{control_origin_inner_constant.inspect}"

    refute_raises do
      Constant::Import.(origin_constant, destination_constant, except: control_excluded_constant_name)
    end

    context "Excluded constant is not imported" do
      destination_inner_constant = destination_constant.const_get(control_excluded_constant_name, false)

      detail "Destination Inner Constant: #{destination_inner_constant.inspect}"

      test do
        refute(destination_inner_constant == control_origin_inner_constant)
      end
    end

    context "Constants that are not excluded are imported" do
      defined = destination_constant.const_defined?(control_imported_constant_name, false)

      detail "Defined: #{defined.inspect}"

      test do
        assert(defined)
      end
    end
  end
end
