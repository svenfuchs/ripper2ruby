require 'ruby/node'

module Ruby
  class Aggregate < Node
    attr_writer :whitespace

    def position(whitespace = false)
      if whitespace
        self.whitespace.position rescue position(false)
      else
        nodes.each { |n| return n.position.dup if n } && nil
      end
    end
    
    def position=(position)
      nodes.each { |n| return n.position = position if n }
    end
    
    def whitespace
      nodes.each { |n| return n.whitespace if n } && nil
    end
    
    def whitespace=(whitespace)
      nodes.each { |n| return n.whitespace = whitespace if n }
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