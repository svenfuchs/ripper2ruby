class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module String
      def on_string_concat(*strings)
        Ruby::StringConcat.new(strings)
      end

      def on_string_literal(string)
        if heredoc?
          on_heredoc_literal(string)
        else
          string.rdelim = pop_token(:@tstring_end, :@heredoc_end)
          string
        end
      end
      
      def on_heredoc_literal(string)
        string.rdelim = pop_token(:@heredoc_end)
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
        string << content if content && (!heredoc? || content.is_a?(Ruby::Statements))
        string
      end

      def on_heredoc_add(content)
        heredoc_stack.last << content
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
        if heredoc?
          on_heredoc_content(*args)
        else
          ldelim = pop_token(:@tstring_beg)
          string = Ruby::String.new(ldelim)
          tstring_stack << string
          string
        end
      end

      def on_tstring_content(token)
        content = Ruby::StringContent.new(token, position)
        on_heredoc_add(content) if heredoc?
        content
      end

      def on_heredoc_content(*args)
        ldelim = pop_token(:@heredoc_beg)
        string = Ruby::HereDoc.new(ldelim)
        heredoc_stack << string
        string
      end

      def on_xstring_new(*args)
        ldelim = pop(:@symbeg, :@backtick, :@regexp_beg, :max => 1, :pass => true).first
        string = if ldelim.type == :@symbeg
          Ruby::DynaSymbol.new(build_token(ldelim))
        elsif ldelim.type == :@regexp_beg
          Ruby::Regexp.new(build_token(ldelim))
        else
          Ruby::ExecutableString.new(build_token(ldelim))
        end
        tstring_stack << string
        string
      end

      def on_word_new
        Ruby::String.new
      end

      def on_string_dvar(variable)
        variable.token = '#' + variable.token # HACK. from where can we obtain the hashmark?
        variable
      end
      
      def on_heredoc_beg(*args)
        token = push(super)
        @heredoc = true
      end

      def on_heredoc_end(*args)
        push(super)
        @heredoc = false
        nil
      end
      
      protected

        def heredoc?
          !!@heredoc
        end
      
        def extra_heredoc_chars(token)
          return false if !extra_heredoc_stage? || arglist_element?(token)
          string = heredoc_stack.last
          string.separators << build_token(token)

          heredoc_stack.pop if token.newline?
          true
        end
        
        def arglist_element?(token)
          [:@comma, :@rparen].include?(token.type) || token.operator? || 
          stack.peek.type == :@comma || stack.peek.operator?
        end
      
        def extra_heredoc_stage?
          !heredoc? && !!heredoc_stack.last
        end
      
        def extra_heredoc_char?(type)
          [*WHITESPACE, :@semicolon].include?(type)
        end

        def heredoc_stack
          @heredoc_stack ||= []
        end
    end
  end
end