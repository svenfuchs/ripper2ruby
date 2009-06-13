class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Operator
      def on_unary(operator, operand)
        operator = pop_delim(:@op) || pop_delim(:@kw, :value => 'not')
        Ruby::Unary.new(operator, operand)
      end

      def on_binary(left, operator, right)
        stack_ignore(:@rparen) do
          operator = pop_delim(:@op) || pop_delim(:@kw, :value => %w(and or))
        end
        Ruby::Binary.new(operator, left, right)
      end

      def on_ifop(condition, left, right)
        Ruby::IfOp.new(condition, left, right, pop_delims(:@op).reverse)
      end
    end
  end
end