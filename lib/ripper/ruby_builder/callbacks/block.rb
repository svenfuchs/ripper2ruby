class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Block
      def on_method_add_arg(call, args)
        call.arguments = args
        call
      end

      def on_method_add_block(call, block)
        block.rdelim = pop_token(:@kw, :value => 'end') || pop_token(:@rbrace)
        block.ldelim = pop_token(:@kw, :value => 'do')  || pop_token(:@lbrace)
        call.block = block
        call
      end

      def on_do_block(params, statements)
        Ruby::Block.new(statements.compact, nil, nil, params)
      end
      
      def on_begin(body)
        rdelim = pop_token(:@kw, :value => 'end')
        ldelim = pop_token(:@kw, :value => 'begin')
        Ruby::Block.new(body.statements, body.rescue_block, body.ensure_block, nil, ldelim, rdelim)
      end
      
      def on_rescue(error_types, error_var, statements, somethingelse) # retry_block?
        operator = stack_ignore(:@kw, :value => 'end') { pop_token(:@op, :value => '=>') }
        ldelim   = stack_ignore(:@kw, :value => 'end') { pop_token(:@kw, :value => 'rescue') }
        
        errors = Ruby::Assoc.new(error_types, error_var, operator)
        params = Ruby::Params.new(errors)
        
        Ruby::Block.new(statements, nil, nil, params, ldelim) # TODO extract Ruby::Rescue
      end
      
      def on_ensure(statements)
        ldelim = stack_ignore(:@kw, :value => 'end') { pop_token(:@kw, :value => 'ensure') }
        Ruby::Block.new(statements, nil, nil, nil, ldelim)
      end
      
      def on_brace_block(params, statements)
        Ruby::Block.new(statements.compact, nil, nil, params)
      end

      def on_block_var(params, something)
        params
      end
    end
  end
end