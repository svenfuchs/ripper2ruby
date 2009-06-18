require 'ruby/list'
require 'ruby/backfit/args'

module Ruby
  class ArgsList < DelimitedList
    include Backfit::ArgsList
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