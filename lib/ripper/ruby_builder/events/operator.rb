class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Operator
      def on_unary(operator, operand)
        operator = pop_unary_operator(:pass => true, :right => operand)
        Ruby::Unary.new(operator, operand) if operator
      end

      def on_binary(left, operator, right)
        operator = pop_token(:"@#{operator}", :pass => true, :right => right) 
        Ruby::Binary.new(operator, left, right) if operator
      end

      def on_ifop(condition, left, right)
        operators = pop_ternary_operator(:left => condition, :right => left),
                    pop_ternary_operator(:left => left, :right => right)
        Ruby::IfOp.new(condition, left, right, operators)
      end
    end
  end
end