class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Core
      def on_ident(token)
        Ruby::Identifier.new(token, position, pop_whitespace)
      end

      @@tokens = %w(class module def do begin rescue ensure retry end 
                    if unless then else elsif case when while until for in
                    not and or alias undef super yield return next redo break 
                    defined? BEGIN END)

      def on_kw(token)
        if @@tokens.include?(token)
          return push(super)
        else
          Ruby::Keyword.new(token, position, pop_whitespace)
        end
      end

      def on_cvar(token)
        Ruby::Identifier.new(token, position)
      end

      def on_ivar(token)
        Ruby::Identifier.new(token, position)
      end

      def on_gvar(token)
        Ruby::Identifier.new(token, position)
      end

      def on_int(token)
        Ruby::Integer.new(token, position, pop_whitespace)
      end

      def on_float(token)
        Ruby::Float.new(token, position, pop_whitespace)
      end
      
      def on_dot2(left, right)
        Ruby::Range.new(left, pop_token(:@op, :value => '..'), right)
      end
      
      def on_dot3(left, right)
        Ruby::Range.new(left, pop_token(:@op, :value => '...'), right)
      end

      def on_const(token)
        Ruby::Const.new(token, position, pop_whitespace)
      end

      def on_const_path_ref(parent, const)
        separator = stack_ignore(:@period) { pop_token(:@op, :value => '::') }
        Ruby::Call.new(parent, separator, const) # TODO maybe do Ruby::ConstRef < Ruby::Call instead
      end

      def on_class(const, super_class, body)
        rdelim = pop_token(:@kw, :value => 'end')
        operator = pop_token(:@op)
        ldelim = pop_token(:@kw, :value => 'class')
        Ruby::Class.new(const, operator, super_class, body, ldelim, rdelim)
      end

      def on_module(const, body)
        rdelim = pop_token(:@kw, :value => 'end')
        ldelim = pop_token(:@kw, :value => 'module')
        Ruby::Module.new(const, body, ldelim, rdelim)
      end
      
      def on_BEGIN(statements)
        rdelim = pop_token(:@rbrace)
        ldelim = pop_token(:@lbrace)
        identifier = pop_token(:@kw, :value => 'BEGIN').to_identifier
        Ruby::NamedBlock.new(identifier, statements, ldelim, rdelim)
      end
    end
  end
end