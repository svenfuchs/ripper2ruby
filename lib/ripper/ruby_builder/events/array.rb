class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Array
      def on_array(args)
        rdelim = pop_token(:@rbracket)
        ldelim = pop_token(:@lbracket)
        args ? args.to_array(ldelim, rdelim) : Ruby::Array.new(nil, ldelim, rdelim)
      end

      def on_words_new(*args)
        rdelim = pop_token(:@words_end)
        ldelim = pop_token(:@words_beg)
        words = Ruby::Array.new(nil, ldelim, rdelim)
        string_stack << words
        words
      end

      def on_words_add(array, word)
        array.rdelim ||= pop_token(:@words_end)
        array << word
        array
      end

      def on_qwords_new(*args)
        rdelim = pop_token(:@words_end)
        ldelim = pop_token(:@qwords_beg)
        words = Ruby::Array.new(nil, ldelim, rdelim)
        string_stack << words unless rdelim
        words
      end

      def on_qwords_add(array, word)
        word = on_word_add(on_word_new, word) # simulating missing on_word_new and on_word_add events
        array.rdelim ||= pop_token(:@words_end)
        array << word
        array
      end

      def on_words_end(rdelim = nil)
        words = string_stack.pop
        words.rdelim ||= pop_token(:@tstring_end, :@words_sep)
        words
      end

      def on_aref(target, args)
        args ||= Ruby::ArgsList.new
        args.ldelim ||= pop_token(:@lbracket, :left => target)
        args.rdelim ||= pop_token(:@rbracket, :reverse => true, :pass => true, :left => args.ldelim)
        Ruby::Call.new(target, nil, nil, args)
      end

      def on_aref_field(target, args)
        args ||= Ruby::ArgsList.new
        args.ldelim ||= pop_token(:@lbracket, :left => target)
        args.rdelim ||= pop_token(:@rbracket, :reverse => true, :pass => true, :left => args.ldelim)
        Ruby::Call.new(target, nil, nil, args)
      end
      
      protected
      
        WORD_DELIMITER_MAP = { '(' => ')', '[' => ']', '{' => '}' }
      
        def closes_words?(token)
          return false unless string_stack.last.is_a?(Ruby::Array)
          return false unless string_stack.last.ldelim.token =~ /^%w\s*([^\s]*)/i
          (WORD_DELIMITER_MAP[$1] || $1) == token.gsub(/[%w\s]/i, '')
        end
    end
  end
end

