require_relative "../automated_init"

context "Import Constant" do
  receiver_constant = Controls::Constant.example()

  source_constant = Controls::Constant.example do
    module SomeInnerConstant
    end

    module SomeOtherInnerConstant
    end
  end

  new_constants = Constant::Import.(source_constant, receiver_constant)

  comment "Import: #{source_constant.inspect}"
  comment "Import Inner Constants: #{source_constant.constants.inspect}"
  comment "Receiver: #{receiver_constant.inspect}"
  comment "New Constants: #{new_constants.inspect}"

  context "Inner constants imported:" do
    context "SomeInnerConstant" do
      imported_constant_name = :SomeInnerConstant
      defined = receiver_constant.const_defined?(imported_constant_name, inherit=false)

      test do
        assert(defined)
      end
    end

    context "SomeOtherInnerConstant" do
      imported_constant_name = :SomeOtherInnerConstant
      defined = receiver_constant.const_defined?(imported_constant_name, inherit=false)

      test do
        assert(defined)
      end
    end
  end

  context "Source constant is not included into receiver constant" do
    receiver_ancestors = receiver_constant.ancestors

    comment "Receiver's Ancestors: #{receiver_ancestors.inspect}"

    included = receiver_ancestors.include?(source_constant)

    test do
      refute(included)
    end
  end

  context "The imported constants are returned:" do
    imported_constants = receiver_constant.constants

    comment "Imported Constants: #{imported_constants.inspect}"

    context "SomeInnerConstant" do
      imported_constant_name = :SomeInnerConstant
      returned = imported_constants.include?(imported_constant_name)

      test do
        assert(returned)
      end
    end

    context "SomeOtherInnerConstant" do
      imported_constant_name = :SomeOtherInnerConstant
      returned = imported_constants.include?(imported_constant_name)

      test do
        assert(returned)
      end
    end
  end
end
