class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Context
      attr_writer :context
      
      def get
        context.tap { self.context = nil } if context?
      end
      
      def empty?
        context.empty?
      end
      
      def context?
        !!@context
      end

      def context
        @context ||= Ruby::Context.new
      end

      def aggregate(token)
        if token.nil?
          false
        elsif token.whitespace?
          context.whitespace ||= Ruby::Whitespace.new('', token.position)
          context.whitespace.token += token.value
          true
        elsif token.separator?
          separator = Ruby::Token.new(token.value, token.position, get)
          self.context = Ruby::Context.new(nil, separator)
          true
        else
          token.context = get unless context.empty?
          false
        end
      end
    end
  end
end