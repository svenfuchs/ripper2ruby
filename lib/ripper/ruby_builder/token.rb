require 'ruby/node/position'

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Token
      include Comparable

      attr_accessor :type, :value, :position, :context

      def initialize(type = nil, value = nil, position = nil)
        @type = normalize_type(type, value)
        @value = value
        @position = Ruby::Node::Position.new(position[0] - 1, position[1]) if position
      end
      
      def comments
        @comments ||= []
      end

      def newline?
        NEWLINE.include?(type)
      end

      def whitespace?
        WHITESPACE.include?(type)
      end
      
      def opener?
        OPENERS.include?(type)
      end
      
      def keyword?
        KEYWORDS.include?(type)
      end
      
      def operator?
        OPERATORS.include?(type)
      end
      
      def separator?
        SEPARATORS.include?(type)
      end
      
      def context?
        whitespace? or separator?
      end
      
      def known?
        keyword? || operator? || opener? || whitespace? || [:@backtick].include?(type)
      end
      
      def comment?
        type == :@comment
      end

      def to_sexp
        [type, value, [row + 1, column]]
      end

      def to_identifier
        Ruby::Identifier.new(value, position, context)
      end
    
      def <=>(other)
        other = other.position if other.respond_to?(:position)
        position <=> other
      end
      
      protected
      
        def normalize_type(type, value)
          case type 
          when :@kw
            :"@#{value.gsub(/\W/, '')}"
          when :@op
            :"@#{value}"
          else
            type
          end
        end
    end
  end
end