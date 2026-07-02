require_relative "../../automated_init"

context "Import Constant" do
  context "Already Included" do
    context "Alias" do
      origin_constant = Controls::Constant.example(
        name: "Origin",
        inner_constants: %w(SomeInnerConstant)
      )

      destination_constant = Controls::Constant.example(name: "Destination")
      destination_constant.include(origin_constant)

      alias_constant_name = "SomeAliasConstant"

      Constant::Import.(origin_constant, destination_constant, alias: alias_constant_name)

      alias_constant = destination_constant.const_get(alias_constant_name, inherit=false)

      comment "Origin Constant: #{origin_constant.inspect}"
      comment "Destination Constant: #{destination_constant.inspect}"
      comment "Alias Constant Name: #{alias_constant_name.inspect}"
      comment "Alias Constant: #{alias_constant.inspect}"
      comment "Alias Constants: #{alias_constant.constants(inherit=false).inspect}"

      context "Alias constant is defined" do
        defined = destination_constant.const_defined?(alias_constant_name, inherit=false)

        detail "Defined: #{defined}"

        test do
          assert(defined)
        end
      end
    end
  end
end
