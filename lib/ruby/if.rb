require 'ruby/node'

module Ruby
  class If < Node 
    child_accessor :expression, :if_block, :else_block, :ldelim, :rdelim
    
    def initialize(expression, if_block, else_block, ldelim, rdelim)
      self.expression = expression
      self.if_block = if_block
      self.else_block = else_block
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
      
    def nodes
      [ldelim, expression, if_block, else_block, rdelim].compact
    end
  end
  
  class Unless < If; end

  class IfMod < Node 
    child_accessor :expression, :statement, :ldelim
    
    def initialize(expression, statement, ldelim)
      self.ldelim = ldelim
      self.expression = expression
      self.statement = statement
    end
      
    def nodes
      [statement, ldelim, expression].compact
    end
  end
  
  class UnlessMod < IfMod; end
end