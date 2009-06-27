class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module String
      def on_string_concat(*strings)
        Ruby::StringConcat.new(strings)
      end

      def on_string_literal(string)
        string.rdelim = pop_token(:@tstring_end) unless string.is_a?(Ruby::HeredocBegin)
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
        if string.is_a?(Ruby::HeredocBegin)
          heredocs.last << content # TODO doesn't work when content spans multiple lines, or does it?
        elsif string && content
          string << content 
        end
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
        if ldelim = pop_token(:@heredoc_beg)
          @heredoc_beg = Ruby::HeredocBegin.new(ldelim.token, ldelim.position, ldelim.prolog)
        else
          tstring_stack << Ruby::String.new(pop_token(:@tstring_beg))
          tstring_stack.last
        end
      end

      def on_tstring_content(token)
        content = Ruby::StringContent.new(token, position, prolog)
        content
      end

      def on_xstring_new(*args)
        ldelim = pop(:@symbeg, :@backtick, :@regexp_beg, :max => 1, :pass => true).first
        tstring_stack << build_xstring(ldelim)
        tstring_stack.last
      end
      
      def build_xstring(token)
        case token.type
        when :@symbeg
          Ruby::DynaSymbol.new(build_token(token))
        when :@regexp_beg
          Ruby::Regexp.new(build_token(token))
        else
          Ruby::ExecutableString.new(build_token(token))
        end
      end

      def on_word_new
        Ruby::String.new
      end

      def on_string_dvar(variable)
        variable = Ruby::DelimitedVariable.new(variable)
        ldelim = pop_token(:@embvar)
        variable.ldelim = ldelim
        variable
      end

      def on_heredoc_beg(*args)
        token = push(super)
        heredocs << Ruby::Heredoc.new
        heredoc_pos(position.row + 1, 0) unless heredoc_pos
      end

      def on_heredoc_end(token)
        if pos = heredocs.last.position # TODO position calculation, move to position
          lines = heredocs.last.to_ruby.split("\n")
          row = pos.row + lines.size - 1
          col = lines.last.length
          heredoc_pos(row, col)
        end

        heredocs.last.rdelim = Ruby::Token.new(token, position)
        # should be able to add the string in on_string_add instead, no?
        content = Ruby::StringContent.new(extract_src(heredoc_pos, heredocs.last.rdelim.position), heredoc_pos)

        heredoc_pos(heredocs.last.rdelim.position.row + 1, 0)
        content
      end

      protected

        def heredocs
          @heredoc ||= []
        end

        def heredoc?
          !heredocs.empty?
        end
        
        def heredoc_pos(*pos)
          pos.empty? ? @heredoc_pos : @heredoc_pos = Ruby::Node::Position.new(*pos)
        end
        
        def extra_heredoc_stage?
          heredoc? && heredocs.last.rdelim
        end
        
        def extra_heredoc_char?(token)
          token && (token.newline? || token.comment?)
        end
        
        def end_heredoc(token)
          if extra_heredoc_stage? && extra_heredoc_char?(token)
            heredocs.each { |heredoc| push([:@heredoc, heredoc]) }
            @heredoc.clear
            @heredoc_beg = nil
          end
        end
    end
  end
end
