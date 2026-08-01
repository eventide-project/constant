require_relative "../../automated_init"

context "Import Constant" do
  context "Macro" do
    control_inner_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    control_source = Controls::Constant.example(
      name: "Source",
      inner_constants: control_inner_constant_names
    )

    control_destination = Controls::Constant.example(name: "Destination")

    control_destination.class_eval do
      include Constant::Import
      import control_source
    end

    comment "Source Constant: #{control_source.inspect}"
    comment "Destination Constant: #{control_destination.inspect}"

    context "Imported constants are accessible via destination" do
      control_inner_constant_names.each do |inner_constant_name|
        context inner_constant_name.inspect do
          defined = control_destination.const_defined?(inner_constant_name, false)

          detail "Defined: #{defined.inspect}"

          test do
            assert(defined)
          end
        end
      end
    end
  end
end

