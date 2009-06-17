class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Operator
      def on_unary(operator, operand)
        operator = pop_unary_operator(:pass => true)
        Ruby::Unary.new(operator, operand)
      end

      def on_binary(left, operator, right)
        operator = pop_binary_operator(:pass => true)
        Ruby::Binary.new(operator, left, right)
      end

      def on_ifop(condition, left, right)
        operators = pop_ternary_operators(:pass => true).reverse
        Ruby::IfOp.new(condition, left, right, operators)
      end
    end
  end
end