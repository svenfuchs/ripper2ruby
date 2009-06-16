class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Method
      def on_def(identifier, params, body)
        identifier = identifier.to_identifier if identifier.respond_to?(:to_identifier)
        rdelim, ldelim = stack_ignore(:@op, :@comma, :@lparen, :@rparen) do 
          pop_tokens(:@kw, :value => %w(def end))
        end
        Ruby::Method.new(identifier, params, body, ldelim, rdelim)
      end
    end
  end
end