class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Program
      def on_program(statements)
        Ruby::Program.new(src, filename, statements)
      end
    end
  end
end