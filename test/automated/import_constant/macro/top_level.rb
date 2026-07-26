require_relative "../../automated_init"

context "Import Constant" do
  context "Macro" do
    context "Top Level" do
      control_inner_constant_names = %w(
        SomeInnerConstant
        SomeOtherInnerConstant
      )

      control_origin_name = "SomeOrigin"

      control_script = Controls::Script.top_level_import(
        origin_name: control_origin_name,
        inner_constants: control_inner_constant_names
      )

      imported_constant_full_names = control_script.run

      control_constant_full_names =
        control_inner_constant_names.map do |inner_constant_name|
          "#{control_origin_name}::#{inner_constant_name}"
        end

      comment "Imported Constant Full Names: #{imported_constant_full_names.inspect}"
      comment "Control Constant Full Names: #{control_constant_full_names.inspect}"

      test "Are the origin's inner constants" do
        assert(imported_constant_full_names == control_constant_full_names)
      end
    end
  end
end
