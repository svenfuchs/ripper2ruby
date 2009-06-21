require 'ruby/aggregate'
require 'ruby/list'
require 'ruby/backfit/args'

module Ruby
  class ArgsList < DelimitedList
    include Backfit::ArgsList
    
    def to_heredoc_args_list
      HeredocArgsList.new(elements, separators, ldelim, rdelim)
    end
  end
  
  class HeredocArgsList < ArgsList
    def <<(arg)
      super if arg.arg.is_a?(Ruby::HereDoc)
    end
    
    def contents
      elements.flatten.compact.sort
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