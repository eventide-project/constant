require_relative "../../automated_init"

context "Import Constant" do
  context "Macro" do
    context "Alias" do
      control_inner_constant_names = %w(
        SomeInnerConstant
        SomeOtherInnerConstant
      )

      origin_constant = Controls::Constant.example(
        name: "Origin",
        inner_constants: control_inner_constant_names
      )

      alias_constant_name = "SomeAliasConstant"

      destination_constant = Controls::Constant.example(name: "Destination")

      destination_constant.class_eval do
        include Constant::Import
        import origin_constant, alias: alias_constant_name
      end

      alias_constant = destination_constant.const_get(alias_constant_name, inherit=false)

      comment "Origin Constant: #{origin_constant.inspect}"
      comment "Destination Constant: #{destination_constant.inspect}"
      comment "Alias Constant Name: #{alias_constant_name.inspect}"
      comment "Alias Constant: #{alias_constant.inspect}"
      comment "Alias Constants: #{alias_constant.constants(inherit=false).inspect}"
      comment "Destination Constants: #{destination_constant.constants(inherit=false).inspect}"

      context "Alias constant is defined" do
        control_alias_constant_name = "#{destination_constant.name}::#{alias_constant_name}"

        defined = destination_constant.const_defined?(alias_constant_name, inherit=false)

        comment "Control Alias Constant Name: #{control_alias_constant_name}"
        detail "Defined: #{defined}"

        test do
          assert(defined)
        end
      end

      context "Imported constants are defined" do
        control_inner_constant_names.each do |inner_constant_name|
          context inner_constant_name.inspect do
            defined_constant = alias_constant.const_get(inner_constant_name, inherit=false)

            control_inner_constant_name = "#{origin_constant.name}::#{alias_constant_name}::#{inner_constant_name}"

            comment "Control Inner Constant Name: #{control_inner_constant_name.inspect}"
            comment "Defined Constant: #{defined_constant.inspect}"

            defined = not defined_constant.nil?

            detail "Defined: #{defined.inspect}"

            test do
              assert(defined)
            end
          end
        end
      end
    end
  end
end
