class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Symbol
      def on_symbol_literal(symbol)
        symbol
      end
      
      def on_symbol(token)
        token = pop_token(:@op) unless token.is_a?(Ruby::Node)
        Ruby::Symbol.new(token, pop_delim(:@symbeg))
      end

      def on_dyna_symbol(symbol)
        symbol.rdelim = pop_delim(:@tstring_end)
        symbol
      end
    end
  end
end