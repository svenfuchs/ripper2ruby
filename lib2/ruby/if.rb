require 'ruby/node'

module Ruby
  class If < Node 
    child_accessor :args, :if_block, :else_block, :ldelim, :rdelim
    
    def initialize(args, if_block, else_block = nil, ldelim = nil, rdelim = nil)
      self.args = args
      self.if_block = if_block
      self.else_block = else_block
      self.ldelim = ldelim
      self.rdelim = rdelim
    end
      
    def nodes
      [ldelim, args, if_block, else_block, rdelim].compact
    end
  end
  
  class Unless < If; end
  class Else < Block; end

  class IfMod < Node 
    child_accessor :args, :statement, :ldelim
    
    def initialize(args, statement, ldelim)
      self.ldelim = ldelim
      self.args = args
      self.statement = statement
    end
      
    def nodes
      [statement, ldelim, args].compact
    end
  end
  
  class UnlessMod < IfMod; end
end