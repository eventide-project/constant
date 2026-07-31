require_relative "../../automated_init"

context "Import Constant" do
  context "Only" do
    control_imported_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    control_omitted_constant_name = "SomeThirdInnerConstant"

    control_inner_constant_names = control_imported_constant_names + [control_omitted_constant_name]

    origin_constant = Controls::Constant.example(
      name: "Origin",
      inner_constants: control_inner_constant_names
    )

    destination_constant = Controls::Constant.example(name: "Destination")

    comment "Origin Constant: #{origin_constant.inspect}"
    comment "\tOrigin Inner Constant Names: #{origin_constant.constants(false).sort.inspect}"
    comment "Destination Constant: #{destination_constant.inspect}"
    comment "Imported Constant Names: #{control_imported_constant_names.inspect}"
    comment "Omitted Constant Name: #{control_omitted_constant_name.inspect}"

    refute_raises do
      Constant::Import.(origin_constant, destination_constant, only: control_imported_constant_names)
    end

    context "Constants that are not included in the only: list are not imported" do
      defined = destination_constant.const_defined?(control_omitted_constant_name, false)

      detail "Defined: #{defined.inspect}"

      test do
        refute(defined)
      end
    end

    context "Constants in the only: list are imported" do
      control_imported_constant_names.each do |imported_constant_name|
        context imported_constant_name.inspect do
          defined = destination_constant.const_defined?(imported_constant_name, false)

          detail "Defined: #{defined.inspect}"

          test do
            assert(defined)
          end
        end
      end
    end
  end
end
