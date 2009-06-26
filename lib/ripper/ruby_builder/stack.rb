require 'core_ext/hash/delete_at'
require 'ripper/ruby_builder/queue'
require 'ripper/ruby_builder/context'

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Stack < ::Array
      attr_reader :queue, :context

      def initialize
        @queue = Queue.new
        @context = Context.new
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
        max, pass, revert = options.delete_at(:max, :pass, :reverse)
        ignored, tokens = [], []
        reverse! if revert

        while !empty? && !(max && tokens.length >= max)
          if types.include?(last.type) && matches?(options)
            tokens << _pop()
          elsif last.opener? && !pass
            break
          else
            ignored.unshift(_pop())
          end
        end

        replace(self + ignored)
        reverse! if revert
        tokens
      end

      protected
      
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