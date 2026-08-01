require "open3"

module Constant
  module Controls
    module Script
      def self.top_level_import(source_name: nil, inner_constants: nil)
        source_name ||= "SomeSource"
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

          module #{source_name}
          #{definitions}
          end

          include Constant::Import

          import #{source_name}

          #{resolutions}
        RUBY

        Example.new(source)
      end

      def self.top_level_refinement_import(source_name: nil, inner_constants: nil)
        source_name ||= "SomeSource"
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

          module #{source_name}
          #{definitions}
          end

          using Constant::Import

          import #{source_name}

          #{resolutions}
        RUBY

        Example.new(source)
      end

      class Example
        include Initializer

        initializer :source

        def run
          output, error_output, status = execute

          if not status.success?
            raise "Script failed\n\n#{source}\n#{error_output}"
          end

          output.split("\n")
        end

        def error
          _, error_output, status = execute

          if status.success?
            raise "Script succeeded\n\n#{source}"
          end

          error_output
        end

        def execute
          load_path_options = $LOAD_PATH.map do |load_path_entry|
            "-I#{load_path_entry}"
          end

          command = ["ruby", *load_path_options, "-e", source]

          Open3.capture3(*command)
        end
      end
    end
  end
end
