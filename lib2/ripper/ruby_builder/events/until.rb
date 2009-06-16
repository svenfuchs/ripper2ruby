class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Until
      def on_until(expression, statements)
        rdelim = pop_delim(:@kw, :value => 'end')
        separators = pop_delims(:@semicolon)
        ldelim = pop_delim(:@kw, :value => 'until')
        Ruby::Until.new(expression, statements, separators, ldelim, rdelim)
      end

      def on_until_mod(expression, statement)
        Ruby::UntilMod.new(expression, statement, pop_delim(:@kw, :value => 'until'))
      end
    end
  end
end