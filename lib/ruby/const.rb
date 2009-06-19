require 'ruby/aggregate'

module Ruby
  class Const < Aggregate
    child_accessor :identifier, :namespace, :separator
    
    def initialize(identifier = nil)
      self.identifier = identifier
    end
    
    def nodes
      [namespace, separator, identifier].compact
    end
  end
  
  class Module < DelimitedAggregate
    child_accessor :const, :body

    def initialize(const, body, ldelim, rdelim)
      self.const = const
      self.body = body
      super(ldelim, rdelim)
    end

    def nodes
      [ldelim, const, body, rdelim].compact
    end
  end

  class Class < DelimitedAggregate
    child_accessor :const, :operator, :super_class, :body

    def initialize(const, operator, super_class, body, ldelim, rdelim)
      self.const = const
      self.operator = operator
      self.super_class = super_class
      self.body = body
      super(ldelim, rdelim)
    end

    def nodes
      [ldelim, const, operator, super_class, body, rdelim].compact
    end
  end
end