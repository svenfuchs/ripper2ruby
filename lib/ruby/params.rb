require 'ruby/aggregate'
require 'ruby/list'

module Ruby
  class Params < DelimitedList
  end
  
  class RestParam < DelimitedAggregate
    child_accessor :param
    
    def initialize(param, ldelim = nil)
      self.param = param
      super(ldelim)
    end
    
    def nodes
      [ldelim, param].compact
    end

    def method_missing(method, *args, &block)
      param.respond_to?(method) ? param.send(method, *args, &block) : super
    end
  end
end