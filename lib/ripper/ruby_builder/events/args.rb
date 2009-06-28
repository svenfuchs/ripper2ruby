class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Args
      def on_method_add_arg(call, args)
        call.arguments = args
        call
      end

      def on_arg_paren(args)
        args ||= Ruby::ArgsList.new
        args.rdelim ||= pop_token(:@rparen)
        args.ldelim ||= pop_token(:@lparen)
        args
      end
      
      def on_args_add_block(args, block)
        args << Ruby::Arg.new(block, pop_token(:'@&')) if block
        args
      end
      
      def on_args_add_star(args, arg)
        args << Ruby::Arg.new(arg, pop_token(:'@*', :pass => true))
        args
      end

      def on_args_add(args, arg)
        args << arg
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
