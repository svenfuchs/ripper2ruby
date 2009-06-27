require 'ruby/aggregate'

module Ruby
  class Const < DelimitedAggregate
    child_accessor :identifier, :namespace
    
    def initialize(token = nil, position = nil, prolog = nil, ldelim = nil)
      self.identifier = Ruby::Identifier.new(token, position, prolog)
      super(ldelim)
    end
    
    def position(*)
      super
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

  class Class < NamedAggregate
    child_accessor :operator, :super_class, :body

    def initialize(const, operator, super_class, body, ldelim, rdelim)
      self.operator = operator
      self.super_class = super_class
      self.body = body
      super(const, ldelim, rdelim)
    end

    def nodes
      [ldelim, identifier, operator, super_class, body, rdelim].compact
    end
  end
end