class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Method
      def on_def(identifier, params, body)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@def, :pass => true)
        # the identifier might be a keyword, e.g. def class; end
        identifier = pop_identifier(identifier.type, :left => ldelim, :right => rdelim) if identifier.is_a?(Ripper::RubyBuilder::Token)
        Ruby::Method.new(nil, nil, identifier, params, body, ldelim, rdelim)
      end
      
      def on_defs(target, separator, identifier, params, body)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@def, :pass => true)
        identifier = pop_identifier(identifier.type, :left => ldelim, :right => rdelim) if identifier.is_a?(Ripper::RubyBuilder::Token)
        separator = pop_token(:@period, :'@::')
        Ruby::Method.new(target, separator, identifier, params, body, ldelim, rdelim)
      end
    end
  end
end
