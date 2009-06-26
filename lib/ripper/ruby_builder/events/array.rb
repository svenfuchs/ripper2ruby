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
        tstring_stack << words
        words
      end

      def on_qwords_new(*args)
        rdelim = pop_token(:@words_end)
        ldelim = pop_token(:@qwords_beg)
        words = Ruby::Array.new(nil, ldelim, rdelim)
        tstring_stack << words # there's no @qwords_end event, so we hook into @tstring_end
        words
      end

      def on_words_add(array, arg)
        array.rdelim ||= pop_token(:@words_end)
        array << arg
        array
      end

      def on_qwords_add(array, arg)
        array.rdelim ||= pop_token(:@words_end)
        array << arg
        array
      end

      def on_words_end(rdelim = nil)
        array = tstring_stack.pop
        array.rdelim ||= pop_token(:@tstring_end, :@words_sep)
        array
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
          return false unless tstring_stack.last.try(:ldelim)
          return false unless tstring_stack.last.ldelim.token =~ /^%w\s*([^\s]*)/i
          (WORD_DELIMITER_MAP[$1] || $1) == token.gsub(/[%w\s]/i, '')
        end
    end
  end
end

