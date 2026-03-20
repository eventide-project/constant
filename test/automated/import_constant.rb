require_relative "automated_init"

context "Import Constant" do
  receiver_constant = Controls::Constant.example()

  source_constant = Controls::Constant.example do
    module SomeInnerConstant
    end

    module SomeOtherInnerConstant
    end
  end

  comment "Import: #{source_constant.inspect}"
  comment "Inner Constants: #{source_constant.constants.inspect}"
  comment "Receiver: #{receiver_constant.inspect}"

  Constant::Import.(source_constant, receiver_constant)

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
end
