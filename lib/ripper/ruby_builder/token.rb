require 'ruby/node/position'

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Token
      include Comparable

      attr_accessor :type, :token, :position, :context

      def initialize(type = nil, token = nil, position = nil)
        @type = normalize_type(type, token)
        @token = token
        @position = Ruby::Node::Position.new(position[0] - 1, position[1]) if position
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
        [type, token, [row + 1, column]]
      end

      def to_identifier
        Ruby::Identifier.new(token, position, context)
      end
    
      def <=>(other)
        position <=> (other.respond_to?(:position) ? other.position : other)
      end
      
      protected
      
        def normalize_type(type, token)
          case type 
          when :@kw
            :"@#{token.gsub(/\W/, '')}"
          when :@op
            :"@#{token}"
          else
            type
          end
        end
    end
  end
end