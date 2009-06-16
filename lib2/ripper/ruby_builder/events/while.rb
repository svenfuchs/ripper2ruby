class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module While
      def on_while(expression, statements)
        rdelim = pop_delim(:@kw, :value => 'end')
        separators = pop_delims(:@semicolon)
        ldelim = pop_delim(:@kw, :value => 'while')
        Ruby::While.new(expression, statements, separators, ldelim, rdelim)
      end
      
      def on_while_mod(expression, statement)
        Ruby::WhileMod.new(expression, statement, pop_delim(:@kw, :value => 'while'))
      end
    end
  end
end