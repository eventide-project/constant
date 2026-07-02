require_relative "../automated_init"

context "Import Constant" do
  context "Alias" do
    destination_constant = Controls::Constant.example(name: "Destination")

    control_inner_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    origin_constant = Controls::Constant.example(
      name: "Origin",
      inner_constants: control_inner_constant_names
    )

    alias_constant_name = "SomeAliasConstant"

    returned_constants = Constant::Import.(origin_constant, destination_constant, alias: alias_constant_name)

    alias_constant = destination_constant.const_get(alias_constant_name, inherit=true)

    comment "Control Inner Constant Names: #{control_inner_constant_names.inspect}"
    comment "Origin Constant: #{origin_constant.inspect}"
    comment "\tOrigin Inner Constant Names: #{origin_constant.constants(false).sort.inspect}"
    comment "Destination Constant: #{destination_constant.inspect}"
    comment "Alias Constant Name: #{alias_constant_name.inspect}"
    comment "Alias Constant: #{alias_constant.inspect}"
    comment "Returned Constants: #{returned_constants.inspect}"

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

          control_inner_constant_name = "#{origin_constant.name}::#{inner_constant_name}"

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

    context "Imported constant resolution via destination" do
      control_inner_constant_names.each do |inner_constant_name|
        context inner_constant_name.inspect do
          control_inner_constant_name = "#{destination_constant.name}::#{alias_constant.name.split("::").last}::#{inner_constant_name}"

          resolved_constant = eval(control_inner_constant_name)

          comment "Control Constant Path: #{control_inner_constant_name.inspect}"
          comment "Resolved Constant: #{resolved_constant}"

          resolved = not resolved_constant.nil?

          test do
            assert(resolved)
          end
        end
      end
    end

    context "Imported constants are returned" do
      control_inner_constant_names.each do |inner_constant_name|
        context inner_constant_name.inspect do
          imported_constant = alias_constant.const_get(inner_constant_name, inherit=false)

          control_inner_constant_name = "#{origin_constant.name}::#{inner_constant_name}"

          returned_constant = returned_constants.find do |constant|
            constant.name == control_inner_constant_name
          end

          comment "Control Inner Constant Name: #{control_inner_constant_name.inspect}"
          comment "Imported Constant: #{imported_constant.inspect}"
          comment "Returned Constant: #{returned_constant.inspect}"

          returned = not returned_constant.nil?

          detail "Returned: #{returned.inspect}"

          test do
            assert(returned)
          end
        end
      end
    end

    context "Imported constants are not defined in the destination's root namespace" do
      control_inner_constant_names.each do |inner_constant_name|
        context inner_constant_name.inspect do
          control_inner_constant_name = "#{destination_constant}::#{inner_constant_name}"

          comment "Control Inner Constant Name: #{control_inner_constant_name.inspect}"

          test "Is an error" do
            assert_raises(NameError, "uninitialized constant #{control_inner_constant_name}") do
              destination_constant.const_get(inner_constant_name, inherit=false)
            end
          end
        end
      end
    end

    context "Origin constant is not included into destination constant" do
      destination_ancestors = destination_constant.ancestors

      comment "Destination Ancestors: #{destination_ancestors.inspect}"

      included = destination_ancestors.include?(origin_constant)

      test do
        refute(included)
      end
    end
  end
end
