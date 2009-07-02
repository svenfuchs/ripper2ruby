require 'ruby/node'

module Ruby
  class Aggregate < Node
    def position(prolog = false)
      nodes = self.nodes
      nodes.unshift(self.prolog) if prolog
      nodes.compact.each { |n| return n.position.dup if n } && nil
    end

    def position=(position)
      nodes.each { |n| return n.position = position if n }
    end
    
    def prolog
      nodes.each { |n| return n.prolog if n } && nil
    end
    
    def prolog=(prolog)
      nodes.each { |n| return n.prolog = prolog if n }
    end

    def to_ruby(prolog = false)
      nodes = self.nodes.compact
      (nodes.shift.try(:to_ruby, prolog) || '') + nodes.map { |node| node.to_ruby(true) }.join
    end
  end
  
  class DelimitedAggregate < Aggregate
    child_accessor :ldelim, :rdelim
    
    def initialize(ldelim = nil, rdelim = nil)
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
  end
  
  class NamedAggregate < DelimitedAggregate
    child_accessor :identifier
    
    def initialize(identifier, ldelim = nil, rdelim = nil)
      self.identifier = identifier
      super(ldelim, rdelim)
    end
  end

  require 'ruby/token'
  class Variable < Token # TODO join with DelimitedVariable
  end
  
  class DelimitedVariable < DelimitedAggregate
    child_accessor :identifier
    
    def initialize(identifier, ldelim = nil)
      self.identifier = identifier
      super(ldelim)
    end
    
    def value
      identifier.token.to_sym
    end
    
    def nodes
      [ldelim, identifier].compact
    end

    def method_missing(method, *args, &block)
      identifier.respond_to?(method) ? identifier.send(method, *args, &block) : super
    end
  end
end