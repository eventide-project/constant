module Constant
  module Import
    def self.included(base)
      if base.equal?(::Object)
        raise Constant::Error, "Constant::Import cannot be included at the top level, where the destination is Object. Activate the refinement instead: using Constant::Import"
      end

      base.extend(Macro)
    end

    refine ::Object do
      def __import_constant(origin_constant, **kwargs)
        Import.(origin_constant, self, **kwargs)
      end

      alias import __import_constant
    end

    def self.call(origin_constant, destination_constant, only: nil, except: nil, shadow_inherited: nil, **kwargs)
      shadow_inherited ||= false

      if not destination_constant.is_a?(::Module)
        destination_constant = destination_constant.class
      end

      alias_name = kwargs[:alias]

      if alias_name.nil? && destination_constant.ancestors.include?(origin_constant)
        raise Constant::Error, "#{destination_constant} already includes #{origin_constant}"
      end

      target = destination_constant

      if not alias_name.nil?
        target = Define.(alias_name, destination_constant)
      end

      inherit = false

      import_constant_names = origin_constant.constants(inherit)

      only_constant_names = Array(only)
      only_constant_names = only_constant_names.map { |only_constant_name| only_constant_name.to_sym }

      except_constant_names = Array(except)
      except_constant_names = except_constant_names.map { |except_constant_name| except_constant_name.to_sym }

      conflicting_constant_names = only_constant_names & except_constant_names

      if conflicting_constant_names.any?
        conflicting_constant_name = conflicting_constant_names.first
        raise Constant::Error, "#{conflicting_constant_name} is named in both only: and except:"
      end

      if only_constant_names.any?
        undefined_constant_names = only_constant_names - import_constant_names

        if undefined_constant_names.any?
          undefined_constant_name = undefined_constant_names.first
          raise Constant::Error, "#{undefined_constant_name} is not defined on #{origin_constant}"
        end

        import_constant_names = import_constant_names & only_constant_names
      end

      import_constant_names = import_constant_names - except_constant_names

      if shadow_inherited
        collision_constants = [target]
      else
        collision_constants = target.ancestors
      end

      import_constant_names.each do |import_constant_name|
        defining_constant = collision_constants.find do |collision_constant|
          collision_constant.const_defined?(import_constant_name, false)
        end

        if defining_constant.nil?
          next
        end

        if defining_constant.equal?(target)
          raise Constant::Error, "#{import_constant_name} is already defined on #{target} (imported from #{origin_constant})"
        end

        raise Constant::Error, "#{import_constant_name} is inherited by #{target} from #{defining_constant} (imported from #{origin_constant})"
      end

      imported_constants = import_constant_names.map do |import_constant_name|
        import_constant = origin_constant.const_get(import_constant_name, inherit)
        target.const_set(import_constant_name, import_constant)
        import_constant
      end

      imported_constants
    end
  end
end
