class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module String
      def on_string_concat(*strings)
        Ruby::StringConcat.new(strings)
      end

      def on_string_literal(string)
        if heredoc?
          @heredoc_beg
        else
          string.rdelim = pop_token(:@tstring_end)
          string
        end
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
        return string if heredoc?
        string << content if string && content
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
        ldelim = pop_token(:@tstring_beg)
        string = Ruby::String.new(ldelim)
        tstring_stack << string
        string
      end

      def on_tstring_content(token)
        content = Ruby::StringContent.new(token, position)
        content
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
      
      def string_stack
        @string_stack ||= []
      end
      
      def on_heredoc_beg(*args)
        token = push(super)
        @heredoc_beg = pop_token(:@heredoc_beg)
        @heredoc     = Ruby::HereDoc.new
        
        @string_stack << @heredoc_beg
      end

      def on_heredoc_end(*args)
        push(super)
        @heredoc.rdelim = pop_token(:@heredoc_end)
        pos = Ruby::Node::Position.new(@heredoc_beg.position.row + 1, 0)
        @heredoc << Ruby::StringContent.new(extract_src(pos, @heredoc.rdelim.position), pos)
      end
      
      protected
      
        def heredoc?
          !!@heredoc
        end
      
        def extra_heredoc_chars(token)
          if @heredoc && (token.newline? || token.comment?)
            token.value += @heredoc.to_ruby
            @heredoc_beg = @heredoc = nil
          end
          false
        end
    end
  end
end