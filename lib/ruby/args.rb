require 'ruby/aggregate'
require 'ruby/list'
require 'ruby/alternation/args'

module Ruby
  class ArgsList < DelimitedList
    include Alternation::ArgsList

    def initialize(args = nil, ldelim = nil, rdelim = nil)
      args = Array(args).map { |arg| arg.is_a?(Ruby::Arg) ? arg : Ruby::Arg.new(arg) }
      super
    end
    
    def <<(arg)
      arg = Ruby::Arg.new(arg) unless arg.is_a?(Ruby::Arg)
      super
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