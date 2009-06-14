class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Structures
      def build_if_block(statements)
        ldelim = stack_ignore(:@kw) do 
          pop_delim(:@kw, :value => 'then') || pop_delim(:@semicolon)
        end
        Ruby::Block.new(statements, nil, ldelim)
      end

      def on_if(expression, statements, else_block)
        if_block = build_if_block(statements)
        ldelim, rdelim = stack_ignore(:@semicolon) { pop_delims(:@kw, :value => %w(if end)).reverse }
        Ruby::If.new(expression, if_block, else_block, ldelim, rdelim)
      end
      
      def on_elsif(expression, statements, else_block)
        if_block = build_if_block(statements)
        ldelim, rdelim = stack_ignore(:@semicolon) { pop_delims(:@kw, :value => %w(elsif end)).reverse }
        Ruby::If.new(expression, if_block, else_block, ldelim, rdelim)
      end
      
      def on_else(statements)
        rdelim = stack_ignore(:@kw) { pop_delim(:@semicolon) }
        ldelim = stack_ignore(:@kw) { pop_delim(:@kw, :value => 'else') }
        block = Ruby::Block.new(statements, nil, ldelim, rdelim)
      end
    end
  end
end