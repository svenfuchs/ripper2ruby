class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Statements
      def build_statements(statements = nil, separators = nil, rdelim = nil, ldelim = nil)
        node = Ruby::Statements.new(statements, separators, ldelim, rdelim)
      end
      
      def on_program(statements)
        program = statements.to_program(src, filename)
        program.separators += pop_tokens(:@semicolon)
        program << Ruby::Token.new('', position, pop_whitespace) if stack.whitespace?
        program
      end

      def on_body_stmt(body, rescue_block, else_block, ensure_block)
        body.separators += pop_tokens(:@semicolon)
        statements = [rescue_block, else_block, ensure_block].compact
        body = body.to_chained_block(nil, statements) if rescue_block || ensure_block
        body
      end
      
      def on_paren(node)
        if stack.peek.type == :@rparen
          case node
          when Ruby::List
            node.rdelim = pop_token(:@rparen)
            node.separators += pop_tokens(:@comma, :@semicolon)
            node.ldelim = pop_token(:@lparen)
          else
            p 'in: on_paren', node
            node = build_statements(node, nil, pop_token(:@rparen), pop_token(:@lparen))
          end
        end
        
        node
      end

      def on_stmts_add(target, statement)
        target.separators += pop_tokens(:@semicolon)
        target.elements << statement if statement
        target
      end

      def on_stmts_new
        Ruby::Statements.new
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
        push
        Ruby::Variable.new(arg, position, pop_whitespace)
      end
    end
  end
end