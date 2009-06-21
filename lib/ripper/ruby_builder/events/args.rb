class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Args
      def on_method_add_arg(call, args)
        call.arguments = args
        call
      end

      def on_arg_paren(args)
        args ||= Ruby::ArgsList.new # will be nil when call has an empty arglist, e.g. I18n.t()
        pop_token(:@lparen).tap { |l| args.ldelim = l if l }
        pop_token(:@rparen).tap { |r| args.rdelim = r if r }
        args
      end
      
      def on_args_add_block(args, block)
        args << Ruby::Arg.new(block, pop_token(:'@&')) if block
        separators = pop_tokens(:@comma).reverse
        args.separators += separators if separators
        args
      end
      
      def on_args_add_star(args, arg)
        args.separators += pop_tokens(:@comma).reverse
        args << Ruby::Arg.new(arg, pop_token(:'@*', :pass => true))
        args
      end

      def on_args_add(args, arg)
        args = args.to_heredoc_args_list if arg.is_a?(Ruby::HereDoc)
        args.separators += pop_tokens(:@comma).reverse unless extra_heredoc?
        args << Ruby::Arg.new(arg)
        args
      end
      
      def on_blockarg(identifier)
        Ruby::Arg.new(identifier, pop_token(:'@&'))
      end

      def on_args_new
        Ruby::ArgsList.new
      end
    end
  end
end