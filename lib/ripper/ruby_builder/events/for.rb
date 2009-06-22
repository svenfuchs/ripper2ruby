class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module For
      def on_for(variable, range, statements)
        rdelim     = pop_token(:@end)
        separators = pop_tokens(:@semicolon)
        operator   = pop_token(:@in, :pass => true)
        identifier = pop_token(:@for, :pass => true)
        ldelim     = pop_token(:@do, :left => identifier, :right => rdelim)

        Ruby::For.new(identifier, variable, operator, range, statements, separators, ldelim, rdelim)
      end
    end
  end
end