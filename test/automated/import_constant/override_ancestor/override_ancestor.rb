require_relative "../../automated_init"

context "Import Constant" do
  context "Override Ancestor" do
    control_collision_constant_name = "SomeInnerConstant"
    control_ancestor_name = "Ancestor"

    control_source = Controls::Constant.example(
      name: "Source",
      inner_constants: [control_collision_constant_name]
    )

    control_destination = Controls::Constant.example(
      name: "Destination",
      ancestor: { control_ancestor_name => [control_collision_constant_name] }
    )

    control_source_inner = control_source.const_get(control_collision_constant_name, false)

    comment "Source Constant: #{control_source.inspect}"
    comment "\tSource Inner Constant: #{control_source_inner.inspect}"
    comment "Destination Constant: #{control_destination.inspect}"
    comment "\tDestination Ancestors: #{control_destination.ancestors.inspect}"
    comment "\tDestination Inner Constant Names: #{control_destination.constants(false).sort.inspect}"

    refute_raises do
      Constant::Import.(control_source, control_destination, override_ancestor: true)
    end

    context "Is the source's constant, rather than the ancestor's" do
      defined_constant = control_destination.const_get(control_collision_constant_name, false)

      detail "Defined Constant: #{defined_constant.inspect}"

      test do
        assert(defined_constant == control_source_inner)
      end
    end
  end
end
