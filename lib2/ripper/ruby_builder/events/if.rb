class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module If
      def update_args(args)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        args.separators += pop_tokens(:@semicolon)
        args
      end
      
      def build_if_block(statements)
        Ruby::Block.new(statements, nil, nil, pop_token(:@then))
      end

      def on_if(args, statements, else_block)
        args = update_args(args)
        if_block = build_if_block(statements)
        Ruby::If.new(args, if_block, else_block, pop_token(:@if), pop_token(:@end))
      end

      def on_unless(args, statements, else_block)
        args = update_args(args)
        if_block = build_if_block(statements)
        Ruby::Unless.new(args, if_block, else_block, pop_token(:@unless), pop_token(:@end))
      end
      
      def on_elsif(args, statements, else_block)
        args = update_args(args)
        if_block = build_if_block(statements)
        Ruby::If.new(args, if_block, else_block, pop_token(:@elsif), pop_token(:@end))
      end
      
      def on_else(statements)
        block = Ruby::Else.new(statements, nil, nil, pop_token(:@else))
      end
      
      def on_if_mod(args, statement)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        Ruby::IfMod.new(args, statement, pop_token(:@if))
      end
      
      def on_unless_mod(args, statement)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        Ruby::UnlessMod.new(args, statement, pop_token(:@unless))
      end
    end
  end
end