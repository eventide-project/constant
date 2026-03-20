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
end











__END__


source_constant, receiver_constant


- import a constant's inner constants
  - need an example constant with 2 inner constants
  - need a random constant to act as the receiver
  - import the example constant's 2 inner constants into the receiver constant


module SomeModule
  module SomeInnerModule
    class SomeNestedClass
    end
  end
end

module SomeReceiver
  include Constant::Import

  import SomeModule
  import SomeModule::SomeInnerModule, alias: :Something
end

SomeReceiver.const_defined?(SomeModule)
# => true

SomeReceiver.const_defined?(Something)
# => true

SomeReceiver::Something
# => SomeModule::SomeInnerModule
