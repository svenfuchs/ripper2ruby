require 'ruby/list'

module Ruby
  class ArgsList < DelimitedList
    def options
      last.is_a?(Ruby::Hash) ? last : nil
    end
    
    def set_option(key, value)
      if options.nil?
        self << { key => value } 
      else
        options[key] = value
      end
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