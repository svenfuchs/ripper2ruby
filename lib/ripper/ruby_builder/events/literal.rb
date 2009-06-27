class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Literal
      @@tokens = %w(class module def do begin rescue ensure retry end 
                    if unless then else elsif case when while until for in
                    not and or alias undef super yield return next redo break 
                    defined? BEGIN END)

      def on_kw(token)
        if @@tokens.include?(token)
          push(super) # these aren't passed to the next parser event, so we need them on the stack
        else
          push(super)
          build_keyword(pop_token(:"@#{token}"))
        end
      end

      def on_int(token)
        push
        Ruby::Integer.new(token, position, prolog)
      end
      
      def on_float(token)
        push
        Ruby::Float.new(token, position, prolog)
      end
      
      def on_dot2(left, right)
        Ruby::Range.new(left, pop_token(:'@..'), right)
      end
      
      def on_dot3(left, right)
        Ruby::Range.new(left, pop_token(:'@...'), right)
      end
      
      def on_CHAR(token)
        push
        Ruby::Char.new(token, position, prolog)
      end
      
      def on_label(label)
        push
        Ruby::Label.new(label, position, prolog)
      end
    end
  end
end