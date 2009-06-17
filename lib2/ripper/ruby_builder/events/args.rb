class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Args
      def on_method_add_arg(call, args)
        call.arguments = args
        call
      end

      def on_arg_paren(args)
        args ||= Ruby::ArgsList.new # will be nil when call has an empty arglist, e.g. I18n.t()
        pop_token(:@rparen).tap { |r| args.rdelim = r if r }
        pop_token(:@lparen).tap { |l| args.ldelim = l if l }
        args
      end
      
      def on_args_add_block(args, block)
        rdelim = pop_token(:@rparen, :@rbracket) # also used by :aref_field assignments, i.e. array[0] = :foo
        separators = pop_tokens(:@comma).reverse
        ldelim = pop_token(:@lparen, :@lbracket)
      
        args << Ruby::Arg.new(block, pop_token(:@op, :value => '&')) if block
        args.separators += separators if separators
        args.ldelim = ldelim if ldelim
        args.rdelim = rdelim if rdelim
        args
      end
      
      def on_args_add_star(args, arg)
        args.separators += pop_tokens(:@comma).reverse
        args << Ruby::Arg.new(arg, pop_token(:@op, :value => '*'))
        args
      end

      def on_args_add(args, arg)
        args.separators += pop_tokens(:@comma).reverse
        args << Ruby::Arg.new(arg)
        args
      end
      
      def on_blockarg(identifier)
        Ruby::Arg.new(identifier, pop_token(:@op, :value => '&'))
      end

      def on_args_new
        Ruby::ArgsList.new
      end
    end
  end
end