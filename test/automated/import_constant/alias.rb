require_relative "../automated_init"

context "Import Constant" do
  context "Alias" do
    receiver_constant = Controls::Constant.example()

    source_constant = Controls::Constant.example do
      module SomeInnerConstant
      end

      module SomeOtherInnerConstant
      end
    end

    alias_name = :SomeAliasConstant

    comment "Alias Name: #{alias_name.inspect}"
    comment "Import: #{source_constant.inspect}"
    comment "Import Inner Constants: #{source_constant.constants.inspect}"
    comment "Receiver: #{receiver_constant.inspect}"

    new_constants = Constant::Import.(source_constant, receiver_constant, alias: alias_name)

    context "Alias constant defined" do
      receiver_constants = receiver_constant.constants

      defined = receiver_constants.include?(alias_name)

      comment "Receiver Constants: #{receiver_constants}"
      detail "Defined: #{defined}"

      test do
        assert(defined)
      end
    end

    context "The alias constant is returned" do
    end

    context "Imported constant's inner constants are not imported into the receiver's namespace" do

      # imported_constants =
    end

  end
end
