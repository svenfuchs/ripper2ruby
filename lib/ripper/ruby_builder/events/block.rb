class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Block
      def on_method_add_block(call, block)
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

      def on_begin(body)
        body = body.to_named_block unless body.respond_to?(:identifier)
        body.identifier = pop_token(:@begin)
        body.separators += pop_tokens(:@semicolon)
        body.rdelim = pop_token(:@end)
        body
      end

      def on_rescue(error_types, error_var, statements, block)
        identifier = pop_token(:@rescue, :pass => true)
        operator = pop_token(:'@=>', :left => identifier)

        params = if error_types || error_var
          error_types = Ruby::Array.new(error_types) if error_types
          errors = Ruby::Assoc.new(error_types, error_var, operator)
          Ruby::Params.new(errors)
        end

        statements.to_chained_block(identifier, block, nil, params)
      end

      def on_ensure(statements)
        identifier = pop_token(:@ensure)
        Ruby::NamedBlock.new(identifier, statements)
      end

      def on_rescue_mod(expression, statements)
        # positions are messed up on rescue mod after assignment, so we have to sort them
        statements, expression = *[statements, expression].sort
        expression = update_args(expression)
        identifier = pop_token(:@rescue, :pass => true)
        Ruby::RescueMod.new(identifier, expression, statements)
      end

      def on_block_var(params, something)
        # on_params was already fired on block_var before rdelimiting :@|, so we have to grab it
        params.rdelim = pop_token(:'@|') if params.ldelim.token == '|' && params.rdelim.nil?
        params
      end

      def on_params(params, optional_params, rest_param, something, block_param)
        if optional_params
          operators = pop_tokens(:'@=')
          optional_params.map! { |left, right| Ruby::Assignment.new(left, right, operators.pop) }
        end
        params = (Array(params) + Array(optional_params) << rest_param << block_param).flatten.compact

        ldelim, rdelim = *pop_tokens(:@lparen, :@rparen, :max => 2).reverse
        ldelim, rdelim = *pop_tokens(:'@|', :max => 2).reverse unless ldelim
        separators = pop_tokens(:@comma)

        Ruby::Params.new(params, separators, ldelim, rdelim)
      end

      def on_rest_param(param)
        star = pop_token(:'@*')
        Ruby::RestParam.new(param, star)
      end
    end
  end
end