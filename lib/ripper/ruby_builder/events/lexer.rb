class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Lexer      
      def extract_src(from, to)
        lines = src.split("\n")[from[0]..to[0]]
        lines[0] = lines.first[from[1]..-1]
        lines[lines.length - 1] = lines.last.slice(0, to[1])
        lines.join("\n")
      end
      
      def heredoc_stack
        @heredoc_stack ||= []
      end
      
      # strangely there doesn't seem to be a way to access the heredoc content
      # other than this, so we need to add some logic here
      def on_heredoc_beg(*args) 
        token = push(super)
        heredoc_stack << position.tap { |p| p[1] += token.value.length }
      end
      
      def on_heredoc_end(*args)
        token = push(super)
        content = extract_src(heredoc_stack.pop, position)
        Ruby::StringContent.new(content, position, pop_whitespace)
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

      def on_tstring_end(*args)
        push(super)
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
    end
  end
end