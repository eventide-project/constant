module Constant
  module Import
    module Macro
      def __import_constant(origin_constant, **kwargs)
        destination = self

        if not destination.is_a?(::Module)
          destination = destination.class
        end

        Import.(origin_constant, destination, **kwargs)
      end

      alias import __import_constant
    end
  end
end
