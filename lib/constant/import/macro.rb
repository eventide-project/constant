module Constant
  module Import
    module Macro
      def __import_constant(origin_constant, **kwargs)
        Import.(origin_constant, self, **kwargs)
      end

      alias import __import_constant
    end
  end
end
