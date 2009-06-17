class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Const
      def on_const(token)
        Ruby::Const.new(token, position, pop_whitespace)
      end
      
      def on_class(const, super_class, body)
        rdelim = pop_token(:@end)
        operator = pop_token(:@op)
        ldelim = pop_token(:@class)
        Ruby::Class.new(const, operator, super_class, body, ldelim, rdelim)
      end

      def on_module(const, body)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@module)
        Ruby::Module.new(const, body, ldelim, rdelim)
      end
      
      def on_const_path_ref(namespace, const)
        const.namespace = namespace
        const.separator = pop_token(:@op, :value => '::')
        const
      end
    end
  end
end