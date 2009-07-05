require 'ruby/aggregate'
require 'ruby/list'

module Ruby
  class Params < DelimitedList
    def initialize(params = nil, ldelim = nil, rdelim = nil)
      params = Array(params).map { |param| param.is_a?(Ruby::Param) ? param : Ruby::Param.new(param) }
      super
    end
    
    def <<(param)
      param = Ruby::Param.new(param) unless param.is_a?(Ruby::Param)
      super
    end
  end
  
  class Param < DelimitedAggregate
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
  
  class RescueParams < Params
    def initialize(types, var, operator)
      types = Ruby::Array.new(types) if types
      errors = var ? Ruby::Assoc.new(types, var, operator) : types
      super(errors)
    end
  end
end