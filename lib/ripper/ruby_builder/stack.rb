require 'ripper/ruby_builder/queue'
require 'ripper/ruby_builder/buffer'

# The stack holds the current "state" of the parser and facilitates communication
# between lexer events (which fire on known Ruby tokens) and parser events (which
# fire on known Ruby constructs).
#
# E.g. when the Ruby code foo(:bar) is parsed the lexer will fire events for
# the identifiers 'foo' and 'bar', for the opening and closing parentheses and
# for the colon . Tt fires the events in the order of the occurence of the
# tokens from left to right. RubyBuilder pushes all these tokens to the stack.
#
# See RubyBuilder::Queue and RubyBuilder::Buffer for what else happens when a
# token is pushed to the stack.
#
# The parser on the other hand will fire events for known Ruby constructs such
# as the argument list, arguments being added to the argument list, the method
# call etc. The parser fires these events in the order of Ruby constructs being
# recognized - i.e. when they are completed. RubyBuilder responds to these
# events and will pop tokens off from the stack as required (e.g. for
# constructing an argument list it will try to pop off the corresponding
# left and right parentheses.)
#
# When RubyBuilder pops tokens off from the stack it wants to be careful not to
# pop off tokens that belong to higher level constructs that haven't yet fired.
# E.g. for a nested method call foo(bar(1)) the inner call fires first because
# it completes first. Thus, when RubyBuilder constructs this call it must not
# pop off the opening parentheses belonging to the outer call (which of course)
# is already on the stack.
#
# For that reason when popping off tokens the stack by default stops searching
# for the token when an opening token is found. RubyBuilder can force it to
# search past opening tokens by setting the :pass option to true. Similarly
# RubyBuilder can set constraints to what tokens it wants to be popped off:
#
# :pass    => true   # search past opening tokens
# :max     => count  # number of tokens
# :value   => 'foo'  # value of the token
# :pos     => pos    # position of the token
# :left    => token  # token must be located right of the given token
# :right   => token  # token must be located left of the given token
# :reverse => true   # searches the stack in reverse order (i.e. tokens are shifted)

class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    class Stack < ::Array
      attr_reader :queue, :buffer

      def initialize
        @queue = Queue.new
        @buffer = Buffer.new
      end

      def push(token)
        return token if buffer.aggregate(token)
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
