require_relative "../../automated_init"

context "Import Constant" do
  context "Already Included" do
    context "Alias" do
      control_source = Controls::Constant.example(
        name: "Source",
        inner_constants: %w(SomeInnerConstant)
      )

      control_destination = Controls::Constant.example(name: "Destination")
      control_destination.include(control_source)

      alias_constant_name = "SomeAliasConstant"

      Constant::Import.(control_source, control_destination, alias: alias_constant_name)

      alias_constant = control_destination.const_get(alias_constant_name, inherit=false)

      comment "Source Constant: #{control_source.inspect}"
      comment "Destination Constant: #{control_destination.inspect}"
      comment "Alias Constant Name: #{alias_constant_name.inspect}"
      comment "Alias Constant: #{alias_constant.inspect}"
      comment "Alias Constants: #{alias_constant.constants(inherit=false).inspect}"

      context "Alias constant is defined" do
        defined = control_destination.const_defined?(alias_constant_name, inherit=false)

        detail "Defined: #{defined}"

        test do
          assert(defined)
        end
      end
    end
  end
end
