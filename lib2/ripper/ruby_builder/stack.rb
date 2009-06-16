class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Stack < ::Array
      def initialize
        @ignore_stack = []
      end
      
      def peek
        last || Token.new
      end
      
      def push(token)
        while !token.whitespace? && last && last.whitespace?
          token.whitespace = _pop.value + token.whitespace
        end
        self << token
        token
      end
      
      alias :_pop :pop
      def pop(*types)
        options = types.last.is_a?(::Hash) ? types.pop : {}
        max = options[:max]
        value = options[:value]
        tokens, ignored = [], []

        while !empty? && !(max && tokens.length >= max)
          if types.include?(last.type) && value_matches?(last, value)
            tokens << super()
          elsif ignore?(last.type)
            ignored << super()
          else
            break
          end
        end

        ignored.reverse.each { |token| push(token) }
        tokens
      end
      
      def ignore?(type)
        @ignore_stack.flatten.include?(type)
      end
      
      def ignore_types(*types)
        @ignore_stack.push(types)
        result = yield
        @ignore_stack.pop
        result
      end
      
      protected
      
        def value_matches?(token, value)
          case value
          when nil
            true
          when ::Array
            value.include?(token.value)
          else
            token.value == value
          end
        end
    end
  end
end