require 'ruby/params'

module Ruby
  class Body < Node
    child_accessor :statements
    
    def initialize(statements)
      self.statements = statements
    end
    
    def nodes
      statements
    end
  end
  
  class Block < Body
    child_accessor :params, :ldelim, :rdelim
    
    def initialize(statements, params, ldelim = nil, rdelim = nil)
      self.params = params
      self.ldelim = ldelim
      self.rdelim = rdelim
      super(statements)
    end
    
    def nodes
      [ldelim, params, super, rdelim].flatten.compact
    end
  end
end