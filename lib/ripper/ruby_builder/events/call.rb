class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Call
      def on_command(identifier, args)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_command_call(target, separator, identifier, args)
        separator = pop_token(:@period, :"@::")
        Ruby::Call.new(target, separator, identifier, args)
      end

      def on_call(target, separator, identifier)
        # happens for symbols that are also keywords, e.g. :if
        identifier = pop_identifier(identifier.type) if identifier.try(:known?)
        separator = pop_token(:@period, :"@::", :left => target, :right => identifier)
        Ruby::Call.new(target, separator, identifier)
      end

      def on_fcall(identifier)
        Ruby::Call.new(nil, nil, identifier)
      end

      # assignment methods, e.g. a.b = :c
      def on_field(target, separator, identifier)
        separator = pop_token(:@period, :"@::")
        Ruby::Call.new(target, separator, identifier)
      end

      def on_zsuper(*args)
        identifier = pop_identifier(:@super)
        Ruby::Call.new(nil, nil, identifier)
      end
      
      def on_super(args)
        identifier = pop_identifier(:@super)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_yield(args)
        identifier = pop_identifier(:@yield)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_yield0
        identifier = pop_identifier(:@yield)
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_alias(*args)
        args.map! { |arg| arg.try(:to_identifier) || arg }
        identifier = pop_identifier(:@alias)
        Ruby::Alias.new(identifier, args)
      end
      
      def on_var_alias(*args)
        args.map! { |arg| arg.try(:to_identifier) || arg }
        identifier = pop_identifier(:@alias)
        Ruby::Alias.new(identifier, args)
      end

      def on_undef(args)
        args = Ruby::ArgsList.new(args, pop_tokens(:@comma))
        identifier = pop_identifier(:@undef)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_return0
        identifier = pop_identifier(:@return)
        Ruby::Call.new(nil, nil, identifier, nil)
      end

      def on_return(args)
        identifier = pop_identifier(:@return)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_next(args)
        identifier = pop_identifier(:@next)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_break(args)
        identifier = pop_identifier(:@break)
        Ruby::Call.new(nil, nil, identifier, args)
      end

      def on_redo
        identifier = pop_identifier(:@redo)
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_retry
        identifier = pop_identifier(:@retry)
        Ruby::Call.new(nil, nil, identifier)
      end

      def on_defined(ref)
        identifer = pop_identifier(:@defined, :pass => true)
        ldelim = pop_token(:@lparen, :left => identifer)
        rdelim = pop_token(:@rparen) if ldelim
        args = Ruby::ArgsList.new(ref, ldelim, rdelim)
        Ruby::Call.new(nil, nil, identifer, args)
      end
      
      def on_BEGIN(statements)
        statements.ldelim = pop_token(:@lbrace)
        statements.rdelim = pop_token(:@rbrace)
        identifier = pop_identifier(:@BEGIN)
        Ruby::Call.new(nil, nil, identifier, nil, statements)
      end
      
      def on_END(statements)
        statements.ldelim = pop_token(:@lbrace)
        statements.rdelim = pop_token(:@rbrace)
        identifier = pop_identifier(:@END)
        Ruby::Call.new(nil, nil, identifier, nil, statements)
      end
    end
  end
end