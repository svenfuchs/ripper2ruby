class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Block
      def on_method_add_block(call, block)
        call.block = block
        call
      end

      def on_do_block(params, statements)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@do)
        statements.to_block(params, ldelim, rdelim)
      end

      def on_brace_block(params, statements)
        rdelim = pop_token(:@rbrace)
        ldelim = pop_token(:@lbrace)
        statements.to_block(params, ldelim, rdelim)
      end

      def on_begin(body)
        body = body.to_chained_block unless body.is_a?(Ruby::ChainedBlock)
        body.rdelim = pop_token(:@end)
        body.identifier = pop_token(:@begin)
        body
      end

      def on_rescue(types, var, statements, block)
        identifier = pop_token(:@rescue)
        ldelim = pop_token(:@then)
        operator = pop_token(:'@=>', :left => identifier)
        params = Ruby::RescueParams.new(types, var, operator)
        statements.to_chained_block(identifier, block, params, ldelim)
      end

      def on_ensure(statements)
        identifier = pop_token(:@ensure)
        Ruby::NamedBlock.new(identifier, statements)
      end

      def on_rescue_mod(expression, statements)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        statements, expression = *[statements, expression].sort
        identifier = pop_token(:@rescue)
        Ruby::RescueMod.new(identifier, expression, statements)
      end

      def on_block_var(params, something)
        params.rdelim = pop_token(:'@|')
        params.ldelim = pop_token(:'@|')
        params.ldelim, params.rdelim = empty_block_params_delimiters(params) if stack.last.type == :'@||'
        params
      end

      def on_params(params, optionals, rest, something, block)
        optionals = to_assignments(optionals) if optionals
        params = (Array(params) + Array(optionals) << rest << block).flatten.compact
        Ruby::Params.new(params)
      end

      def on_rest_param(param)
        Ruby::Param.new(param, pop_token(:'@*'))
      end
      
      protected
      
        def to_assignments(array)
          array.reverse.map { |left, right| Ruby::Assignment.new(left, right, pop_token(:'@=')) }.reverse
        end
      
        # gosh, yes. ripper regards empty block param delims (as in in do || ; end) as an operator
        def empty_block_params_delimiters(params)
          op = pop_token(:'@||')
          ldelim = Ruby::Token.new('|', op.position, op.prolog)
          rdelim = Ruby::Token.new('|', op.position).tap { |o| o.position.col += 1 }
          [ldelim, rdelim]
        end
    end
  end
end
