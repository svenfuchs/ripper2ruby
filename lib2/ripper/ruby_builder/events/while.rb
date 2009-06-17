class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module While
      def on_while(expression, statements)
        rdelim = pop_token(:@end)
        identifier = pop_token(:@while)
        separators = pop_tokens(:@semicolon)
        Ruby::While.new(identifier, expression, statements, separators, rdelim)
      end
      
      def on_while_mod(expression, statement)
        expression = update_args(expression)
        Ruby::WhileMod.new(pop_token(:@while), expression, statement)
      end
      
      def on_until(expression, statements)
        rdelim = pop_token(:@end)
        identifier = pop_token(:@until)
        separators = pop_tokens(:@semicolon)
        Ruby::Until.new(identifier, expression, statements, separators, rdelim)
      end

      def on_until_mod(expression, statement)
        expression = update_args(expression)
        Ruby::UntilMod.new(pop_token(:@until), expression, statement)
      end
    end
  end
end