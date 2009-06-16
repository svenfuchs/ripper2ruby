class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module For
      def on_for(variable, range, statements)
        rdelim     = pop_token(:@end)
        separators = pop_tokens(:@semicolon)
        operator   = pop_token(:@in)
        ldelim     = pop_token(:@for)
        Ruby::For.new(variable, operator, range, statements, separators, ldelim, rdelim)
      end
    end
  end
end