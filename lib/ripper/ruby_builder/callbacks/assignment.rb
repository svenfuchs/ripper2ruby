# class Ripper
#   class RubyBuilder < Ripper::SexpBuilder
#     module Assignment
#       # simple assignments, e.g. a = b
#       def on_assign(left, right)
#         Ruby::Assignment.new(left, right, pop_token(:@op, :value => '='))
#       end
# 
#       # mass assignments, e.g. a, b = c, d
#       def on_massign(left, right)
#         Ruby::Assignment.new(left, right, pop_token(:@op, :value => '='))
#       end
# 
#       def on_mlhs_new
#         Ruby::MultiAssignment.new(:left, pop_token(:@lparen))
#       end
# 
#       def on_mlhs_add(assignment, ref)
#         separator = pop_token(:@comma)
#         assignment.separators << separator if separator
# 
#         assignment << ref
#         assignment
#       end
# 
#       def on_mlhs_paren(arg)
#         arg.rdelim = pop_token(:@rparen) if arg.is_a?(Ruby::MultiAssignment)
#         arg
#       end
# 
#       def on_mrhs_new
#         separators = pop_tokens(:@comma).reverse
#         star = pop_token(:@op, :value => '*')
#         Ruby::MultiAssignment.new(:right, nil, nil, separators, star)
#       end
# 
#       def on_mrhs_new_from_args(args)
#         # separators = pop_tokens(:@comma).reverse
#         Ruby::MultiAssignment.new(:right, nil, nil, args.separators, nil, args.args)
#       end
# 
#       def on_mrhs_add(assignment, ref)
#         assignment << ref
#         assignment
#       end
# 
#       def on_mrhs_add_star(assignment, ref)
#         assignment << ref
#         assignment
#       end
#     end
#   end
# end