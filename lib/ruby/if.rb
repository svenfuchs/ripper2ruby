require 'ruby/node'

module Ruby
  class If < ChainedBlock 
    child_accessor :expression, :else_block

    def initialize(identifier, expression, statements = nil, ldelim = nil, rdelim = nil, else_block = nil)
      self.expression = expression
      super(identifier, [else_block], statements, nil, ldelim, rdelim)
    end
      
    def nodes
      [identifier, expression, ldelim, elements, blocks, rdelim].flatten.compact
    end
  end
  
  class Unless < If; end
  class Else < NamedBlock; end

  class IfMod < NamedBlock 
    child_accessor :expression
    
    def initialize(identifier, expression, statements)
      self.expression = expression
      super(identifier, statements)
    end
      
    def nodes
      [elements, identifier, expression].flatten.compact
    end
  end
  
  class UnlessMod < IfMod; end
  class RescueMod < IfMod; end
end