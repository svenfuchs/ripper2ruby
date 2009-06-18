class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Statements
      def build_statements(statements = nil, separators = nil)
        rdelim, ldelim = pop_token(:@rparen), pop_token(:@lparen)
        node = Ruby::Statements.new(statements, separators, ldelim, rdelim)
      end
      
      def on_program(statements)
        program = statements.to_program(src, filename)
        program.separators += pop_tokens(:@semicolon)
        program << Ruby::Token.new('', position, pop_whitespace) if stack.peek.whitespace?
        program
      end

      def on_body_stmt(body, rescue_block, something, ensure_block)
        body.separators += pop_tokens(:@semicolon)
        body = body.to_chained_block(nil, [rescue_block, ensure_block].compact) if rescue_block || ensure_block
        body
      end
      
      def on_paren(node)
        node = build_statements(node) if stack.peek.type == :@rparen
        node
      end

      def on_stmts_add(target, statement)
        target.separators += pop_tokens(:@semicolon)
        target.elements << statement if statement
        target
      end

      def on_stmts_new
        build_statements(nil, pop_tokens(:@semicolon))
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
      
      def on_backref(arg)
        Ruby::Variable.new(arg, position, pop_whitespace)
      end
    end
  end
end