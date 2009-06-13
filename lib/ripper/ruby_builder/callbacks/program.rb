class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Program
      def on_program(statements)
        Ruby::Program.new(src, filename, statements)
      end

      def on_stmts_add(target, statement)
        target << statement
        target
      end

      def on_stmts_new
        []
      end
    
      def on_void_stmt
        nil # what's this?
      end
    end
  end
end