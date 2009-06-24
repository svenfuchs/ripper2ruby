require 'ruby/node'

module Ruby
  class Aggregate < Node
    attr_writer :context

    def position(context = false)
      if context
        self.context.position rescue position(false)
      else
        nodes.each { |n| return n.position.dup if n } && nil
      end
    end

    def position=(position)
      nodes.each { |n| return n.position = position if n }
    end
    
    def context
      nodes.each { |n| return n.context if n } && nil
    end
    
    def context=(context)
      nodes.each { |n| return n.context = context if n }
    end
    
    def context
      nodes.each { |n| return n.context if n } && nil
    end
    
    def context=(context)
      nodes.each { |n| return n.context = context if n }
    end

    def to_ruby(context = false)
      nodes = self.nodes.compact
      first = nodes.shift
      (first ? first.to_ruby(context) : '') + nodes.map { |node| node.to_ruby(true) }.join
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
end