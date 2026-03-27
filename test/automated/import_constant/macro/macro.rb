require_relative "../../automated_init"

context "Import Constant" do
  context "Macro" do
    control_inner_constant_names = %i(
      SomeInnerConstant
      SomeOtherInnerConstant
    )

    source_constant = Controls::Constant.example(
      name: "Source",
      inner_constants: control_inner_constant_names
    )

    receiver_constant = Controls::Constant.example(name: "Receiver")

    receiver_constant.class_eval do
      include Constant::Import
      import source_constant
    end

    comment "Source Constant: #{source_constant.inspect}"
    comment "Receiver Constant: #{receiver_constant.inspect}"

    context "Imported constants are accessible via receiver" do
      control_inner_constant_names.each do |inner_constant_name|
        context inner_constant_name.inspect do
          defined = receiver_constant.const_defined?(inner_constant_name, false)

          detail "Defined: #{defined.inspect}"

          test do
            assert(defined)
          end
        end
      end
    end
  end
end

