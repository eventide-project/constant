require_relative "../../automated_init"

context "Import Constant" do
  context "Macro" do
    context "Instance" do
      control_inner_constant_name = "SomeInnerConstant"

      origin_constant = Controls::Constant.example(
        name: "Origin",
        inner_constants: [control_inner_constant_name]
      )

      control_destination_class = ::Class.new do
        include Constant::Import::Macro
      end

      control_destination_object = control_destination_class.new

      control_destination_object.import(origin_constant)

      imported_constant = Constant.get(control_inner_constant_name, control_destination_class)
      origin_inner_constant = Constant.get(control_inner_constant_name, origin_constant)

      comment "Origin Constant: #{origin_constant.inspect}"
      comment "Destination Class: #{control_destination_class.inspect}"
      comment "Imported Constant: #{imported_constant.inspect}"
      comment "Origin Inner Constant: #{origin_inner_constant.inspect}"

      test "Is the origin's inner constant" do
        assert(imported_constant == origin_inner_constant)
      end
    end
  end
end
