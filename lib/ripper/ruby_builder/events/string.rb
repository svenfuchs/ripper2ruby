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
          string.rdelim = pop_token(:@tstring_end)
          string
        end
      end
      
      def on_heredoc_literal(string)
        heredoc
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
        string << content if string && content && !heredoc?
        string
      end
      
      def on_word_add(string, content)
        string << content
        string
      end

      def on_xstring_add(string, content)
        return string if heredoc?
        string.tap { |s| s << content }
      end

      def on_string_embexpr(expression)
        expression.ldelim = pop_token(:@embexpr_beg)
        expression.rdelim = pop_token(:@rbrace)
        expression
      end

      def on_string_content(*args)
        return if heredoc?
        ldelim = pop_token(:@tstring_beg)
        string = Ruby::String.new(ldelim)
        tstring_stack << string
        string
      end

      def on_tstring_content(token)
        return if heredoc?
        content = Ruby::StringContent.new(token, position)
        content
      end

      def on_heredoc_content(*args)
        ldelim = pop_token(:@heredoc_beg)
        heredoc_stack << Ruby::HereDoc.new(ldelim)
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
        on_heredoc_content
      end

      def on_heredoc_end(*args)
        push(super)
        @heredoc = false
        @extra_heredoc = true

        heredoc.rdelim = pop_token(:@heredoc_end)
        pos = heredoc.ldelim.position
        pos = Ruby::Node::Position.new(pos.row, pos.col + heredoc.ldelim.length)
        heredoc << Ruby::StringContent.new(extract_src(pos, heredoc.rdelim.position), pos)
      end
      
      protected
      
        def heredoc_stack
          @heredoc_stack ||= []
        end
        
        def heredoc
          heredoc_stack.last
        end

        def heredoc?
          !!@heredoc || @extra_heredoc
        end

        def extra_heredoc?
          !!@extra_heredoc
        end
        
        def stop_extra_heredoc!
          # p :stop_extra_heredoc!
          heredoc_stack.pop 
          @extra_heredoc = false
        end
      
        def extra_heredoc_chars(token)
          if extra_heredoc? && heredoc_part?(token)
            stop_extra_heredoc! if token.newline? || token.comment?
            true
          else
            false
          end
        end
        
        def heredoc_part?(token)
          return false unless heredoc.ldelim
          return false unless heredoc.rdelim
          heredoc.ldelim <= token && token <= heredoc.rdelim
        end
    end
  end
end