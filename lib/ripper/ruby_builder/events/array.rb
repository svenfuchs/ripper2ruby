class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Array
      # elements and separators are collected in on_args_add
      # confusingly ripper throws the same events
      
      def on_array(args)
        ldelim, rdelim = pop_tokens(:@lbracket, :@rbracket)
        args ? args.to_array(ldelim, rdelim) : Ruby::Array.new(nil, nil, ldelim, rdelim)
      end
      
      def on_qwords_new(*args)
        Ruby::Array.new(nil, pop_token(:@qwords_beg))
      end
      
      def on_qwords_add(array, arg)
        tokens = pop_tokens(:@words_sep)
        array.separators += tokens.select { |t| t.token =~ /^\s*$/ }
        array.rdelim = (tokens - array.separators).first
        array << arg
        array
      end
      
      def on_aref(target, args)
        pop_token(:@lbracket).tap { |l| args.ldelim = l if l }
        pop_token(:@rbracket).tap { |r| args.rdelim = r if r }
        Ruby::Call.new(target, nil, nil, args)
      end
      
      def on_aref_field(target, args)
        pop_token(:@lbracket).tap { |l| args.ldelim = l if l }
        pop_token(:@rbracket).tap { |r| args.rdelim = r if r }
        Ruby::Call.new(target, nil, nil, args)
      end
    end
  end
end

