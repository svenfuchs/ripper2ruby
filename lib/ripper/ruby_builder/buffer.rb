class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Buffer < Array
      def flush(options = {})
        self.dup.tap { self.clear }
      end
      
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