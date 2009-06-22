class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Literal
      @@tokens = %w(class module def do begin rescue ensure retry end 
                    if unless then else elsif case when while until for in
                    not and or alias undef super yield return next redo break 
                    defined? BEGIN END)

      def on_kw(token)
        if @@tokens.include?(token)
          return push(super)
        elsif %w(nil false true).include?(token)
          build_literal(token, pop_whitespace)
        else
          Ruby::Keyword.new(token, position, pop_whitespace)
        end
      end
      
      def build_literal(token, whitespace)
        Ruby.const_get(token[0].upcase + token[1..-1]).new(token, position, whitespace)
      rescue NameError 
        Ruby::Keyword.new(token, position, whitespace)
      end

      def on_int(token)
        Ruby::Integer.new(token, position, pop_whitespace)
      end
      
      def on_float(token)
        Ruby::Float.new(token, position, pop_whitespace)
      end
      
      def on_dot2(left, right)
        Ruby::Range.new(left, pop_token(:'@..', :pass => true), right)
      end
      
      def on_dot3(left, right)
        Ruby::Range.new(left, pop_token(:'@...', :pass => true), right)
      end
      
      def on_CHAR(token)
        Ruby::Char.new(token, position, pop_whitespace)
      end
      
      def on_label(label)
        Ruby::Label.new(label, position, pop_whitespace)
      end
    end
  end
end