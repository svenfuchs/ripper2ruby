class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module While
      def on_while(expression, statements)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@do)
        identifier = pop_token(:@while)
        Ruby::While.new(identifier, expression, statements, ldelim, rdelim)
      end
      
      def on_while_mod(expression, statement)
        Ruby::WhileMod.new(pop_token(:@while), expression, statement)
      end
      
      def on_until(expression, statements)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@do)
        identifier = pop_token(:@until)
        Ruby::Until.new(identifier, expression, statements, ldelim, rdelim)
      end

      def on_until_mod(expression, statement)
        Ruby::UntilMod.new(pop_token(:@until), expression, statement)
      end
    end
  end
end
