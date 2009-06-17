class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Operator
      def on_unary(operator, operand)
        # operator = pop_token(*UNARY_OPERATORS) || pop_token(:@not, :pass => true)
        operator = pop_unary_operator(:pass => true)
        Ruby::Unary.new(operator, operand)
      end

      def on_binary(left, operator, right)
        # operator = pop_token(*BINARY_OPERATORS) || pop_token(:@and, :@or, :pass => true)
        operator = pop_binary_operator(:pass => true)
        Ruby::Binary.new(operator, left, right)
      end

      def on_ifop(condition, left, right)
        # pp stack
        # operators = pop_tokens(*TERNARY_OPERATORS, :max => 2).reverse
        operators = pop_ternary_operators(:pass => true)
        Ruby::IfOp.new(condition, left, right, operators)
      end
    end
  end
end