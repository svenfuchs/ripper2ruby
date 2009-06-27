class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module If
      def build_if(klass, type, expression, statements, else_block)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@then)
        identifier = pop_token(type)
        klass.new(identifier, expression, statements, ldelim, rdelim, else_block)
      end
      
      def on_if(expression, statements, else_block)
        build_if(Ruby::If, :@if, expression, statements, else_block)
      end

      def on_unless(expression, statements, else_block)
        build_if(Ruby::Unless, :@unless, expression, statements, else_block)
      end
      
      def on_elsif(expression, statements, else_block)
        build_if(Ruby::If, :@elsif, expression, statements, else_block)
      end
      
      def on_else(statements)
        keyword = pop_token(:@else)
        block = Ruby::Else.new(keyword, statements)
      end
      
      def on_if_mod(expression, statement)
        Ruby::IfMod.new(pop_token(:@if), expression, statement)
      end
      
      def on_unless_mod(expression, statement)
        Ruby::UnlessMod.new(pop_token(:@unless), expression, statement)
      end
    end
  end
end
