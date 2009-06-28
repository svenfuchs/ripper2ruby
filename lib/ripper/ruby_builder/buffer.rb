# When tokens are pushed to the stack they may first be buffered when they
# belong to the Prolog part of a Ruby::Node. Buffered tokens will then be
# aggregated to the Prolog of the next token that is not buffered. Tokens
# belonging to the Prolog part of a Ruby::Node are whitespace, separator and
# heredoc tokens.
#
# E.g. when a whitespace char (" ") is pushed to the stack it will be buffered.
# Then when an :@ident token is pushed to the stack the contents of the buffer
# will be assigned to the Prolog of the :@ident token. Thus the whitespace char
# ends up in the Prolog of the :@ident token.

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Buffer < Array
      def aggregate(token)
        if token.nil?
          false
        elsif token.whitespace?
          self << Ruby::Whitespace.new(token.token, token.position)
          true
        elsif token.separator?
          self << Ruby::Token.new(token.token, token.position)
          true
        elsif token.heredoc?
          self << token.token
          true
        else
          token.prolog = Ruby::Prolog.new(flush) unless empty?
          false
        end
      end
    end
  end
end