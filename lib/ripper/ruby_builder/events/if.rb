class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module If
      def update_args(args)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        args.separators += pop_tokens(:@semicolon)
        args
      end
      
      def build_if(klass, type, expression, statements, else_block)
        expression = update_args(expression)
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
        block = Ruby::Else.new(pop_token(:@else, :pass => true), statements)
      end
      
      def on_if_mod(expression, statement)
        expression = update_args(expression)
        Ruby::IfMod.new(pop_token(:@if, :pass => true), expression, statement)
      end
      
      def on_unless_mod(expression, statement)
        expression = update_args(expression)
        Ruby::UnlessMod.new(pop_token(:@unless, :pass => true), expression, statement)
      end
    end
  end
end