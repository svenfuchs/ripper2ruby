class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Identifier
      def on_ident(token)
        push
        Ruby::Identifier.new(token, position, pop_whitespace)
      end

      def on_cvar(token)
        push
        Ruby::Variable.new(token, position, pop_whitespace)
      end
      
      def on_ivar(token)
        push
        Ruby::Variable.new(token, position, pop_whitespace)
      end
      
      def on_gvar(token)
        push
        Ruby::Variable.new(token, position, pop_whitespace)
      end
    end
  end
end