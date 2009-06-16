# class Ripper
#   class RubyBuilder < Ripper::SexpBuilder
#     module Call
#       def on_command(identifier, args)
#         Ruby::Call.new(nil, nil, identifier, args)
#       end
#
#       def on_command_call(target, separator, identifier, args)
#         separator = pop_token(:@period)
#         Ruby::Call.new(target, separator, identifier, args)
#       end
#
#       def on_call(target, separator, identifier)
#         separator = pop_token(:@period)
#         Ruby::Call.new(target, separator, identifier)
#       end
#
#       def on_fcall(identifier)
#         Ruby::Call.new(nil, nil, identifier)
#       end
#
#       def on_zsuper(*args)
#         identifier = pop_token(:@kw, :value => 'super').to_identifier
#         Ruby::Call.new(nil, nil, identifier)
#       end
#
#       def on_yield(args)
#         identifier = pop_token(:@kw, :value => 'yield').to_identifier
#         Ruby::Call.new(nil, nil, identifier, args)
#       end
#
#       def on_yield0
#         identifier = pop_token(:@kw, :value => 'yield').to_identifier
#         Ruby::Call.new(nil, nil, identifier)
#       end
#
#       def on_alias(*args)
#         identifier = pop_token(:@kw, :value => 'alias').to_identifier
#         Ruby::Alias.new(identifier, args)
#       end
#
#       def on_undef(args)
#         identifier = pop_token(:@kw, :value => 'undef').to_identifier
#         Ruby::Call.new(nil, nil, identifier, args)
#       end
#
#       def on_return(args)
#         identifier = pop_token(:@kw, :value => 'return').to_identifier
#         Ruby::Call.new(nil, nil, identifier, args)
#       end
#
#       def on_next(args)
#         identifier = pop_token(:@kw, :value => 'next').to_identifier
#         Ruby::Call.new(nil, nil, identifier, args)
#       end
#
#       def on_break(args)
#         identifier = pop_token(:@kw, :value => 'break').to_identifier
#         Ruby::Call.new(nil, nil, identifier, args)
#       end
#
#       def on_redo
#         identifier = pop_token(:@kw, :value => 'redo').to_identifier
#         Ruby::Call.new(nil, nil, identifier)
#       end
#
#       def on_retry
#         identifier = pop_token(:@kw, :value => 'retry').to_identifier
#         Ruby::Call.new(nil, nil, identifier)
#       end
#
#       # assignment methods, e.g. a.b = :c
#       def on_field(target, separator, identifier)
#         separator = stack_ignore(:@op) { pop_token(:@period) }
#         Ruby::Call.new(target, separator, identifier)
#       end
#
#       # TODO defined?(A), technically not a method call ... have Defined < Call for this?
#       def on_defined(ref)
#         rdelim = pop_token(:@rparen)
#         ldelim = pop_token(:@lparen)
#         token = pop_token(:@kw, :value => 'defined?')
#
#         args = Ruby::ArgsList.new(ref, ldelim, rdelim)
#         Ruby::Call.new(nil, nil, token.to_identifier, args)
#       end
#     end
#   end
# end