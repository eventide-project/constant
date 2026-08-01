require_relative "../../automated_init"

context "Import Constant" do
  context "Except" do
    control_excluded_constant_name = "SomeInnerConstant"
    control_imported_constant_name = "SomeOtherInnerConstant"

    control_inner_constant_names = [
      control_excluded_constant_name,
      control_imported_constant_name
    ]

    control_source = Controls::Constant.example(
      name: "Source",
      inner_constants: control_inner_constant_names
    )

    control_destination = Controls::Constant.example(
      name: "Destination",
      inner_constants: [control_excluded_constant_name]
    )

    control_source_inner = control_source.const_get(control_excluded_constant_name, false)

    comment "Source Constant: #{control_source.inspect}"
    comment "\tSource Inner Constant Names: #{control_source.constants(false).sort.inspect}"
    comment "Destination Constant: #{control_destination.inspect}"
    comment "\tDestination Inner Constant Names: #{control_destination.constants(false).sort.inspect}"
    comment "Excluded Constant Name: #{control_excluded_constant_name.inspect}"
    comment "Source Inner Constant: #{control_source_inner.inspect}"

    refute_raises do
      Constant::Import.(control_source, control_destination, except: control_excluded_constant_name)
    end

    context "Excluded constant is not imported" do
      destination_inner_constant = control_destination.const_get(control_excluded_constant_name, false)

      detail "Destination Inner Constant: #{destination_inner_constant.inspect}"

      test do
        refute(destination_inner_constant == control_source_inner)
      end
    end

    context "Constants that are not excluded are imported" do
      defined = control_destination.const_defined?(control_imported_constant_name, false)

      detail "Defined: #{defined.inspect}"

      test do
        assert(defined)
      end
    end
  end
end
