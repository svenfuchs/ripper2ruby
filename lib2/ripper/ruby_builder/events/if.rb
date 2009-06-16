class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module If
      def build_if_block(statements)
        ldelim = stack_ignore(:@kw) { pop_delim(:@kw, :value => 'then') }
        Ruby::Block.new(statements, nil, nil, nil, ldelim)
      end

      def on_if(args, statements, else_block)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        if_block = build_if_block(statements)

        rdelim = pop_delim(:@kw, :value => 'end')
        args.separators += pop_delims(:@semicolon)
        ldelim = pop_delim(:@kw, :value => 'if')
        
        Ruby::If.new(args, if_block, else_block, ldelim, rdelim)
      end

      def on_unless(args, statements, else_block)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        if_block = build_if_block(statements)

        rdelim = pop_delim(:@kw, :value => 'end')
        args.separators += pop_delims(:@semicolon)
        ldelim = pop_delim(:@kw, :value => 'if')
        
        Ruby::Unless.new(args, if_block, else_block, ldelim, rdelim)
      end
      
      def on_elsif(args, statements, else_block)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        if_block = build_if_block(statements)

        rdelim = pop_delim(:@kw, :value => 'end')
        args.separators += pop_delims(:@semicolon)
        ldelim = pop_delim(:@kw, :value => 'if')
        
        Ruby::If.new(args, if_block, else_block, ldelim, rdelim)
      end
      
      def on_else(statements)
        ldelim = stack_ignore(:@kw) { pop_delim(:@kw, :value => 'else') }
        block = Ruby::Else.new(statements, nil, nil, ldelim)
      end
      
      def on_if_mod(args, statement)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        Ruby::IfMod.new(args, statement, pop_delim(:@kw, :value => 'if'))
      end
      
      def on_unless_mod(args, statement)
        args = Ruby::ArgsList.new(args) unless args.is_a?(Ruby::List)
        Ruby::UnlessMod.new(args, statement, pop_delim(:@kw, :value => 'unless'))
      end
    end
  end
end