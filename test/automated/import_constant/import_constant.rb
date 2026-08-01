require_relative "../automated_init"

context "Import Constant" do
  control_destination = Controls::Constant.example(name: "Destination")

  control_inner_constant_names = %w(
    SomeInnerConstant
    SomeOtherInnerConstant
  )

  control_source = Controls::Constant.example(
    name: "Source",
    inner_constants: control_inner_constant_names
  )

  returned_constants = Constant::Import.(control_source, control_destination)

  comment "Control Inner Constant Names: #{control_inner_constant_names}"
  comment "Source Constant: #{control_source.inspect}"
  comment "\tSource Inner Constant Names: #{control_source.constants(false).sort.inspect}"
  comment "Destination Constant: #{control_destination.inspect}"
  comment "Returned Constants: #{returned_constants.inspect}"

  context "Imported constants are defined" do
    control_inner_constant_names.each do |inner_constant_name|
      context inner_constant_name.inspect do
        defined_constant = control_destination.const_get(inner_constant_name, inherit=false)

        control_inner_constant_name = "#{control_source.name}::#{inner_constant_name}"

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

  context "Imported constants are resolvable via destination" do
    control_inner_constant_names.each do |inner_constant_name|
      context inner_constant_name.inspect do
        control_inner_constant_name = "#{control_destination.name}::#{inner_constant_name}"

        imported_constant = Object.const_get(control_inner_constant_name)

        comment "Control Constant Path: #{control_inner_constant_name.inspect}"
        comment "Imported Constant: #{imported_constant}"

        resolved = not imported_constant.nil?

        test do
          assert(resolved)
        end
      end
    end
  end

  context "Imported constants are returned" do
    control_inner_constant_names.each do |inner_constant_name|
      context inner_constant_name.inspect do
        imported_constant = control_destination.const_get(inner_constant_name, inherit=false)

        control_inner_constant_name = "#{control_source.name}::#{inner_constant_name}"

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

  context "Source constant is not included into destination constant" do
    destination_ancestors = control_destination.ancestors

    comment "Destination Ancestors: #{destination_ancestors.inspect}"

    included = destination_ancestors.include?(control_source)

    test do
      refute(included)
    end
  end
end
