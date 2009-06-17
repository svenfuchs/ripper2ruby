require 'ruby/node'

module Ruby
  class Case < NamedNode 
    child_accessor :expression, :when_block
    
    def initialize(identifier, expression, when_block, rdelim)
      self.expression = expression
      self.when_block = when_block
      super(identifier, nil, rdelim)
    end
      
    def nodes
      [identifier, expression, when_block, rdelim].compact
    end
  end

  class When < NamedBlock 
    child_accessor :expression, :next_block
    
    def initialize(identifier, expression, statements, ldelim = nil, next_block = nil)
      self.expression = expression
      self.next_block = next_block
      super(identifier, statements, nil, nil, ldelim)
    end
      
    def nodes
      [identifier, expression, ldelim, contents, next_block, rdelim].flatten.compact
    end
  end
end