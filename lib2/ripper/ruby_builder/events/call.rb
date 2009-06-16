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

      def on_zsuper(*args)
        identifier = pop_delim(:@kw, :value => 'super').to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_yield(args)
        identifier = pop_delim(:@kw, :value => 'yield').to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_yield0
        identifier = pop_delim(:@kw, :value => 'yield').to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_alias(*args)
        identifier = pop_delim(:@kw, :value => 'alias').to_identifier
        Ruby::Alias.new(identifier, args)
      end

      def on_undef(args)
        identifier = pop_delim(:@kw, :value => 'undef').to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_return(args)
        identifier = pop_delim(:@kw, :value => 'return').to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_next(args)
        identifier = pop_delim(:@kw, :value => 'next').to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_break(args)
        identifier = pop_delim(:@kw, :value => 'break').to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_redo
        identifier = pop_delim(:@kw, :value => 'redo').to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_retry
        identifier = pop_delim(:@kw, :value => 'retry').to_identifier
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

        args = Ruby::ArgsList.new(ref, nil, ldelim, rdelim)
        Ruby::Call.new(nil, nil, token.to_identifier, args)
      end
      
      def on_BEGIN(statements)
        statements.rdelim = pop_delim(:@rbrace)
        statements.ldelim = pop_delim(:@lbrace)
        identifier = pop_delim(:@kw, :value => 'BEGIN').to_identifier
        Ruby::Call.new(nil, nil, identifier, nil, statements)
      end
    end
  end
end