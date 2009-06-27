class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module String
      def on_string_concat(*strings)
        Ruby::StringConcat.new(strings)
      end

      def on_string_literal(string)
        string_stack.pop if string == string_stack.last
        string.rdelim = pop_token(:@tstring_end) if string.respond_to?(:rdelim)
        string
      end

      def on_xstring_literal(string)
        string_stack.pop if string == string_stack.last # untested? xstring inside of heredoc or regular string
        string.rdelim = pop_token(:@tstring_end)
        string
      end

      def on_regexp_literal(string, rdelim)
        string_stack.pop if string == string_stack.last # untested? regexp inside of heredoc or regular string
        string.rdelim = pop_token(:@regexp_end)
        string
      end

      def on_heredoc_literal(*args)
        string_stack.each { |heredoc| push([:@heredoc, heredoc]) }
        string_stack.clear
        @heredoc_pos = nil
      end

      def on_string_add(string, content)
        if heredoc? && content
          string_stack.last << content
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
          string_stack << Ruby::String.new(pop_token(:@tstring_beg))
          string_stack.last
        end
      end

      def on_tstring_content(token)
        content = Ruby::StringContent.new(token, position, prolog)
        if heredoc?
          string_stack.last << content
          nil
        else
          content
        end
      end

      def on_word_new
        Ruby::String.new
      end

      def on_xstring_new(*args)
        ldelim = pop(:@symbeg, :@backtick, :@regexp_beg, :max => 1, :pass => true).first
        string_stack << build_xstring(ldelim)
        string_stack.last
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

      def on_string_dvar(variable)
        variable = Ruby::DelimitedVariable.new(variable)
        ldelim = pop_token(:@embvar)
        variable.ldelim = ldelim
        variable
      end

      def on_heredoc_beg(*args)
        token = push(super)
        string_stack << Ruby::Heredoc.new
        heredoc_pos(position.row + 1, 0) unless heredoc_pos
      end

      def on_heredoc_end(token)
        string_stack.last.rdelim = Ruby::Token.new(token, position)
        nil
      end

      protected

        def heredocs
          @heredoc ||= []
        end

        def heredoc?
          string_stack.last.is_a?(Ruby::Heredoc)
        end

        def heredoc_pos(*pos)
          pos.empty? ? @heredoc_pos : @heredoc_pos = Ruby::Node::Position.new(*pos)
        end

        def end_heredoc?(token)
          extra_heredoc_stage? && extra_heredoc_char?(token)
        end

        def extra_heredoc_stage?
          heredoc? && !!string_stack.last.rdelim
        end

        def extra_heredoc_char?(token)
          token && (token.newline? || token.comment?)
        end
    end
  end
end