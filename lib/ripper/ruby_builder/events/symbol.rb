class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Symbol
      def on_symbol_literal(symbol)
        symbol
      end
      
      def on_symbol(token)
        # happens for symbols that are also keywords, e.g. :if
        if token.respond_to?(:keyword?) && (token.keyword? || token.operator?)
          token = pop_token(*KEYWORDS + OPERATORS).to_identifier
        end
        Ruby::Symbol.new(token, pop_token(:@symbeg))
      end

      def on_dyna_symbol(symbol)
        symbol.rdelim = pop_token(:@tstring_end)
        symbol
      end
    end
  end
end