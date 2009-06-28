class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Const
      def on_class(const, super_class, body)
        rdelim = pop_token(:@end)
        operator = super_class ? pop_token(:'@<') : nil
        ldelim = pop_token(:@class)
        Ruby::Class.new(const, operator, super_class, body, ldelim, rdelim)
      end
      
      def on_sclass(super_class, body)
        rdelim = pop_token(:@end)
        operator = pop_token(:'@<<')
        ldelim = pop_token(:@class)
        Ruby::Class.new(nil, operator, super_class, body, ldelim, rdelim)
      end

      def on_module(const, body)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@module)
        Ruby::Module.new(const, body, ldelim, rdelim)
      end
      
      def on_const_path_ref(namespace, const)
        const.prolog.unshift(pop_token(:'@::'))
        const.namespace = namespace
        const
      end
      
      def on_const_path_field(namespace, const)
        const.prolog.unshift(pop_token(:'@::'))
        const.namespace = namespace
        const
      end
      
      def on_top_const_ref(const)
        const.prolog.unshift(pop_token(:'@::'))
        const
      end
      
      def on_top_const_field(const)
        const.prolog.unshift(pop_token(:'@::'))
        const
      end
    end
  end
end