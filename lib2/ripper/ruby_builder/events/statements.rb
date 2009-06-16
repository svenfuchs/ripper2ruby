class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Statements
      def build_statements(statements = nil, separators = nil)
        rdelim, ldelim = pop_delim(:@rparen), pop_delim(:@lparen)
        node = Ruby::Statements.new(statements, separators, ldelim, rdelim)
      end
      
      def on_program(statements)
        program = statements.to_program(src, filename)
        program.separators += pop_delims(:@semicolon)
        program
      end

      def on_body_stmt(statements, rescue_block, something, ensure_block)
        # , rescue_block, ensure_block)
        statements.separators += stack_ignore(:@kw, :value => 'end') { pop_delims(:@semicolon) }
        statements
      end
      
      def on_paren(node)
        node = build_statements(node) if stack.peek.type == :@rparen
        node
      end

      def on_stmts_add(target, statement)
        target.separators += pop_delims(:@semicolon)
        target.elements << statement if statement
        target
      end

      def on_stmts_new
        build_statements(nil, pop_delims(:@semicolon))
      end
    
      def on_void_stmt
        nil
      end

      def on_var_ref(ref)
        ref.instance_of?(Ruby::Identifier) ? ref.to_variable : ref
      end

      def on_const_ref(const)
        const
      end

      def on_var_field(field)
        field
      end
    end
  end
end