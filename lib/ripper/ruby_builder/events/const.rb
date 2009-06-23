class Ripper
  class RubyBuilder < Ripper::SexpBuilder
    module Const
      def on_const(token)
        push
        identifier = Ruby::Identifier.new(token, position, pop_whitespace)
        const = Ruby::Const.new(identifier)

        # ugh, how to clean this up? maybe eat namespaces at stack level (like whitespace)
        # if stack.peek.type == :'@::' && stack.peek.position && stack.peek.position.col == 
        pos = identifier.position(true)
        const.separator = pop_token(:'@::', :pos => [pos.row, pos.col - 2])
        const
      end
      
      def on_class(const, super_class, body)
        ldelim = pop_token(:@class)
        operator = super_class ? pop_token(:'@<') : nil
        rdelim = pop_token(:@end)
        Ruby::Class.new(const, operator, super_class, body, ldelim, rdelim)
      end
      
      def on_sclass(super_class, body)
        ldelim = pop_token(:@class)
        operator = pop_token(:'@<<')
        rdelim = pop_token(:@end)
        Ruby::Class.new(nil, operator, super_class, body, ldelim, rdelim)
      end

      def on_module(const, body)
        rdelim = pop_token(:@end)
        ldelim = pop_token(:@module)
        Ruby::Module.new(const, body, ldelim, rdelim)
      end
      
      def on_const_path_ref(namespace, const)
        const.namespace = namespace
        const
      end
      
      def on_const_path_field(namespace, const)
        const.namespace = namespace
        const
      end
      
      def on_top_const_ref(const)
        const
      end
    end
  end
end