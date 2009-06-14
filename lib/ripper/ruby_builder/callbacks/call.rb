class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Call
      def on_command(identifier, args)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_command_call(target, separator, identifier, args)
        separator = pop_delim(:@period)
        Ruby::Call.new(target, separator, identifier, args)
      end

      def on_call(target, separator, identifier)
        separator = pop_delim(:@period)
        Ruby::Call.new(target, separator, identifier)
      end

      def on_fcall(identifier)
        Ruby::Call.new(nil, nil, identifier)
      end

      # assignment methods, e.g. a.b = :c
      def on_field(target, separator, identifier)
        separator = stack_ignore(:@op) { pop_delim(:@period) }
        Ruby::Call.new(target, separator, identifier)
      end
      
      # TODO defined?(A), technically not a method call ... have Defined < Call for this?
      def on_defined(ref)
        rdelim = pop_delim(:@rparen)
        ldelim = pop_delim(:@lparen)
        token = pop_delim(:@kw, :value => 'defined?')

        args = Ruby::ArgsList.new(ref, ldelim, rdelim)
        Ruby::Call.new(nil, nil, token.to_identifier, args)
      end
    end
  end
end