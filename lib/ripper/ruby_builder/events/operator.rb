class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Operator
      def on_unary(operator, operand)
        operator = pop_token(:@op) || pop_token(:@not)
        Ruby::Unary.new(operator, operand)
      end

      def on_binary(left, operator, right)
        operator = pop_token(:@op) || pop_token(:@and, :@or)
        Ruby::Binary.new(operator, left, right)
      end

      def on_ifop(condition, left, right)
        operators = pop_tokens(:@op).reverse
        Ruby::IfOp.new(condition, left, right, operators)
      end
    end
  end
end