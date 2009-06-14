require 'ruby/node'

module Ruby
  class While < Body
    child_accessor :expression, :ldelim, :rdelim
    
    def initialize(expression, statements, ldelim = nil, rdelim = nil)
      self.expression = expression
      self.ldelim = ldelim
      self.rdelim = rdelim
      super(statements)
    end
      
    def nodes
      [ldelim, expression, super, rdelim].flatten.compact
    end
  end
  
  class Until < While; end

  class WhileMod < Node
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
  
  class UntilMod < WhileMod; end
end