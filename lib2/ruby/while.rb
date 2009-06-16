require 'ruby/node'

module Ruby
  class While < Statements
    child_accessor :expression
    
    def initialize(expression, statements, separators, ldelim = nil, rdelim = nil)
      self.expression = expression
      super(statements, separators, ldelim, rdelim)
    end
      
    def nodes
      [ldelim, expression, contents, rdelim].flatten.compact
    end
  end

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
  
  class Until < While; end
  class UntilMod < WhileMod; end
end