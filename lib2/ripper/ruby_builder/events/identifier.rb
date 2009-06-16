class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Identifier
      def on_ident(token)
        Ruby::Identifier.new(token, position, pop_whitespace)
      end

      def on_cvar(token)
        Ruby::Variable.new(token, position, pop_whitespace)
      end
      
      def on_ivar(token)
        Ruby::Variable.new(token, position, pop_whitespace)
      end
      
      def on_gvar(token)
        Ruby::Variable.new(token, position, pop_whitespace)
      end
    end
  end
end