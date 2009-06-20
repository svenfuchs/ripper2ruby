class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Array
      # elements and separators are collected in on_args_add
      # confusingly ripper throws the same events

      def on_array(args)
        rdelim = pop_token(:@rbracket)
        ldelim = pop_token(:@lbracket)
        args ? args.to_array(ldelim, rdelim) : Ruby::Array.new(nil, nil, ldelim, rdelim)
      end

      def on_words_new(*args)
        Ruby::Array.new(nil, pop_token(:@words_beg))
      end

      def on_qwords_new(*args)
        words = Ruby::Array.new(nil, nil, pop_token(:@qwords_beg))
        # there's no reasonable event that lets us catch :@tstring_end, so we gotta keep our own stack
        tstring_stack << words
        words
      end

      def on_qwords_add(array, arg)
        tokens = pop_tokens(:@words_sep)
        array.separators += tokens.select { |t| t.token =~ /^\s*$/ }
        array.rdelim = (tokens - array.separators).first
        array << arg
        array
      end
      
      def on_qwords_end(rdelim)
        array = tstring_stack.pop
        array.rdelim = pop_token(:@tstring_end)
        array
      end

      def on_words_add(array, arg)
        tokens = pop_tokens(:@words_sep)
        array.separators += tokens.select { |t| t.token =~ /^\s*$/ }
        array.rdelim = (tokens - array.separators).first
        array << arg
        array
      end

      def on_aref(target, args)
        args ||= Ruby::ArgsList.new
        pop_token(:@lbracket, :pass => true).tap { |l| args.ldelim = l if l }
        pop_token(:@rbracket, :pass => true).tap { |r| args.rdelim = r if r }
        Ruby::Call.new(target, nil, nil, args)
      end

      def on_aref_field(target, args)
        pop_token(:@lbracket, :pass => true).tap { |l| args.ldelim = l if l }
        pop_token(:@rbracket, :pass => true).tap { |r| args.rdelim = r if r }
        Ruby::Call.new(target, nil, nil, args)
      end
    end
  end
end

