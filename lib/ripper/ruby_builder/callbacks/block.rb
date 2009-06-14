class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Block
      def on_method_add_arg(call, args)
        call.arguments = args
        call
      end

      def on_method_add_block(call, block)
        block.rdelim = pop_delim(:@kw, :value => 'end') || pop_delim(:@rbrace)
        block.ldelim = pop_delim(:@kw, :value => 'do')  || pop_delim(:@lbrace)
        call.block = block
        call
      end

      def on_do_block(params, statements)
        Ruby::Block.new(statements.compact, params)
      end
      
      def on_brace_block(params, statements)
        Ruby::Block.new(statements.compact, params)
      end

      def on_block_var(params, something)
        params
      end
    end
  end
end