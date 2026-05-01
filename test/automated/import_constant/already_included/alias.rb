require_relative "../../automated_init"

context "Import Constant" do
  context "Already Included" do
    context "Alias" do
      source_constant = Controls::Constant.example(
        name: "Source",
        inner_constants: %i(SomeInnerConstant)
      )

      receiver_constant = Controls::Constant.example(name: "Receiver")
      receiver_constant.include(source_constant)

      alias_constant_name = :SomeAliasConstant

      Constant::Import.(source_constant, receiver_constant, alias: alias_constant_name)

      alias_constant = receiver_constant.const_get(alias_constant_name, inherit=false)

      comment "Source Constant: #{source_constant.inspect}"
      comment "Receiver Constant: #{receiver_constant.inspect}"
      comment "Alias Constant Name: #{alias_constant_name.inspect}"
      comment "Alias Constant: #{alias_constant.inspect}"
      comment "Alias Constants: #{alias_constant.constants(inherit=false).inspect}"

      context "Alias constant is defined" do
        defined = receiver_constant.const_defined?(alias_constant_name, inherit=false)

        detail "Defined: #{defined}"

        test do
          assert(defined)
        end
      end
    end
  end
end
