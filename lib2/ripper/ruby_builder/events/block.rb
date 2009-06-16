class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Block
      def on_method_add_block(call, block)
        # block.rdelim = pop_delim(:@kw, :value => 'end') || pop_delim(:@rbrace)
        # block.ldelim = pop_delim(:@kw, :value => 'do')  || pop_delim(:@lbrace)
        call.block = block
        call
      end

      def on_do_block(params, statements)
        rdelim = pop_delim(:@kw, :value => 'end')
        separators = pop_delims(:@semicolon)
        ldelim = pop_delim(:@kw, :value => 'do')
        statements.to_block(separators, params, ldelim, rdelim)
      end
      
      def on_brace_block(params, statements)
        rdelim = pop_delim(:@rbrace)
        separators = pop_delims(:@semicolon)
        ldelim = pop_delim(:@lbrace)
        statements.to_block(separators, params, ldelim, rdelim)
      end
      
      def on_begin(statements)
        rdelim = pop_delim(:@kw, :value => 'end')
        separators = pop_delims(:@semicolon)
        ldelim = pop_delim(:@kw, :value => 'begin')
        statements.to_block(separators, nil, ldelim, rdelim)
      end
      
      # def on_rescue(error_types, error_var, statements, somethingelse) # retry_block?
      #   operator = stack_ignore(:@kw, :value => 'end') { pop_delim(:@op, :value => '=>') }
      #   ldelim   = stack_ignore(:@kw, :value => 'end') { pop_delim(:@kw, :value => 'rescue') }
      # 
      #   errors = Ruby::Assoc.new(error_types, error_var, operator)
      #   params = Ruby::Params.new(errors)
      # 
      #   Ruby::Block.new(statements, nil, nil, params, ldelim) # TODO extract Ruby::Rescue
      # end
      # 
      # def on_ensure(statements)
      #   ldelim = stack_ignore(:@kw, :value => 'end') { pop_delim(:@kw, :value => 'ensure') }
      #   Ruby::Block.new(statements, nil, nil, nil, ldelim)
      # end
      
      def on_block_var(params, something)
        params
      end

      def on_params(params, optional_params, rest_param, something, block_param)
        optional_params.map! do |left, right|
          operator = stack_ignore(:@rparen, :@comma) { pop_delim(:@op, :value => '=') }
          Ruby::Assignment.new(left, right, operator)
        end if optional_params
        
        params = (Array(params) + Array(optional_params) << rest_param << block_param).flatten.compact

        rdelim = pop_delim(:@rparen) || pop_delim(:@op, :value => '|')
        separators = pop_delims(:@comma)
        ldelim = pop_delim(:@lparen) || pop_delim(:@op, :value => '|')

        Ruby::Params.new(params, ldelim, rdelim, separators)
      end

      def on_rest_param(identifier)
        star = pop_delim(:@op, :value => '*')
        Ruby::RestParam.new(identifier.token, identifier.position, star)
      end

      def on_paren(params)
        rdelim = pop_delim(:@rparen) || pop_delim(:@op, :value => '|')
        params.rdelim = rdelim if rdelim
        params
      end
    end
  end
end