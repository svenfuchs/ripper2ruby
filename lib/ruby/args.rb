require 'ruby/aggregate'
require 'ruby/list'
require 'ruby/backfit/args'

module Ruby
  class ArgsList < DelimitedList
    include Backfit::ArgsList
    
    def to_heredoc_args_list
      if heredoc = elements.first
        separators = heredoc.separators
        heredoc.separators.empty!
      end
      HeredocArgsList.new(elements, separators, ldelim, rdelim)
    end
  end
  
  class HeredocArgsList < ArgsList
    def nodes
      nodes = elements.dup
      heredoc = nodes.shift.arg
      nodes = separators + nodes + [ldelim, rdelim] + heredoc.nodes
      nodes.flatten.compact.sort
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