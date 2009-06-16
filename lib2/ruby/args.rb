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
  
  class BlockArg < Node
    child_accessor :arg
    attr_accessor :ldelim
    
    def initialize(arg, ldelim)
      self.arg = arg
      self.ldelim = ldelim
    end
    
    def nodes
      [ldelim, arg]
    end
  end
end