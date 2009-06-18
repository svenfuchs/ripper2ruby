require 'ruby/list'

module Ruby
  class ArgsList < DelimitedList
    def options
      last.arg.is_a?(Ruby::Hash) ? last : nil
    end
    
    def set_option(key, value)
      if options.nil?
        self << to_node({key => value}, position.tap { |p| p[1] += length })
        # TODO gotta add a separator as well, maybe better replace the whole options hash
      else
        options[key] = to_node(value, options[key].position)
      end
    end
    
    protected
    
      def to_node(arg, position = nil, whitespace = nil)
        arg = super
        arg.is_a?(Arg) ? arg : Arg.new(arg)
      end
  end
  
  class Arg < DelimitedNode
    child_accessor :arg
    
    def initialize(arg, ldelim = nil)
      self.arg = arg
      super(ldelim)
    end
    
    def nodes
      [ldelim, arg].compact
    end

    def method_missing(method, *args, &block)
      arg.respond_to?(method) ? arg.send(method, *args, &block) : super
    end
  end
end