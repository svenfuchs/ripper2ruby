module Ruby
  module Alternation
    module ArgsList
      def options
        last.arg.is_a?(Ruby::Hash) ? last : nil
      end
    
      def set_option(key, value)
        if options.nil?
          # TODO gotta add a separator as well, so maybe better replace the whole options hash
          self << to_node({key => value}, position.tap { |p| p[1] += length })
        else
          options[key] = to_node(value, options[key].position, options[key].prolog)
        end
      end
    
      protected
    
        def to_node(arg, position = nil, prolog = nil)
          arg = super
          arg.is_a?(Arg) ? arg : Arg.new(arg)
        end
    end
  end
end