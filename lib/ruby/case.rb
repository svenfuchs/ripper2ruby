require 'ruby/if'

module Ruby
  class Case < Node 
    child_accessor :expression, :when_block, :ldelim, :rdelim
    
    def initialize(expression, when_block, ldelim, rdelim)
      self.expression = expression
      self.when_block = when_block
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
      
    def nodes
      [ldelim, expression, when_block, rdelim].compact
    end
  end
  
  class When < Node 
    child_accessor :expression, :when_block, :next_block, :ldelim, :rdelim
    
    def initialize(expression, when_block, next_block = nil, ldelim = nil, rdelim = nil)
      self.expression = expression
      self.when_block = when_block
      self.next_block = next_block
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
      
    def nodes
      [ldelim, expression, rdelim, when_block, next_block].compact
    end
  end

end