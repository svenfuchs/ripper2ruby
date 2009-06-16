class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Const
      def on_const(token)
        Ruby::Const.new(token, position, pop_whitespace)
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
      
      def on_const_path_ref(namespace, const)
        const.namespace = namespace
        const.separator = stack_ignore(:@period, :@semicolon, :@op) { pop_delim(:@op, :value => '::') }
        const
      end
    end
  end
end