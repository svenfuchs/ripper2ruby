class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Core
      def on_ident(token)
        Ruby::Identifier.new(token, position, pop_whitespace)
      end

      def on_kw(token)
        if %w(class module def if unless then else elsif while begin do end not and or defined?).include?(token)
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

      def on_const(token)
        Ruby::Const.new(token, position, pop_whitespace)
      end
      
      def on_const_path_ref(parent, const)
        separator = stack_ignore(:@period) { pop_delim(:@op, :value => '::') }
        Ruby::Call.new(parent, separator, const) # TODO maybe do Ruby::ConstRef < Ruby::Call instead
      end
      
      def on_class(const, super_class, body)
        rdelim = pop_delim(:@kw, :value => 'end')
        operator = pop_delim(:@op)
        ldelim = pop_delim(:@kw, :value => 'class')
        Ruby::Class.new(const, operator, super_class, body, ldelim, rdelim)
      end
      
      def on_module(const, body)
        rdelim = pop_delim(:@kw, :value => 'end')
        ldelim = pop_delim(:@kw, :value => 'module')
        Ruby::Module.new(const, body, ldelim, rdelim)
      end
    end
  end
end