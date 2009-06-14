class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Block
      def on_body_stmt(statements, *something)
        Ruby::Body.new(statements.compact)
      end
    
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

      def on_stmts_add(target, statement)
        rdelim = pop_delim(:@semicolon)
        target << Ruby::Statement.new(statement, rdelim) if statement
        target
      end

      def on_stmts_new
        Ruby::Composite::Array.new
      end
    
      def on_void_stmt
        nil # what's this?
      end
    end
  end
end