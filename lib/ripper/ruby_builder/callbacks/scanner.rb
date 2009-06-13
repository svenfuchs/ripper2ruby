class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Scanner
      def on_sp(*args)
        push(super)
      end

      def on_nl(*args)
        push(super)
      end

      def on_ignored_nl(*args)
        push(super)
      end
      
      def on_symbeg(*args)
        push(super)
      end

      def on_tstring_beg(*args)
        push(super)
      end

      def on_tstring_end(*args)
        push(super)
      end

      def on_lparen(*args)
        push(super)
      end

      def on_rparen(*args)
        push(super)
      end

      def on_lbracket(*args)
        push(super)
      end

      def on_rbracket(*args)
        push(super)
      end

      def on_lbrace(*args)
        push(super)
      end
      
      def on_rbrace(*args)
        push(super)
      end

      def on_qwords_beg(*args)
        push(super)
      end

      def on_op(*args)
        push(super)
      end

      def on_comma(*args)
        push(super)
      end
      
      def on_words_sep(*args)
        push(super)
      end
      
      def on_period(*args)
        push(super)
      end

      # def on_words_beg(*args)
      #   super.tap { |result| p result }
      # end
    end
  end
end