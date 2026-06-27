require_relative "../automated_init"

context "Import Constant" do
  context "Alias" do
    receiver_constant = Controls::Constant.example(name: "Receiver")

    control_inner_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    source_constant = Controls::Constant.example(
      name: "Source",
      inner_constants: control_inner_constant_names
    )

    alias_constant_name = "SomeAliasConstant"

    returned_constants = Constant::Import.(source_constant, receiver_constant, alias: alias_constant_name)

    alias_constant = receiver_constant.const_get(alias_constant_name, inherit=true)

    target_constant = alias_constant
    target_constant_name = alias_constant_name

    comment "Control Inner Constant Names: #{control_inner_constant_names.inspect}"
    comment "Source Constant: #{source_constant.inspect}"
    comment "\tSource Inner Constant Names: #{source_constant.constants(false).sort.inspect}"
    comment "Receiver Constant: #{receiver_constant.inspect}"
    comment "Alias Constant Name: #{alias_constant_name.inspect}"
    comment "Alias Constant: #{alias_constant.inspect}"
    comment "Target Constant Name: #{target_constant_name.inspect}"
    comment "Target Constant: #{target_constant.inspect}"
    comment "Returned Constants: #{returned_constants.inspect}"

    context "Alias constant is defined" do
      control_alias_constant_name = "#{receiver_constant.name}::#{alias_constant_name}"

      defined = receiver_constant.const_defined?(alias_constant_name, inherit=false)

      comment "Control Alias Constant Name: #{control_alias_constant_name}"
      detail "Defined: #{defined}"

      test do
        assert(defined)
      end
    end

    context "Imported constants are defined" do
      control_inner_constant_names.each do |inner_constant_name|
        context inner_constant_name.inspect do
          defined_constant = target_constant.const_get(inner_constant_name, inherit=false)

          control_inner_constant_name = "#{source_constant.name}::#{inner_constant_name}"

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

    context "Imported constant resolution via receiver" do
      control_inner_constant_names.each do |inner_constant_name|
        context inner_constant_name.inspect do
          control_inner_constant_name = "#{receiver_constant.name}::#{target_constant.name.split("::").last}::#{inner_constant_name}"

          resolved_constant = eval(control_inner_constant_name)

          comment "Constant Path: #{control_inner_constant_name.inspect}"
          comment "Imported Constant: #{resolved_constant}"

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
          imported_constant = target_constant.const_get(inner_constant_name, inherit=false)

          control_inner_constant_name = "#{source_constant.name}::#{inner_constant_name}"

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

    context "Imported constants are not defined in the receiver's root namespace" do
      control_inner_constant_names.each do |inner_constant_name|
        context inner_constant_name.inspect do
          control_inner_constant_name = "#{receiver_constant}::#{inner_constant_name}"

          comment "Control Inner Constant Name: #{control_inner_constant_name.inspect}"

          test "Not defined" do
            assert_raises(NameError, "uninitialized constant #{control_inner_constant_name}") do
              receiver_constant.const_get(inner_constant_name, inherit=false)
            end
          end
        end
      end
    end

    context "Source constant is not included into receiver constant" do
      receiver_ancestors = receiver_constant.ancestors

      comment "Receiver Ancestors: #{receiver_ancestors.inspect}"

      included = receiver_ancestors.include?(source_constant)

      test do
        refute(included)
      end
    end
  end
end
