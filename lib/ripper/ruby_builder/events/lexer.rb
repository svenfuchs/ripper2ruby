class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Lexer
      # unimplemented = :tlambda, :tlambeg

      def on_parse_error(msg)
        raise ParseError.new("#{filename}:#{position.row + 1}: #{msg}")
      end
      
      def on_param_error(param)
        raise ParseError.new("#{filename}:#{position.row + 1}: syntax error, invalid parameter type: #{param.to_ruby}")
      end

      def on_ignored_nl(*args)
        token = push(super)
        on_heredoc_literal if end_heredoc?(token)
        token
      end

      def on_nl(*args)
        token = push(super)
        on_heredoc_literal if end_heredoc?(token)
        token
      end

      def on_comment(*args)
        token = push(super)
        on_heredoc_literal if end_heredoc?(token)
        token
      end

      def on_sp(*args)
        token = push(super)
        on_heredoc_literal if end_heredoc?(token) # ripper counts \ + nl ("\\\n") as whitespace
        token
      end

      def on_semicolon(*args)
        push(super)
      end

      def on_period(*args)
        push(super)
      end

      def on_comma(*args)
        push(super)
      end

      def on_backtick(*args)
        push(super)
      end

      def on_symbeg(*args)
        push(super)
      end

      def on_tstring_beg(*args)
        push(super)
      end

      def on_tstring_content(token)
        push(super)
        nil
      end

      def on_tstring_end(token)
        push(super)
        on_words_end(token) if closes_words?(token) # simulating on_words_end event
      end

      def on_qwords_beg(*args)
        push(super)
      end

      def on_words_beg(*args)
        push(super)
      end

      def on_words_sep(token)
        token.each_char do |token|
          case token
          when "\n"
            push([:@nl, token, position])
          when /\s+/
            push([:@sp, token, position])
          else
            push([:@words_end, token, position])
            on_words_end(token) if closes_words?(token) # simulating on_words_end event
          end
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
        push(super)
      end
    end
  end
end
