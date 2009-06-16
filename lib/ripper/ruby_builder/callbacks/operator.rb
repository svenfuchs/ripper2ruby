# class Ripper
#   class RubyBuilder < Ripper::SexpBuilder
#     module Operator
#       def on_unary(operator, operand)
#         operator = stack_ignore(:@kw, :@rparen) do
#           pop_delim(:@op) || pop_delim(:@kw, :value => 'not')
#         end
#         Ruby::Unary.new(operator, operand)
#       end
# 
#       def on_binary(left, operator, right)
#         operator = stack_ignore(:@kw, :@rparen) do
#           pop_delim(:@op) || pop_delim(:@kw, :value => %w(and or))
#         end
#         Ruby::Binary.new(operator, left, right)
#       end
# 
#       def on_ifop(condition, left, right)
#         operators = stack_ignore(:@kw, :@rparen) do
#           pop_delims(:@op).reverse
#         end
#         Ruby::IfOp.new(condition, left, right, operators)
#       end
#     end
#   end
# end