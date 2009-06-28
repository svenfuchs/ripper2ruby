require 'ruby/node/position'

# Tokens are simple value objects that hold the token type, value and position.
# There are a bunch of helper methods to check the token type and convert the
# token to Ruby nodes.
#
# We mostly operate with Ripper's token types (such as :@ident etc.). For Ripper's
# sexp types :@kw (keyword) and :@op we use more specific token types based on
# the sexp's value. E.g. Ripper's sexp [:@op, '+', [0, 0]] would become a token
# with the type :@+.

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Token
      include Comparable

      attr_accessor :type, :token, :position, :prolog

      def initialize(type = nil, token = nil, position = nil)
        @type = token_type(type, token)
        @token = token
        @position = position if position
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

      def prolog?
        whitespace? or separator? or heredoc?
      end

      def known?
        keyword? || operator? || opener? || whitespace? || [:@backtick].include?(type)
      end

      def comment?
        type == :@comment
      end

      def heredoc?
        type == :@heredoc
      end

      def to_sexp
        [type, token, [row + 1, column]]
      end

      def to_identifier
        Ruby::Identifier.new(token, position, prolog)
      end

      def <=>(other)
        position <=> (other.respond_to?(:position) ? other.position : other)
      end

      protected

        def token_type(type, token)
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