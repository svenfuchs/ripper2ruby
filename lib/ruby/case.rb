require 'ruby/node'

module Ruby
  class Case < NamedAggregate 
    child_accessor :expression, :block
    
    def initialize(identifier, expression, block, rdelim)
      self.expression = expression
      self.block = block
      super(identifier, nil, rdelim)
    end
      
    def nodes
      [identifier, expression, block, rdelim].compact
    end
  end

  class When < ChainedBlock 
    child_accessor :expression
    
    def initialize(identifier, expression, statements, ldelim = nil, block = nil)
      self.expression = expression
      super(identifier, [block], statements, nil, ldelim)
    end
      
    def nodes
      [identifier, expression, ldelim, elements, blocks, rdelim].flatten.compact
    end
  end
end