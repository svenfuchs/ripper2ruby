class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module String
      def on_string_literal(string)
        string.rdelim = pop_delim(:@tstring_end)
        string
      end

      def on_xstring_literal(string)
        string.rdelim = pop_delim(:@tstring_end)
        string
      end

      def on_string_add(string, content)
        string << content and string
      end

      def on_xstring_add(string, content)
        string.tap { |s| s << content }
      end

      def on_string_content
        Ruby::String.new(pop_delim(:@tstring_beg))
      end

      def on_xstring_new(*args)
        ldelim = pop(:@symbeg, :@backtick, :max => 1).first
        case ldelim.type
        when :@symbeg
          Ruby::DynaSymbol.new(build_token(ldelim))
        when :@backtick
          Ruby::String.new(build_token(ldelim))
        end
      end

      def on_tstring_content(token)
        Ruby::StringContent.new(token, position)
      end

    end
  end
end