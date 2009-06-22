class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Queue < ::Array
      def <<(token)
        result = [shift]
        if token.nil?
        elsif token.opener?
          push(token)
        else
          result << token 
        end
        result.compact
      end
    end
  end
end