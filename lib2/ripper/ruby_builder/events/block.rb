class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Block
      def on_method_add_block(call, block)
        # block.rdelim = pop_token(:@end) || pop_token(:@rbrace)
        # block.ldelim = pop_token(:@do)  || pop_token(:@lbrace)
        call.block = block
        call
      end

      def on_do_block(params, statements)
        rdelim = pop_token(:@end)
        separators = pop_tokens(:@semicolon)
        ldelim = pop_token(:@do)
        statements.to_block(separators, params, ldelim, rdelim)
      end
      
      def on_brace_block(params, statements)
        rdelim = pop_token(:@rbrace)
        separators = pop_tokens(:@semicolon)
        ldelim = pop_token(:@lbrace)
        statements.to_block(separators, params, ldelim, rdelim)
      end
      
      def on_begin(statements)
        rdelim = pop_token(:@end)
        separators = pop_tokens(:@semicolon)
        ldelim = pop_token(:@begin)
        statements.to_block(separators, nil, ldelim, rdelim)
      end
      
      # def on_rescue(error_types, error_var, statements, somethingelse) # retry_block?
      #   operator = pop_token(:@op, :value => '=>')
      #   ldelim   = pop_token(:@rescue)
      # 
      #   errors = Ruby::Assoc.new(error_types, error_var, operator)
      #   params = Ruby::Params.new(errors)
      # 
      #   Ruby::Block.new(statements, nil, nil, params, ldelim) # TODO extract Ruby::Rescue
      # end
      # 
      # def on_ensure(statements)
      #   ldelim = pop_token(:@ensure)
      #   Ruby::Block.new(statements, nil, nil, nil, ldelim)
      # end
      
      def on_block_var(params, something)
        params
      end

      def on_params(params, optional_params, rest_param, something, block_param)
        optional_params.map! do |left, right|
          operator = pop_token(:@op, :value => '=')
          Ruby::Assignment.new(left, right, operator)
        end if optional_params
        
        params = (Array(params) + Array(optional_params) << rest_param << block_param).flatten.compact

        rdelim = pop_token(:@rparen) || pop_token(:@op, :value => '|')
        separators = pop_tokens(:@comma)
        ldelim = pop_token(:@lparen) || pop_token(:@op, :value => '|')

        Ruby::Params.new(params, ldelim, rdelim, separators)
      end

      def on_rest_param(identifier)
        star = pop_token(:@op, :value => '*')
        Ruby::RestParam.new(identifier.token, identifier.position, star)
      end

      def on_paren(params)
        rdelim = pop_token(:@rparen) || pop_token(:@op, :value => '|')
        params.rdelim = rdelim if rdelim
        params
      end
    end
  end
end