class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module For
      def on_for(variable, range, statements)
        rdelim     = pop_delim(:@kw, :value => 'end')
        separators = pop_delims(:@semicolon)
        operator   = pop_delim(:@kw, :value => 'in')
        ldelim     = pop_delim(:@kw, :value => 'for')
        Ruby::For.new(variable, operator, range, statements, separators, ldelim, rdelim)
      end
    end
  end
end