require_relative "../../automated_init"

context "Import Constant" do
  context "Literal" do
    control_module_inner_name = "SomeModuleConstant"
    control_literal_inner_name = "SomeLiteralConstant"
    control_literal = "some string"

    control_source = Controls::Constant.example(
      name: "Source",
      inner_constants: {
        control_module_inner_name => ::Module.new,
        control_literal_inner_name => control_literal
      }
    )

    control_destination = Controls::Constant.example(name: "Destination")

    Constant::Import.(control_source, control_destination)

    comment "Source Constant: #{control_source.inspect}"
    comment "\tSource Inner Constant Names: #{control_source.constants(false).sort.inspect}"
    comment "Destination Constant: #{control_destination.inspect}"
    comment "Module Inner Constant Name: #{control_module_inner_name.inspect}"
    comment "Literal Inner Constant Name: #{control_literal_inner_name.inspect}"
    comment "Literal: #{control_literal.inspect}"

    context "Module constants are imported" do
      defined = control_destination.const_defined?(control_module_inner_name, false)

      detail "Defined: #{defined.inspect}"

      test do
        assert(defined)
      end
    end

    context "Literal constants are imported" do
      defined = control_destination.const_defined?(control_literal_inner_name, false)

      detail "Defined: #{defined.inspect}"

      test do
        assert(defined)
      end
    end
  end
end
