class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Symbol
      def on_symbol_literal(symbol)
        # happens for symbols that are also keywords, e.g. :if
        symbol = pop_identifier(symbol.type) if symbol.respond_to?(:known?) && symbol.known?
        symbol
      end
      
      def on_symbol(token)
        push
        # happens for symbols that are also keywords, e.g. :if
        token = pop_identifier(token.type) if token.respond_to?(:known?) && token.known?
        Ruby::Symbol.new(token, pop_token(:@symbeg))
      end

      def on_dyna_symbol(symbol)
        symbol.rdelim = pop_token(:@tstring_end)
        symbol
      end
    end
  end
end