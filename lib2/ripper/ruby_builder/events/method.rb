class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Method
      def on_def(identifier, params, body)
        identifier = identifier.to_identifier if identifier.respond_to?(:to_identifier)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@def)
        Ruby::Method.new(identifier, params, body, ldelim, rdelim)
      end
    end
  end
end