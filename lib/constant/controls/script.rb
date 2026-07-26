require "open3"

module Constant
  module Controls
    module Script
      def self.top_level_import(origin_name: nil, inner_constants: nil)
        origin_name ||= "SomeOrigin"
        inner_constants ||= ["SomeInnerConstant"]

        inner_constant_definitions = inner_constants.map do |inner_constant_name|
          "#{inner_constant_name} = ::Module.new"
        end

        inner_constant_resolutions = inner_constants.map do |inner_constant_name|
          "puts #{inner_constant_name}.name"
        end

        definitions = inner_constant_definitions.join("\n")
        resolutions = inner_constant_resolutions.join("\n")

        source = <<~RUBY
          require "constant"

          module #{origin_name}
          #{definitions}
          end

          include Constant::Import

          import #{origin_name}

          #{resolutions}
        RUBY

        Example.new(source)
      end

      class Example
        include Initializer

        initializer :source

        def run
          load_path_options = $LOAD_PATH.map do |load_path_entry|
            "-I#{load_path_entry}"
          end

          command = ["ruby", *load_path_options, "-e", source]

          output, error_output, status = Open3.capture3(*command)

          if not status.success?
            raise "Script failed\n\n#{source}\n#{error_output}"
          end

          output.split("\n")
        end
      end
    end
  end
end
