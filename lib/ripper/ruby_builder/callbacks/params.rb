class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Params
      def on_params(params, optional_params, rest_param, *something) # block_param?
        params = (Array(params) + Array(optional_params) << rest_param).flatten.compact

        rdelim = pop_delim(:@rparen) || pop_delim(:@op, :value => '|')
        separators = pop_delims(:@comma)
        ldelim = pop_delim(:@lparen) ||pop_delim(:@op, :value => '|')

        Ruby::ParamsList.new(params, '', ldelim, rdelim, separators)
      end

      def on_rest_param(identifier)
        star = pop_delim(:@op, :value => '*')
        Ruby::RestParam.new(identifier.token, identifier.position, star)
      end

      def on_paren(params)
        params
      end
    end
  end
end