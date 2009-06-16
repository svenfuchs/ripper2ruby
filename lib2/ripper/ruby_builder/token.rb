class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Token
      attr_accessor :type, :value, :whitespace, :position

      def initialize(type = nil, value = nil, position = nil)
        @type = type
        @value = value
        @whitespace = ''

        position[0] -= 1 if position
        @position = position
      end

      def row
        position[0]
      end

      def column
        position[1]
      end

      def whitespace?
        WHITESPACE.include?(type)
      end

      def to_sexp
        [type, value, [row + 1, column]]
      end

      def to_identifier
        Ruby::Identifier.new(value, position, whitespace)
      end
    end
  end
end