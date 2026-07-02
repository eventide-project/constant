require_relative "../../automated_init"

context "Import Constant" do
  context "Macro" do
    control_inner_constant_names = %w(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    origin_constant = Controls::Constant.example(
      name: "Origin",
      inner_constants: control_inner_constant_names
    )

    destination_constant = Controls::Constant.example(name: "Destination")

    destination_constant.class_eval do
      include Constant::Import
      import origin_constant
    end

    comment "Origin Constant: #{origin_constant.inspect}"
    comment "Destination Constant: #{destination_constant.inspect}"

    context "Imported constants are accessible via destination" do
      control_inner_constant_names.each do |inner_constant_name|
        context inner_constant_name.inspect do
          defined = destination_constant.const_defined?(inner_constant_name, false)

          detail "Defined: #{defined.inspect}"

          test do
            assert(defined)
          end
        end
      end
    end
  end
end

