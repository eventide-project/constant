class Constant
  module Import
    module Macro
      def __import_constant(source_constant, **kwargs)
        Import.(source_constant, self, **kwargs)
      end

      alias import __import_constant
    end
  end
end
