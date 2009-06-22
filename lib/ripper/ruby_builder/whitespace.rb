class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Whitespace
      attr_accessor :whitespace
      
      def empty?
        whitespace.nil?
      end
      
      def aggregate(token)
        if token.nil?
          true
        elsif token.whitespace?
          if whitespace
            whitespace.token += token.value
          else
            self.whitespace = build_whitespace(token)
          end
          false
        else
          token.whitespace = whitespace
          self.whitespace = nil
          true
        end
      end
      
      def pop
        whitespace.tap { self.whitespace = nil }
      end
      
      def build_whitespace(token)
        Ruby::Whitespace.new(token.value, token.position)
      end
    end
  end
end