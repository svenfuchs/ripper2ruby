class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Call
      def on_command(identifier, args)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_command_call(target, separator, identifier, args)
        separator = pop_token(:@period)
        Ruby::Call.new(target, separator, identifier, args)
      end

      def on_call(target, separator, identifier)
        separator = pop_token(:@period, :ignore => [:@do, :@lbrace])
        Ruby::Call.new(target, separator, identifier)
      end

      def on_fcall(identifier)
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_zsuper(*args)
        identifier = pop_token(:@super).to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_yield(args)
        identifier = pop_token(:@yield).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_yield0
        identifier = pop_token(:@yield).to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_alias(*args)
        identifier = pop_token(:@alias).to_identifier
        Ruby::Alias.new(identifier, args)
      end

      def on_undef(args)
        identifier = pop_token(:@undef).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_return0
        identifier = pop_token(:@return).to_identifier
        Ruby::Call.new(nil, nil, identifier, nil)
      end

      def on_return(args)
        identifier = pop_token(:@return).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_next(args)
        identifier = pop_token(:@next).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_break(args)
        identifier = pop_token(:@break).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_redo
        identifier = pop_token(:@redo).to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_retry
        identifier = pop_token(:@retry).to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      # assignment methods, e.g. a.b = :c
      def on_field(target, separator, identifier)
        separator = pop_token(:@period)
        Ruby::Call.new(target, separator, identifier)
      end

      # TODO defined?(A), technically not a method call ... have Defined < Call for this?
      def on_defined(ref)
        ldelim = pop_token(:@lparen)
        rdelim = pop_token(:@rparen)
        token  = pop_token(:@defined)

        args = Ruby::ArgsList.new(ref, nil, ldelim, rdelim)
        Ruby::Call.new(nil, nil, token.to_identifier, args)
      end
      
      def on_BEGIN(statements)
        statements.ldelim = pop_token(:@lbrace)
        statements.rdelim = pop_token(:@rbrace)
        identifier = pop_token(:@BEGIN).to_identifier
        Ruby::Call.new(nil, nil, identifier, nil, statements)
      end
    end
  end
end