# When tokens are pushed to the stack they will be pushed to a queue. Tokens
# that open new constructs in Ruby (parentheses, semicolons, keywords like
# class, do, if, etc.) will be held in the queue until the next token is
# pushed. The queue will then empty itself and return the previously queued
# token together with the currently pushed token.
#
# The reason for this is the way Ripper parses Ruby code. The lexer will fire
# events every time a known token is found. The parser will fire events when
# known Ruby constructs are completed. Thus often times when a parser event
# fires the lexer has already pushed the next (opening) token to the stack.
#
# Otoh, event handlers responding to a parser event will want to check for
# expected tokens (e.g. an opening parentheses for a method call). Thus, when
# the opening tokens (added by lexer events) are held in a queue while the
# parser event is fired it will be easier to pop the right tokens belonging
# to the parser event from the stack.

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