class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Symbol
      def on_symbol_literal(symbol)
        symbol = pop_identifier(symbol.type) if symbol.try(:known?) # happens w/ symbols that are also keywords, e.g. :class
        symbol
      end
      
      def on_symbol(token)
        push
        token = pop_identifier(token.type) if token.try(:known?)
        Ruby::Symbol.new(token, pop_token(:@symbeg))
      end

      def on_dyna_symbol(symbol)
        string_stack.pop if symbol == string_stack.last
        symbol.rdelim = pop_token(:@tstring_end)
        symbol
      end
    end
  end
end