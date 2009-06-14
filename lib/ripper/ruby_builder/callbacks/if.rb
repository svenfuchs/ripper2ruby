class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module If
      def build_if_block(statements)
        ldelim = stack_ignore(:@kw) do 
          pop_delim(:@kw, :value => 'then') || pop_delim(:@semicolon)
        end
        Ruby::Block.new(statements, nil, nil, nil, ldelim)
      end

      def on_if(expression, statements, else_block)
        if_block = build_if_block(statements)
        ldelim, rdelim = pop_delims(:@kw, :value => %w(if end)).reverse
        Ruby::If.new(expression, if_block, else_block, ldelim, rdelim)
      end

      def on_unless(expression, statements, else_block)
        if_block = build_if_block(statements)
        ldelim, rdelim = pop_delims(:@kw, :value => %w(unless end)).reverse
        Ruby::Unless.new(expression, if_block, else_block, ldelim, rdelim)
      end
      
      def on_elsif(expression, statements, else_block)
        if_block = build_if_block(statements)
        ldelim, rdelim = pop_delims(:@kw, :value => %w(elsif end)).reverse
        Ruby::If.new(expression, if_block, else_block, ldelim, rdelim)
      end
      
      def on_else(statements)
        ldelim = stack_ignore(:@kw) { pop_delim(:@kw, :value => 'else') }
        block = Ruby::Else.new(statements, nil, nil, ldelim)
      end
      
      def on_if_mod(expression, statement)
        Ruby::IfMod.new(expression, statement, pop_delim(:@kw, :value => 'if'))
      end
      
      def on_unless_mod(expression, statement)
        Ruby::UnlessMod.new(expression, statement, pop_delim(:@kw, :value => 'unless'))
      end
    end
  end
end