module TimeScales
  module Frame

    class PartDef
      attr_reader :key, :value, :part

      def initialize(key, value=nil)
        @key   = key
        @value = value
      end

      def scale
        possible_parts.first.scale
      end

      def outer_scope!
        @part = possible_parts.length == 1 ?
          possible_parts.first :
          possible_parts.detect { |part| part.default_for_unit? }
      end

      def component_of!(scope)
        @part = possible_parts.detect { |part|
          scope.subdivision === part.scope
        }
      end

      private

      def possible_parts
        @possible_parts ||= begin
          parts = Parts.all.select { |part| part === key }
          if parts.empty?
            parts = Parts.all.select { |part| part.subdivision === key }
          end
          if parts.empty?
            raise NoPartOrUnitForKeyError, "No part or unit matches key #{key.inspect}"
          end
          parts
        end
      end
    end

  end
end
