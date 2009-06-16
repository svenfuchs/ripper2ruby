class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Params
      def on_params(params, optional_params, rest_param, something, block_param)
        optional_params.map! do |left, right|
          operator = stack_ignore(:@rparen, :@comma) { pop_token(:@op, :value => '=') }
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