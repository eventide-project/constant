require_relative "../../automated_init"

context "Import Constant" do
  context "Macro" do
    context "Alias" do
      control_inner_constant_names = %w(
        SomeInnerConstant
        SomeOtherInnerConstant
      )

      control_source = Controls::Constant.example(
        name: "Source",
        inner_constants: control_inner_constant_names
      )

      alias_constant_name = "SomeAliasConstant"

      control_destination = Controls::Constant.example(name: "Destination")

      control_destination.class_eval do
        include Constant::Import
        import control_source, alias: alias_constant_name
      end

      alias_constant = control_destination.const_get(alias_constant_name, inherit=false)

      comment "Source Constant: #{control_source.inspect}"
      comment "Destination Constant: #{control_destination.inspect}"
      comment "Alias Constant Name: #{alias_constant_name.inspect}"
      comment "Alias Constant: #{alias_constant.inspect}"
      comment "Alias Constants: #{alias_constant.constants(inherit=false).inspect}"
      comment "Destination Constants: #{control_destination.constants(inherit=false).inspect}"

      context "Alias constant is defined" do
        control_alias_constant_name = "#{control_destination.name}::#{alias_constant_name}"

        defined = control_destination.const_defined?(alias_constant_name, inherit=false)

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

            control_inner_constant_name = "#{control_source.name}::#{alias_constant_name}::#{inner_constant_name}"

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
