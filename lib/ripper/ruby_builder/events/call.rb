class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Call
      def on_command(identifier, args)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_command_call(target, separator, identifier, args)
        separator = pop_token(:@period, :"@::", :pass => true)
        Ruby::Call.new(target, separator, identifier, args)
      end

      def on_call(target, separator, identifier)
        # happens for symbols that are also keywords, e.g. :if
        identifier = pop_token(identifier.type).to_identifier if identifier.respond_to?(:known?) && identifier.known?
        separator = pop_token(:@period, :"@::", :left => target, :right => identifier)
        Ruby::Call.new(target, separator, identifier)
      end

      def on_fcall(identifier)
        Ruby::Call.new(nil, nil, identifier)
      end

      # assignment methods, e.g. a.b = :c
      def on_field(target, separator, identifier)
        separator = pop_token(:@period, :"@::", :pass => true)
        Ruby::Call.new(target, separator, identifier)
      end

      def on_zsuper(*args)
        identifier = pop_token(:@super, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end
      
      def on_super(args)
        identifier = pop_token(:@super, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_yield(args)
        identifier = pop_token(:@yield, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_yield0
        identifier = pop_token(:@yield, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_alias(*args)
        args.map! { |arg| arg.respond_to?(:to_identifier) ? arg.to_identifier : arg }
        identifier = pop_token(:@alias, :pass => true).to_identifier
        Ruby::Alias.new(identifier, args)
      end
      
      def on_var_alias(*args)
        args.map! { |arg| arg.respond_to?(:to_identifier) ? arg.to_identifier : arg }
        identifier = pop_token(:@alias, :pass => true).to_identifier
        Ruby::Alias.new(identifier, args)
      end

      def on_undef(args)
        args = Ruby::ArgsList.new(args, pop_tokens(:@comma))
        identifier = pop_token(:@undef, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_return0
        identifier = pop_token(:@return, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier, nil)
      end

      def on_return(args)
        identifier = pop_token(:@return, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_next(args)
        identifier = pop_token(:@next, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_break(args)
        identifier = pop_token(:@break, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_redo
        identifier = pop_token(:@redo, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_retry
        identifier = pop_token(:@retry, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier)
      end

      # TODO defined?(A), technically not a method call ... have Defined < Call for this?
      def on_defined(ref)
        token  = pop_token(:@defined, :pass => true)
        ldelim = pop_token(:@lparen, :left => token)
        rdelim = pop_token(:@rparen) if ldelim

        args = Ruby::ArgsList.new(ref, ldelim, rdelim)
        Ruby::Call.new(nil, nil, token.to_identifier, args)
      end
      
      def on_BEGIN(statements)
        statements.ldelim = pop_token(:@lbrace)
        statements.rdelim = pop_token(:@rbrace)
        identifier = pop_token(:@BEGIN, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier, nil, statements)
      end
      
      def on_END(statements)
        statements.ldelim = pop_token(:@lbrace)
        statements.rdelim = pop_token(:@rbrace)
        identifier = pop_token(:@END, :pass => true).to_identifier
        Ruby::Call.new(nil, nil, identifier, nil, statements)
      end
    end
  end
end