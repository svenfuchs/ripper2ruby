class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Method
      def on_def(identifier, params, body)
        identifier = identifier.to_identifier if identifier.respond_to?(:to_identifier)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@def)
        Ruby::Method.new(nil, nil, identifier, params, body, ldelim, rdelim)
      end
      
      def on_defs(target, separator, identifier, params, body)
        identifier = identifier.to_identifier if identifier.respond_to?(:to_identifier)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@def)
        separator = pop_token(:@period)
        Ruby::Method.new(target, separator, identifier, params, body, ldelim, rdelim)
      end
    end
  end
end