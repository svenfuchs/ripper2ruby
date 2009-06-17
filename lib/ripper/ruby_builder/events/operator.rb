class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Operator
      def on_unary(operator, operand)
        operator = pop_token(:@op, :pass => true) || pop_token(:@not, :pass => true)
        Ruby::Unary.new(operator, operand)
      end

      def on_binary(left, operator, right)
        operator = pop_token(:@op, :pass => true) || pop_token(:@and, :@or, :pass => true)
        Ruby::Binary.new(operator, left, right)
      end

      def on_ifop(condition, left, right)
        # pp stack
        operators = pop_tokens(:@op, :max => 2).reverse
        Ruby::IfOp.new(condition, left, right, operators)
      end
    end
  end
end