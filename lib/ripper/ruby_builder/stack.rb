require 'ripper/ruby_builder/queue'
require 'ripper/ruby_builder/context'

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Stack < ::Array
      def peek
        last
      end

      def queue
        @queue ||= Queue.new
      end

      def context
        @context ||= Context.new
      end

      def push(token)
        return if context.aggregate(token)
        tokens = queue << token
        tokens.each do |token|
          self << token
        end
      end

      alias :_pop :pop
      def pop(*types)
        options = types.last.is_a?(::Hash) ? types.pop : {}
        max, pass = options.delete(:max), options.delete(:pass)
        tokens, ignored = [], []

        while !empty? && !(max && tokens.length >= max)
          if types.include?(last.type) && matches?(options)
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

        def ignore_stack
          @ignore_stack ||= []
        end
      
        def matches?(conditions)
          conditions.inject(true) do |result, (type, value)|
            result && case type
            when :value
              has_value?(value)
            when :pos
              at?(value)
            when :right
              left_of?(value)
            when :left
              right_of?(value)
            end
          end
        end

        def at?(pos)
          pos.nil? || last.position == pos
        end

        def left_of?(right)
          right.nil? || last.nil? || last < right
        end

        def right_of?(left)
          left.nil? || last.nil? || left < last
        end

        def has_value?( value)
          case value
          when nil
            true
          when ::Array
            value.include?(last.value)
          else
            last.value == value
          end
        end
    end
  end
end