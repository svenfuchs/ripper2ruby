require 'ruby/aggregate'
require 'ruby/list'
require 'ruby/backfit/args'

module Ruby
  class ArgsList < DelimitedList
    include Backfit::ArgsList
    
    def to_heredoc_args_list
      HeredocArgsList.new(elements, ldelim, rdelim)
    end
  end
  
  class HeredocArgsList < ArgsList
    def nodes
      nodes = elements
      heredoc = nodes.shift.arg
      [nodes, ldelim, rdelim, heredoc.ldelim, heredoc.elements, heredoc.rdelim].flatten.compact.sort
    end
    
    def heredoc
      elements.first.arg
    end
    
    def heredoc_ldelim
      heredoc.ldelim
    end
    
    def heredoc_rest
      heredoc.elements + [heredoc.rdelim]
    end
  end
  
  class Arg < DelimitedAggregate
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