class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module String
      def on_string_concat(*strings)
        Ruby::StringConcat.new(strings)
      end
      
      def on_string_literal(string)
        string.rdelim = pop_token(:@tstring_end, :@heredoc_end)
        string
      end

      def on_xstring_literal(string)
        string.rdelim = pop_token(:@tstring_end)
        string
      end

      def on_regexp_literal(string, rdelim)
        string.rdelim = pop_token(:@regexp_end)
        string
      end

      def on_string_add(string, content)
        string << content
        string
      end

      def on_word_add(string, content)
        string << content
        string
      end

      def on_xstring_add(string, content)
        string.tap { |s| s << content }
      end
      
      def on_string_embexpr(expression)
        expression.ldelim = pop_token(:@embexpr_beg)
        expression.rdelim = pop_token(:@rbrace)
        expression
      end
      
      def on_string_content(*args)
        ldelim = pop_token(:@tstring_beg, :@heredoc_beg)
        Ruby::String.new(ldelim)
      end

      def on_xstring_new(*args)
        ldelim = pop(:@symbeg, :@backtick, :@regexp_beg, :max => 1).first
        if ldelim.type == :@symbeg
          Ruby::DynaSymbol.new(build_token(ldelim))
        elsif ldelim.type == :@regexp_beg
          Ruby::Regexp.new(build_token(ldelim))
        else
          Ruby::ExecutableString.new(build_token(ldelim))
        end
      end

      def on_tstring_content(token)
        Ruby::StringContent.new(token, position)
      end

      def on_word_new
        Ruby::String.new
      end
      
      def on_string_dvar(variable)
        variable.token = '#' + variable.token # HACK. from where can we obtain the hashmark?
        variable
      end
      
      def heredoc_stack
        @heredoc_stack ||= []
      end
      
      # strangely there doesn't seem to be a way to access the heredoc content
      # other than this, so we need to add some logic here
      def on_heredoc_beg(*args) 
        token = push(super)
        heredoc_stack << position.tap { |p| p.col += token.value.length }
      end
      
      def on_heredoc_end(*args)
        token = push(super)
        content = extract_src(heredoc_stack.pop, position)
        Ruby::StringContent.new(content, position, pop_whitespace)
      end
    end
  end
end