class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module While
      def on_while(expression, statements)
        Ruby::While.new(expression, statements, pop_tokens(:@semicolon), pop_token(:@while), pop_token(:@end))
      end
      
      def on_while_mod(expression, statement)
        Ruby::WhileMod.new(expression, statement, pop_token(:@while))
      end
    end
  end
end