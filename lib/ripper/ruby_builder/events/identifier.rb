class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Identifier
      def on_ident(token)
        push(super)
        token = pop_token(:@ident)
        Ruby::Identifier.new(token.token, token.position, token.context)
      end

      def on_cvar(token)
        push(super)
        token = pop_token(:@cvar)
        Ruby::Variable.new(token.token, token.position, token.context)
      end
      
      def on_ivar(token)
        push(super)
        token = pop_token(:@ivar)
        Ruby::Variable.new(token.token, token.position, token.context)
      end
      
      def on_gvar(token)
        push(super)
        token = pop_token(:@gvar)
        Ruby::Variable.new(token.token, token.position, token.context)
      end
    end
  end
end