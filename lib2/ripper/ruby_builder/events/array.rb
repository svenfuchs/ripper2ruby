class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Array
      # elements and separators are collected in on_args_add
      # confusingly ripper throws the same events
      
      def on_array(args)
        rdelim, ldelim = pop_delims(:@rbracket, :@lbracket)
        args ? args.to_array(ldelim, rdelim) : Ruby::Array.new(nil, nil, ldelim, rdelim)
      end
      
      def on_qwords_new(*args)
        Ruby::Array.new(nil, pop_delim(:@qwords_beg))
      end
      
      def on_qwords_add(array, arg)
        tokens = pop_delims(:@words_sep)

        array.separators += tokens.select { |t| t.token =~ /^\s*$/ }
        array.rdelim = (tokens - array.separators).first
        array << arg
        array
      end
      
      def on_aref(target, args)
        Ruby::Call.new(target, nil, nil, args)
      end
      
      def on_aref_field(target, args)
        Ruby::Call.new(target, nil, nil, args)
      end
    end
  end
end

