class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Token
      attr_accessor :type, :value, :whitespace, :row, :column

      def initialize(type, value = nil, position = nil)
        @type = type
        @value = value
        @whitespace = ''
        if position
          @row    = position[0] - 1
          @column = position[1]
        end
      end
      
      def position
        [row, column]
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