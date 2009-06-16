class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Until
      def on_until(expression, statements)
        rdelim = pop_token(:@end)
        separators = pop_tokens(:@semicolon)
        ldelim = pop_token(:@until)
        Ruby::Until.new(expression, statements, separators, ldelim, rdelim)
      end

      def on_until_mod(expression, statement)
        Ruby::UntilMod.new(expression, statement, pop_token(:@until))
      end
    end
  end
end