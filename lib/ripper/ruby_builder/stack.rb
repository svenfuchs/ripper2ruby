require 'ripper/ruby_builder/queue'
require 'ripper/ruby_builder/whitespace'

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Stack < ::Array
      def peek
        last || Token.new
      end
      
      def queue
        @queue ||= Queue.new
      end
      
      def whitespace
        @whitespace ||= Whitespace.new
      end
      
      def whitespace?
        !whitespace.empty?
      end
      
      def push(token)
        return unless whitespace.aggregate(token)
        tokens = queue << token
        tokens.each do |token| 
          self << token
        end
      end
      
      alias :_pop :pop
      def pop(*types)
        options = types.last.is_a?(::Hash) ? types.pop : {}
        max, pass, value, left, right = options.values_at(:max, :pass, :value, :left, :right)
        tokens, ignored = [], []

        while !empty? && !(max && tokens.length >= max)
          if types.include?(last.type) && value_matches?(value) && left_of?(right) && right_of?(left)
            tokens << super()
          elsif ignore?(last.type)
            ignored << super()
          elsif last.opener? && !pass
            break
          else
            ignored << super()
          end
        end

        replace(self + ignored.reverse)
        tokens
      end

      def ignore?(type)
        ignore_stack.flatten.include?(type)
      end
      
      def ignore_types(*types)
        ignore_stack.push(types)
        result = yield
        ignore_stack.pop
        result
      end
      
      protected
        
        def left_of?(right)
          right.nil? || last.nil? || last < right
        end
        
        def right_of?(left)
          left.nil? || last.nil? || left < last
        end
      
        def value_matches?( value)
          case value
          when nil
            true
          when ::Array
            value.include?(last.value)
          else
            last.value == value
          end
        end
      
        def ignore_stack
          @ignore_stack ||= []
        end
    end
  end
end