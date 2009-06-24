require 'ruby/aggregate'

module Ruby
  class Const < DelimitedAggregate
    child_accessor :identifier, :namespace
    
    def initialize(token = nil, position = nil, context = nil, ldelim = nil)
      self.identifier = Ruby::Identifier.new(token, position, context)
      super(ldelim)
    end
    
    def nodes
      [namespace, ldelim, identifier].compact
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