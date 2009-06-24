class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Lexer
      # unimplemented = :tlambda, :tlambeg
      
      def on_parse_error(msg)
        raise ParseError.new("#{filename}:#{position.row + 1}: #{msg}")
      end
      
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

      def on_tstring_end(token)
        push(super)
        on_words_sep(token) && on_words_end(token) if closes_words?(token)
      end

      def on_qwords_beg(*args)
        push(super)
      end

      def on_words_beg(*args)
        push(super)
      end
      
      def on_words_sep(token)
        token.each_char do |token|
          try_trigger_whitespace(token, super[2]) || push([:@words_end, token, super[2]])
        end
      end
      
      def try_trigger_whitespace(token, position)
        case token
        when "\n"
          push([:@nl, token, position])
        when /\s+/
          push([:@sp, token, position])
        end
      end
      
      def on_embexpr_beg(*args)
        push(super)
      end
      
      def on_embexpr_end(*args)
        push(super)
      end
      
      def on_regexp_beg(*args)
        push(super)
      end
      
      def on_regexp_end(*args)
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

      def on_op(*args)
        push(super)
      end

      def on_comma(*args)
        push(super)
      end
      
      def on_backtick(*args)
        push(super)
      end
      
      def on_period(*args)
        push(super)
      end
      
      def on_semicolon(*args)
        push(super)
      end
      
      def on_comment(*args)
        push(super)
      end
      
      def on_embdoc(doc)
        push([:@comment, doc, position])
      end
      
      def on_embdoc_beg(doc)
        push([:@comment, doc, position])
      end
      
      def on_embdoc_end(doc)
        push([:@comment, doc, position])
      end
      
      def on_embvar(*args)
        push(super)
      end
      
      def on___end__(*args)
        # TODO
        super
      end
    end
  end
end