require_relative "../../automated_init"

context "Import Constant" do
  context "Only" do
    control_imported_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    control_omitted_constant_name = "SomeThirdInnerConstant"

    control_inner_constant_names = control_imported_constant_names + [control_omitted_constant_name]

    control_source = Controls::Constant.example(
      name: "Source",
      inner_constants: control_inner_constant_names
    )

    control_destination = Controls::Constant.example(name: "Destination")

    comment "Source Constant: #{control_source.inspect}"
    comment "\tSource Inner Constant Names: #{control_source.constants(false).sort.inspect}"
    comment "Destination Constant: #{control_destination.inspect}"
    comment "Imported Constant Names: #{control_imported_constant_names.inspect}"
    comment "Omitted Constant Name: #{control_omitted_constant_name.inspect}"

    refute_raises do
      Constant::Import.(control_source, control_destination, only: control_imported_constant_names)
    end

    context "Constants that are not included in the only: list are not imported" do
      defined = control_destination.const_defined?(control_omitted_constant_name, false)

      detail "Defined: #{defined.inspect}"

      test do
        refute(defined)
      end
    end

    context "Constants in the only: list are imported" do
      control_imported_constant_names.each do |imported_constant_name|
        context imported_constant_name.inspect do
          defined = control_destination.const_defined?(imported_constant_name, false)

          detail "Defined: #{defined.inspect}"

          test do
            assert(defined)
          end
        end
      end
    end
  end
end
