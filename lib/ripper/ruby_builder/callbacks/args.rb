# class Ripper
#   class RubyBuilder < Ripper::SexpBuilder
#     module Args
#       def on_arg_paren(args)
#         args ||= Ruby::ArgsList.new # will be nil when call has an empty arglist, e.g. I18n.t()
# 
#         pop_token(:@rparen).tap { |r| args.rdelim = r if r }
#         pop_token(:@lparen).tap { |l| args.ldelim = l if l }
# 
#         args
#       end
# 
#       def on_args_add_block(args, block)
#         rdelim = pop_token(:@rparen, :@rbracket) # also used by :aref_field assignments, i.e. array[0] = :foo
#         operator = pop_token(:@op, :value => '&')
#         separators = pop_tokens(:@comma)
#         ldelim = pop_token(:@lparen, :@lbracket)
# 
#         args << Ruby::BlockArg.new(block, operator) if block
#         args.separators += separators if separators
#         args.ldelim = ldelim if ldelim
#         args.rdelim = rdelim if rdelim
#         args
#       end
#       
#       def on_args_add_star(args, arg)
#         stack_ignore(:@rparen, :@period) do
#           pop_tokens(:@comma).tap { |s| args.separators += s.reverse }
#           star = pop_token(:@op)
#         end
#         args << arg
#         args
#       end
# 
#       def on_args_add(args, arg)
#         pop_tokens(:@comma).tap { |s| args.separators += s.reverse }
#         args << arg
#         args
#       end
#       
#       def on_blockarg(identifier)
#         operator = pop_token(:@op, :value => '&')
#         Ruby::BlockArg.new(identifier, operator)
#       end
# 
#       def on_args_new
#         Ruby::ArgsList.new
#       end
#     end
#   end
# end